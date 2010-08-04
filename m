From: marcel partap <mpartap@gmx.net>
Subject: flush-btrfs-1 doing 1MiB/s (avg) writing on idle system??
Date: Wed, 04 Aug 2010 18:37:50 +0200
Message-ID: <4C59975E.9020904@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Dear BTRFS devs,
still trying to find the cause for https://bugzilla.kernel.org/show_bug.cgi?id=12309 i stumbled over the strange fact that the 
flush-btrfs-1 thread is writing about 1MiBps constantly onto my root fs, even after turning off io-prone BOINC and NTOP.. there are 
other threads doing minor IO but that seems unrelated.
My kernel is
> Linux handtuch 2.6.35 #1 SMP PREEMPT Mon Aug 2 13:55:56 CEST 2010 x86_64 AMD Phenom(tm) II X4 920 Processor AuthenticAMD GNU/Linux
with patch #488 from mentioned bug report applied. The partition is mounted
>/dev/root on / type btrfs (rw,noatime,noacl)
and btrfs filesystem show /dev/sda2 gives
> Label: none  uuid: 50719157-1813-4552-bcd5-65f85649e503
>         Total devices 1 FS bytes used 230.12GB
>         devid    1 size 465.58GB used 335.29GB path /dev/sda2
> Btrfs v0.19-16-g075587c-dirty
I have uploaded an archived blktrace for about 10 minutes at
http://hfopi.org/files/temp/btrfs-blktrace-idle.tar.bz2 (18M)
and the resulting diagram is
http://hfopi.org/files/temp/btrfs-blktrace-idle-trace.png
As i couldn't find an easy way to see what actually is located at these blocknumbers i am now kindly asking for assistance here - 
can anyone make any sense out of this? It surely makes me feel a lil' uncomfortable about my system's kosherness..
best regards,
marcel ;)
