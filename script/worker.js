// src/worker.js
var worker_default = {
    async scheduled(event, env, ctx) {
        await this.check(1);
    },
    async fetch(request, env, ctx) {
        await this.check(999);
        return new Response("Hello World!");
    },
    async check(count) {
        var rsp = await fetch("https://pb.p1gd0g.cc/api/collections/etfs/records");
        if (rsp.status !== 200) {
            console.log(rsp.status)
            console.log(rsp.statusText)
            return;
        }
        var data = await rsp.json();
        var etfs = data.items;
        for (let index = 0; index < etfs.length; index++) {
            const element = etfs[index];
            var updated = new Date(element.updated);
            var now = new Date(Date.now());
            // console.log(updated.getDate())
            // console.log(now)

            if (element.cs_1000_hour === null ||
                element.cs_1000_day === null ||
                element.cs_1000_minute === null) {
            } else if (updated.getDate() === now.getDate()) {
                continue
            }

            var csRspHour = await fetch(`https://api.p1gd0g.cc/Candlesticks?symbol=${element.symbol}&period=60&target=lp`);
            var csHourData = await csRspHour.json();

            var csRspDay = await fetch(`https://api.p1gd0g.cc/Candlesticks?symbol=${element.symbol}&period=1000&target=lp`);
            var csDayData = await csRspDay.json();

            var csRspMinute = await fetch(`https://api.p1gd0g.cc/Candlesticks?symbol=${element.symbol}&period=1&target=lp`);
            var csMinuteData = await csRspMinute.json();

            await fetch(`https://pb.p1gd0g.cc/api/collections/etfs/records/${element.id}`, {
                method: "PATCH",
                headers: {
                    "Content-Type": "application/json",
                    "p1gd0g_auth": "p1gd0g_secret",
                },
                body: JSON.stringify({
                    "cs_1000_hour": csHourData,
                    "cs_1000_day": csDayData,
                    "cs_1000_minute": csMinuteData,
                }),
            }
            );
            count--;
            if (count <= 0) {
                break;
            }
        }
    }
};
export {
    worker_default as default
};
//# sourceMappingURL=worker.js.map
