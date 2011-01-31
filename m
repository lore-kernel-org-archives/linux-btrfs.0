From: cwillu <cwillu@cwillu.com>
Subject: Re: flush-btrfs-1 hangs when building openwrt
Date: Mon, 31 Jan 2011 05:08:29 -0600
Message-ID: <AANLkTiku-tRxDd7qJZcUUjynvD0Vv7q6B8zZwpDmCRyC@mail.gmail.com>
References: <4D3E8EF5.1050008@poelzi.org>
	<20110131105254.GA23422@attic.humilis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Daniel Poelzleithner <poelzi@poelzi.org>,
	linux-btrfs@vger.kernel.org
To: sander@humilis.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110131105254.GA23422@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 31, 2011 at 4:52 AM, Sander <sander@humilis.net> wrote:
> Daniel Poelzleithner wrote (ao):
>> Since update to 2.6.37 I can't build openwrt on my btrfs buildroot a=
nymore.
>> I'm not sure if this is related to the other flush-btrfs-1 thread.
>
> While I thought it was related to a dying disk used for backups, afte=
r
> your post I think it might not.
>
> Running 2.6.37 on openrd-client (ARM).
>
> It started with hanging jobs on the backup disk. I stopped cron and
> could kill most of the jobs. Some are still hanging though.
>
> Since then (uptime 12 days) I see hanging procmail processes, and an
> apt-get upgrade last week gave an unkillable dpkg process. All these =
have
> nothing to do with the backup disk. CPU is maxed out:
>
> top - 11:49:54 up 12 days, =A01:19, 31 users, =A0load average: 13.54,=
 13.41, 13.36
> Tasks: 201 total, =A013 running, 187 sleeping, =A0 0 stopped, =A0 1 z=
ombie
> Cpu(s): 41.5%us, 58.5%sy, =A00.0%ni, =A00.0%id, =A00.0%wa, =A00.0%hi,=
 =A00.0%si, =A00.0%st
> Mem: =A0 =A0515004k total, =A0 400824k used, =A0 114180k free, =A0 =A0=
 =A0 28k buffers
> Swap: =A04302560k total, =A0 173988k used, =A04128572k free, =A0 2029=
48k cached
>
> =A0PID USER =A0 =A0 =A0PR =A0NI =A0VIRT =A0RES =A0SHR S %CPU %MEM =A0=
 =A0TIME+ =A0COMMAND
> =A01592 ookhoi =A0 =A020 =A0 0 =A02716 =A0456 =A0348 S =A01.9 =A00.1 =
=A025:17.42 showNewMail2
> =A06761 ookhoi =A0 =A020 =A0 0 =A02736 1000 =A0704 S =A01.3 =A00.2 =A0=
61:21.93 top
> 27609 ookhoi =A0 =A020 =A0 0 =A02736 1264 =A0936 R =A01.3 =A00.2 =A0 =
0:01.06 top
> 30678 ookhoi =A0 =A020 =A0 0 =A02736 =A0892 =A0584 S =A01.3 =A00.2 =A0=
91:37.75 top
> =A06036 ookhoi =A0 =A039 =A019 =A02692 =A0 64 =A0 52 R =A01.0 =A00.0 =
869:46.32 procmail
> 11373 ookhoi =A0 =A039 =A019 =A04800 =A0 64 =A0 52 R =A01.0 =A00.0 71=
4:25.88 procmail
> 18871 root =A0 =A0 =A039 =A019 =A02540 =A0 32 =A0 20 R =A01.0 =A00.0 =
=A0 1528:51 lzop
> 18894 ookhoi =A0 =A039 =A019 =A02692 =A0 64 =A0 52 R =A01.0 =A00.0 61=
1:16.18 procmail
> 20305 ookhoi =A0 =A039 =A019 =A02692 =A0 68 =A0 56 R =A01.0 =A00.0 61=
0:51.97 procmail
> 20378 ookhoi =A0 =A039 =A019 =A02692 =A0 68 =A0 56 R =A01.0 =A00.0 61=
0:50.75 procmail
> 23661 ookhoi =A0 =A039 =A019 =A02692 =A0 80 =A0 68 R =A01.0 =A00.0 =A0=
 1308:23 procmail
> 25091 root =A0 =A0 =A020 =A0 0 =A0 =A0 0 =A0 =A00 =A0 =A00 S =A01.0 =A0=
0.0 =A0 0:25.63 flush-btrfs-2
> 26409 root =A0 =A0 =A039 =A019 =A02264 =A0 32 =A0 28 R =A01.0 =A00.0 =
=A0 1526:42 mv
> 27606 ookhoi =A0 =A039 =A019 =A09084 =A0 40 =A0 28 R =A01.0 =A00.0 =A0=
 3637:39 procmail
> 27910 root =A0 =A0 =A039 =A019 15096 3756 =A0304 R =A01.0 =A00.7 638:=
46.62 dpkg
> 11804 ookhoi =A0 =A039 =A019 =A04700 =A0 64 =A0 52 R =A00.6 =A00.0 71=
4:08.67 procmail
> =A0 =A03 root =A0 =A0 =A020 =A0 0 =A0 =A0 0 =A0 =A00 =A0 =A00 R =A00.=
3 =A00.0 =A0 9:39.76 ksoftirqd/0
>
>
> What can I do to provide more info?

alt-sysrq-w, and then the dmesg output, which will contain then a
backtrace for every blocked process.

(Be careful of typos, there sysrq keystrokes to do other less
diagnostic tasks that you won't want to hit by accident:
http://en.wikipedia.org/wiki/Magic_SysRq_key).
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
