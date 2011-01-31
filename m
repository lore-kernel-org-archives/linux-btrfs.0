From: Sander <sander@humilis.net>
Subject: Re: flush-btrfs-1 hangs when building openwrt
Date: Mon, 31 Jan 2011 11:52:54 +0100
Message-ID: <20110131105254.GA23422@attic.humilis.net>
References: <4D3E8EF5.1050008@poelzi.org>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Daniel Poelzleithner <poelzi@poelzi.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D3E8EF5.1050008@poelzi.org>
List-ID: <linux-btrfs.vger.kernel.org>

Daniel Poelzleithner wrote (ao):
> Since update to 2.6.37 I can't build openwrt on my btrfs buildroot anymore.
> I'm not sure if this is related to the other flush-btrfs-1 thread.

While I thought it was related to a dying disk used for backups, after
your post I think it might not.

Running 2.6.37 on openrd-client (ARM).

It started with hanging jobs on the backup disk. I stopped cron and
could kill most of the jobs. Some are still hanging though.

Since then (uptime 12 days) I see hanging procmail processes, and an
apt-get upgrade last week gave an unkillable dpkg process. All these have
nothing to do with the backup disk. CPU is maxed out:

top - 11:49:54 up 12 days,  1:19, 31 users,  load average: 13.54, 13.41, 13.36
Tasks: 201 total,  13 running, 187 sleeping,   0 stopped,   1 zombie
Cpu(s): 41.5%us, 58.5%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:    515004k total,   400824k used,   114180k free,       28k buffers
Swap:  4302560k total,   173988k used,  4128572k free,   202948k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 1592 ookhoi    20   0  2716  456  348 S  1.9  0.1  25:17.42 showNewMail2
 6761 ookhoi    20   0  2736 1000  704 S  1.3  0.2  61:21.93 top
27609 ookhoi    20   0  2736 1264  936 R  1.3  0.2   0:01.06 top
30678 ookhoi    20   0  2736  892  584 S  1.3  0.2  91:37.75 top
 6036 ookhoi    39  19  2692   64   52 R  1.0  0.0 869:46.32 procmail
11373 ookhoi    39  19  4800   64   52 R  1.0  0.0 714:25.88 procmail
18871 root      39  19  2540   32   20 R  1.0  0.0   1528:51 lzop
18894 ookhoi    39  19  2692   64   52 R  1.0  0.0 611:16.18 procmail
20305 ookhoi    39  19  2692   68   56 R  1.0  0.0 610:51.97 procmail
20378 ookhoi    39  19  2692   68   56 R  1.0  0.0 610:50.75 procmail
23661 ookhoi    39  19  2692   80   68 R  1.0  0.0   1308:23 procmail
25091 root      20   0     0    0    0 S  1.0  0.0   0:25.63 flush-btrfs-2
26409 root      39  19  2264   32   28 R  1.0  0.0   1526:42 mv
27606 ookhoi    39  19  9084   40   28 R  1.0  0.0   3637:39 procmail
27910 root      39  19 15096 3756  304 R  1.0  0.7 638:46.62 dpkg
11804 ookhoi    39  19  4700   64   52 R  0.6  0.0 714:08.67 procmail
    3 root      20   0     0    0    0 R  0.3  0.0   9:39.76 ksoftirqd/0


What can I do to provide more info?

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
