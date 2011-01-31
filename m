From: Sander <sander@humilis.net>
Subject: Re: flush-btrfs-1 hangs when building openwrt
Date: Mon, 31 Jan 2011 12:40:51 +0100
Message-ID: <20110131114051.GA11121@attic.humilis.net>
References: <4D3E8EF5.1050008@poelzi.org>
 <20110131105254.GA23422@attic.humilis.net>
 <AANLkTiku-tRxDd7qJZcUUjynvD0Vv7q6B8zZwpDmCRyC@mail.gmail.com>
 <20110131111818.GA4090@attic.humilis.net>
 <AANLkTi=e2+HEo7hSN9rudjCufV23UX9rsoGPe9HY=Mjz@mail.gmail.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sander@humilis.net, Daniel Poelzleithner <poelzi@poelzi.org>,
	linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=e2+HEo7hSN9rudjCufV23UX9rsoGPe9HY=Mjz@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

cwillu wrote (ao):
> On Mon, Jan 31, 2011 at 5:18 AM, Sander <sander@humilis.net> wrote:
> > cwillu wrote (ao):
> >> On Mon, Jan 31, 2011 at 4:52 AM, Sander <sander@humilis.net> wrote:
> >> > It started with hanging jobs on the backup disk. I stopped cron and
> >> > could kill most of the jobs. Some are still hanging though.
> >> >
> >> > Since then (uptime 12 days) I see hanging procmail processes, and an
> >> > apt-get upgrade last week gave an unkillable dpkg process. All these have
> >> > nothing to do with the backup disk. CPU is maxed out:
> >> >
> >> > top - 11:49:54 up 12 days, ?1:19, 31 users, ?load average: 13.54, 13.41, 13.36
> >> > Tasks: 201 total, ?13 running, 187 sleeping, ? 0 stopped, ? 1 zombie
> >> > Cpu(s): 41.5%us, 58.5%sy, ?0.0%ni, ?0.0%id, ?0.0%wa, ?0.0%hi, ?0.0%si, ?0.0%st
> >> > Mem: ? ?515004k total, ? 400824k used, ? 114180k free, ? ? ? 28k buffers
> >> > Swap: ?4302560k total, ? 173988k used, ?4128572k free, ? 202948k cached
> >> >
> >> > ?PID USER ? ? ?PR ?NI ?VIRT ?RES ?SHR S %CPU %MEM ? ?TIME+ ?COMMAND
> >> > ?1592 ookhoi ? ?20 ? 0 ?2716 ?456 ?348 S ?1.9 ?0.1 ?25:17.42 showNewMail2
> >> > ?6761 ookhoi ? ?20 ? 0 ?2736 1000 ?704 S ?1.3 ?0.2 ?61:21.93 top
> >> > 27609 ookhoi ? ?20 ? 0 ?2736 1264 ?936 R ?1.3 ?0.2 ? 0:01.06 top
> >> > 30678 ookhoi ? ?20 ? 0 ?2736 ?892 ?584 S ?1.3 ?0.2 ?91:37.75 top
> >> > ?6036 ookhoi ? ?39 ?19 ?2692 ? 64 ? 52 R ?1.0 ?0.0 869:46.32 procmail
> >> > 11373 ookhoi ? ?39 ?19 ?4800 ? 64 ? 52 R ?1.0 ?0.0 714:25.88 procmail
> >> > 18871 root ? ? ?39 ?19 ?2540 ? 32 ? 20 R ?1.0 ?0.0 ? 1528:51 lzop
> >> > 18894 ookhoi ? ?39 ?19 ?2692 ? 64 ? 52 R ?1.0 ?0.0 611:16.18 procmail
> >> > 20305 ookhoi ? ?39 ?19 ?2692 ? 68 ? 56 R ?1.0 ?0.0 610:51.97 procmail
> >> > 20378 ookhoi ? ?39 ?19 ?2692 ? 68 ? 56 R ?1.0 ?0.0 610:50.75 procmail
> >> > 23661 ookhoi ? ?39 ?19 ?2692 ? 80 ? 68 R ?1.0 ?0.0 ? 1308:23 procmail
> >> > 25091 root ? ? ?20 ? 0 ? ? 0 ? ?0 ? ?0 S ?1.0 ?0.0 ? 0:25.63 flush-btrfs-2
> >> > 26409 root ? ? ?39 ?19 ?2264 ? 32 ? 28 R ?1.0 ?0.0 ? 1526:42 mv
> >> > 27606 ookhoi ? ?39 ?19 ?9084 ? 40 ? 28 R ?1.0 ?0.0 ? 3637:39 procmail
> >> > 27910 root ? ? ?39 ?19 15096 3756 ?304 R ?1.0 ?0.7 638:46.62 dpkg
> >> > 11804 ookhoi ? ?39 ?19 ?4700 ? 64 ? 52 R ?0.6 ?0.0 714:08.67 procmail
> >> > ? ?3 root ? ? ?20 ? 0 ? ? 0 ? ?0 ? ?0 R ?0.3 ?0.0 ? 9:39.76 ksoftirqd/0
> >> >
> >> >
> >> > What can I do to provide more info?
> >>
> >> alt-sysrq-w, and then the dmesg output, which will contain then a
> >> backtrace for every blocked process.
> >
> > Thanks cwillu.
> >
> > Seems only two processes. And these are related to the backup disk
> > (which might or might not be broken: can't access it anymore).
> >
> > Nothing to do with the procmail and dpkg processes.
> >
> >
> > [1042949.513831] SysRq : Show Blocked State
> > [1042949.517776] ? task ? ? ? ? ? ? ? ?PC stack ? pid father
> > [1042949.523247] cat ? ? ? ? ? D c0475dd0 ? ? 0 30063 ? ? ?1 0x00000001
> > [1042949.529668] [<c0475dd0>] (schedule+0x344/0x398) from [<c04764ec>] (__mutex_lock_slowpath+0x64/0x88)
> > [1042949.538943] [<c04764ec>] (__mutex_lock_slowpath+0x64/0x88) from [<c01af0e8>] (do_lookup+0x90/0x128)
> > [1042949.548209] [<c01af0e8>] (do_lookup+0x90/0x128) from [<c01b03f4>] (do_last+0x198/0x5b8)
> > [1042949.556432] [<c01b03f4>] (do_last+0x198/0x5b8) from [<c01b20f8>] (do_filp_open+0x168/0x49c)
> > [1042949.565004] [<c01b20f8>] (do_filp_open+0x168/0x49c) from [<c01a555c>] (do_sys_open+0x58/0x11c)
> > [1042949.573838] [<c01a555c>] (do_sys_open+0x58/0x11c) from [<c0136ee0>] (ret_fast_syscall+0x0/0x2c)
> > [1042949.582750] cat ? ? ? ? ? D c0475dd0 ? ? 0 ?4591 ? ? ?1 0x00000001
> > [1042949.589152] [<c0475dd0>] (schedule+0x344/0x398) from [<c04764ec>] (__mutex_lock_slowpath+0x64/0x88)
> > [1042949.598418] [<c04764ec>] (__mutex_lock_slowpath+0x64/0x88) from [<c01af0e8>] (do_lookup+0x90/0x128)
> > [1042949.607687] [<c01af0e8>] (do_lookup+0x90/0x128) from [<c01b03f4>] (do_last+0x198/0x5b8)
> > [1042949.615910] [<c01b03f4>] (do_last+0x198/0x5b8) from [<c01b20f8>] (do_filp_open+0x168/0x49c)
> > [1042949.624482] [<c01b20f8>] (do_filp_open+0x168/0x49c) from [<c01a555c>] (do_sys_open+0x58/0x11c)
> > [1042949.633315] [<c01a555c>] (do_sys_open+0x58/0x11c) from [<c0136ee0>] (ret_fast_syscall+0x0/0x2c)
> 
> dpkg and procmail were just showing up for you in top because it was
> sorting by memory usage, which isn't what we were looking for here.

It was not. The CPU numbers were low due to a 'find' which consumes a
lot now and then. This one shows better:

top - 12:32:22 up 12 days,  2:01, 32 users,  load average: 13.48, 13.37, 13.39
Tasks: 199 total,  12 running, 186 sleeping,   0 stopped,   1 zombie
Cpu(s):  0.0%us, 75.4%sy,  0.0%ni, 24.6%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:    515004k total,   366200k used,   148804k free,       28k buffers
Swap:  4302560k total,   174188k used,  4128372k free,   170124k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
11804 ookhoi    39  19  4700   64   52 R  8.8  0.0 717:10.30 procmail
 6036 ookhoi    39  19  2692   64   52 R  8.5  0.0 872:47.95 procmail
18871 root      39  19  2540   32   20 R  8.5  0.0   1531:53 lzop
20305 ookhoi    39  19  2692   68   56 R  8.5  0.0 613:53.59 procmail
20378 ookhoi    39  19  2692   68   56 R  8.5  0.0 613:52.37 procmail
23661 ookhoi    39  19  2692   80   68 R  8.5  0.0   1311:24 procmail
27910 root      39  19 15096 3748  304 R  8.5  0.7 641:48.25 dpkg
11373 ookhoi    39  19  4800   64   52 R  8.2  0.0 717:27.50 procmail
18894 ookhoi    39  19  2692   64   52 R  8.2  0.0 614:17.80 procmail
26409 root      39  19  2264   32   28 R  8.2  0.0   1529:44 mv
27606 ookhoi    39  19  9084   40   28 R  8.2  0.0   3640:41 procmail
11120 root      20   0     0    0    0 S  5.6  0.0   0:02.94 flush-btrfs-2


> In your case, the blocking is almost certainly due to your failing
> disk.

Also for procmail and dpkg? Which do not operate on the disk that seems
to fail, and is located under /holding/ ?

Anyway, I'll reboot the machine this afternoon with the suspect disk
removed.

Thanks again for your reply cwillu.

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
