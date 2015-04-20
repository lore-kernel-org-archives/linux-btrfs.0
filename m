Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38141 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbbDTJvq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 05:51:46 -0400
Received: by wiun10 with SMTP id n10so84669433wiu.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 02:51:45 -0700 (PDT)
Message-ID: <5534CC2F.4080109@gmail.com>
Date: Mon, 20 Apr 2015 11:51:43 +0200
From: Marc Cousin <cousinmarc@gmail.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: snapshot destruction making IO extremely slow
References: <550E7917.5030602@gmail.com> <20150325011937.GB20767@twin.jikos.cz> <55129428.7090508@gmail.com> <20150330142532.GI32051@suse.cz> <55196740.1000705@gmail.com> <20150331170516.GD6821@suse.cz>
In-Reply-To: <20150331170516.GD6821@suse.cz>
Content-Type: multipart/mixed;
 boundary="------------030102090209020908030501"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030102090209020908030501
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 31/03/2015 19:05, David Sterba wrote:
> On Mon, Mar 30, 2015 at 05:09:52PM +0200, Marc Cousin wrote:
>>> So it would be good to sample the active threads and see where it's
>>> spending the time. It could be the somewhere in the rb-tree representing
>>> extents, but that's a guess.
>>>
>> I just need to be told how to do that :)
>>
>> Something like a perf top ?
> 
> for i in `pgrep btrfs`; do
>         ps $i
> 	sudo cat /proc/$i/stack 2>/dev/null
> done
> 
> and capture samples every second.
> 

Sorry, it took me a while to reproduce this (I needed to be in front of the machine when it happens :) )

It's not the same machine, anyway, but the problem is the same.

Here, it is on a SSD-backed storage, with a dm-crypt in between. The other machine where it occurs has nothing of this, btrfs uses bare disks.

Anyway, here it is.

First, to see when it happens:


while true; do date; time touch /home/test; time rm /home/test ; sleep 1; done

Here is an excerpt
lun. avril 20 11:42:24 CEST 2015

real    0m0.001s
user    0m0.003s
sys     0m0.000s

real    0m0.001s
user    0m0.000s
sys     0m0.000s
lun. avril 20 11:42:25 CEST 2015

real    0m0.001s
user    0m0.000s
sys     0m0.000s

real    0m0.001s
user    0m0.000s
sys     0m0.000s
lun. avril 20 11:42:26 CEST 2015

real    0m0.001s
user    0m0.000s
sys     0m0.000s

real    0m0.001s
user    0m0.000s
sys     0m0.000s
lun. avril 20 11:42:27 CEST 2015

real    1m2.225s   <---- ouch, more than one minute to touch a file.
user    0m0.000s
sys     0m0.000s

real    0m0.001s
user    0m0.000s
sys     0m0.000s
lun. avril 20 11:43:30 CEST 2015

real    0m0.001s
user    0m0.000s
sys     0m0.000s

real    0m0.001s
user    0m0.000s
sys     0m0.000s

There was almost nothing else happening on this machine. At least nothing IO-intensive.

On the same period, here is what happens on IOs (sorry, it's quite big):

iostat -x -m 1 -t

20/04/2015 11:42:23
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           5,78    0,00   30,15    0,00    0,00   64,07

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:24
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          10,50    0,00   31,00    0,00    0,00   58,50

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:25
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          14,36    0,00   36,67    0,00    0,00   48,97

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00  375,00     0,00     2,20    12,03     0,09    0,24    0,00    0,24   0,02   0,60
dm-0              0,00     0,00    0,00  375,00     0,00     2,20    12,03     1,22    3,26    0,00    3,26   0,02   0,70
dm-1              0,00     0,00    0,00  375,00     0,00     2,20    12,03     1,22    3,26    0,00    3,26   0,02   0,60
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:26
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          10,00    0,00   33,08    0,00    0,00   56,92

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    2,00    0,00     0,03     0,00    32,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    2,00    0,00     0,03     0,00    32,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    2,00    0,00     0,03     0,00    32,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:27
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          20,81    0,00   30,96    0,00    0,00   48,22

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    9,00    0,00     0,14     0,00    32,00     0,01    1,11    1,11    0,00   0,44   0,40
dm-0              0,00     0,00    9,00    0,00     0,14     0,00    32,00     0,01    1,11    1,11    0,00   0,33   0,30
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    9,00    0,00     0,14     0,00    32,00     0,01    1,11    1,11    0,00   0,33   0,30
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:28
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           8,84    0,00   31,82    0,25    0,00   59,09

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:29
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          15,91    0,00   34,34    0,00    0,00   49,75

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:30
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          10,78    0,00   35,34    0,25    0,00   53,63

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    2,00   14,00     1,04     0,05   138,50     0,03    2,06    3,50    1,86   1,25   2,00
dm-0              0,00     0,00    2,00   14,00     1,04     0,05   138,50     0,03    2,06    3,50    1,86   1,25   2,00
dm-1              0,00     0,00    0,00   12,00     0,00     0,05     8,00     0,02    1,42    0,00    1,42   1,42   1,70
dm-2              0,00     0,00    2,00    0,00     1,04     0,00  1060,00     0,01    3,50    3,50    0,00   2,00   0,40
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:31
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           8,31    0,00   27,20    0,50    0,00   63,98

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:32
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           9,50    0,00   34,00    0,00    0,00   56,50

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:33
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          15,29    0,00   35,09    0,00    0,00   49,62

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:34
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           8,47    0,00   33,90    0,00    0,00   57,63

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:35
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          15,12    0,00   31,95    0,00    0,00   52,93

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    2,00    0,00     0,01     0,00     8,00     0,00    1,50    1,50    0,00   1,50   0,30
dm-0              0,00     0,00    2,00    0,00     0,01     0,00     8,00     0,00    1,50    1,50    0,00   1,50   0,30
dm-1              0,00     0,00    2,00    0,00     0,01     0,00     8,00     0,00    1,50    1,50    0,00   1,50   0,30
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:36
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          21,45    0,00   37,59    0,00    0,00   40,96

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    6,00     0,00     0,02     5,33     0,01    1,67    0,00    1,67   1,17   0,70
dm-0              0,00     0,00    0,00    6,00     0,00     0,02     5,33     0,01    1,67    0,00    1,67   1,17   0,70
dm-1              0,00     0,00    0,00    4,00     0,00     0,02     8,00     0,01    1,50    0,00    1,50   1,75   0,70
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:37
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           7,90    0,00   32,84    0,00    0,00   59,26

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:38
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           4,53    0,00   28,21    0,00    0,00   67,25

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:39
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          14,25    0,00   36,00    0,00    0,00   49,75

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    1,00     0,00     0,00     8,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    1,00     0,00     0,00     8,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    1,00     0,00     0,00     8,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:40
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           9,18    0,00   33,00    0,00    0,00   57,82

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00  616,00     0,00     4,41    14,66     0,95    1,55    0,00    1,55   0,02   1,30
dm-0              0,00     0,00    0,00  616,00     0,00     4,41    14,66     5,01    8,14    0,00    8,14   0,02   1,30
dm-1              0,00     0,00    0,00  616,00     0,00     4,41    14,66     5,01    8,14    0,00    8,14   0,02   1,30
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:41
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           9,27    0,00   32,08    0,25    0,00   58,40

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00   10,00     0,00     0,03     6,40     0,01    1,30    0,00    1,30   1,00   1,00
dm-0              0,00     0,00    0,00   10,00     0,00     0,03     6,40     0,01    1,30    0,00    1,30   1,00   1,00
dm-1              0,00     0,00    0,00    8,00     0,00     0,03     8,00     0,01    1,25    0,00    1,25   1,25   1,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:42
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          10,10    0,00   29,29    0,00    0,00   60,61

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:43
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          10,84    0,00   33,74    0,25    0,00   55,17

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:44
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           9,55    0,00   34,42    0,00    0,00   56,03

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:45
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           9,34    0,00   29,80    0,00    0,00   60,86

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:46
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           3,02    0,00   29,72    0,00    0,00   67,25

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:47
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           6,55    0,00   31,49    0,25    0,00   61,71

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    6,00     0,00     0,02     5,33     0,01    1,67    0,00    1,67   1,17   0,70
dm-0              0,00     0,00    0,00    6,00     0,00     0,02     5,33     0,01    1,67    0,00    1,67   1,17   0,70
dm-1              0,00     0,00    0,00    4,00     0,00     0,02     8,00     0,01    1,50    0,00    1,50   1,75   0,70
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:48
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           7,04    0,00   31,41    0,00    0,00   61,56

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:49
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           3,26    0,00   26,57    0,00    0,00   70,18

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:50
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           4,53    0,00   31,23    0,00    0,00   64,23

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:51
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          16,46    0,00   33,67    0,00    0,00   49,88

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:52
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           5,01    0,00   31,58    0,00    0,00   63,41

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:53
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           3,26    0,00   27,32    0,00    0,00   69,42

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:54
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          10,78    0,00   32,33    0,00    0,00   56,89

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     2,00    0,00   10,00     0,00     0,04     8,00     0,01    1,00    0,00    1,00   0,60   0,60
dm-0              0,00     0,00    0,00   12,00     0,00     0,04     6,67     0,01    0,83    0,00    0,83   0,58   0,70
dm-1              0,00     0,00    0,00    4,00     0,00     0,02     8,00     0,01    1,75    0,00    1,75   1,75   0,70
dm-2              0,00     0,00    0,00    6,00     0,00     0,02     8,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:55
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           8,33    0,00   33,84    0,00    0,00   57,83

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00  422,00     0,00     2,28    11,07     0,01    0,04    0,00    0,04   0,02   1,00
dm-0              0,00     0,00    0,00  422,00     0,00     2,28    11,07     2,36    5,59    0,00    5,59   0,02   1,00
dm-1              0,00     0,00    0,00  422,00     0,00     2,28    11,07     2,36    5,59    0,00    5,59   0,02   1,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:56
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           5,03    0,00   30,15    0,00    0,00   64,82

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:57
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          19,90    0,00   28,26    0,00    0,00   51,84

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:58
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          30,90    0,00   36,68    0,00    0,00   32,41

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:42:59
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          34,59    0,00   33,58    0,00    0,00   31,83

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:00
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          27,14    0,00   29,65    0,50    0,00   42,71

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    7,00     0,00     0,02     5,71     0,02    2,29    0,00    2,29   2,00   1,40
dm-0              0,00     0,00    0,00    7,00     0,00     0,02     5,71     0,02    2,29    0,00    2,29   1,86   1,30
dm-1              0,00     0,00    0,00    5,00     0,00     0,02     8,00     0,01    2,60    0,00    2,60   2,60   1,30
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:01
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          23,38    0,00   32,09    0,00    0,00   44,53

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:02
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           9,32    0,00   31,99    0,00    0,00   58,69

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:03
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          12,85    0,00   31,74    0,00    0,00   55,42

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00   19,00    1,00     0,34     0,00    35,20     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00   19,00    1,00     0,34     0,00    35,20     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00   19,00    0,00     0,34     0,00    36,63     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    1,00     0,00     0,00     8,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:04
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           4,00    0,00   28,25    0,00    0,00   67,75

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:05
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           7,05    0,00   32,49    0,00    0,00   60,45

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:06
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          11,72    0,00   33,92    0,50    0,00   53,87

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00   15,00     0,00     0,05     6,93     0,01    0,93    0,00    0,93   0,67   1,00
dm-0              0,00     0,00    0,00   15,00     0,00     0,05     6,93     0,01    0,93    0,00    0,93   0,67   1,00
dm-1              0,00     0,00    0,00   13,00     0,00     0,05     8,00     0,01    0,77    0,00    0,77   0,77   1,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:07
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           3,53    0,00   27,71    0,00    0,00   68,77

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:08
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           4,80    0,00   29,80    0,00    0,00   65,40

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:09
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          10,13    0,00   32,41    0,00    0,00   57,47

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    6,00     0,00     0,02     8,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    6,00     0,00     0,02     8,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    6,00     0,00     0,02     8,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:10
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           4,29    0,00   33,08    0,00    0,00   62,63

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00  584,00     0,00     4,38    15,34     1,08    1,85    0,00    1,85   0,02   1,00
dm-0              0,00     0,00    0,00  584,00     0,00     4,38    15,34     3,34    5,71    0,00    5,71   0,02   1,00
dm-1              0,00     0,00    0,00  584,00     0,00     4,38    15,34     3,34    5,71    0,00    5,71   0,02   1,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:11
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           4,76    0,00   28,07    0,25    0,00   66,92

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    7,00     0,00     0,02     5,71     0,02    2,29    0,00    2,29   1,86   1,30
dm-0              0,00     0,00    0,00    7,00     0,00     0,02     5,71     0,02    2,43    0,00    2,43   1,86   1,30
dm-1              0,00     0,00    0,00    5,00     0,00     0,02     8,00     0,01    2,60    0,00    2,60   2,60   1,30
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:12
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           6,30    0,00   30,23    0,00    0,00   63,48

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:13
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          15,33    0,00   36,43    0,25    0,00   47,99

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:14
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           6,53    0,00   32,66    0,00    0,00   60,80

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:15
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           7,52    0,00   27,57    0,00    0,00   64,91

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:16
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           4,75    0,00   31,00    0,00    0,00   64,25

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:17
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           8,02    0,00   31,08    0,25    0,00   60,65

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    6,00     0,00     0,02     5,33     0,02    2,83    0,00    2,83   2,17   1,30
dm-0              0,00     0,00    0,00    6,00     0,00     0,02     5,33     0,02    2,83    0,00    2,83   2,33   1,40
dm-1              0,00     0,00    0,00    4,00     0,00     0,02     8,00     0,01    3,25    0,00    3,25   3,50   1,40
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:18
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          11,03    0,00   32,83    0,00    0,00   56,14

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:19
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           4,50    0,00   26,25    0,75    0,00   68,50

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:20
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           7,96    0,00   32,09    0,00    0,00   59,95

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:21
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          11,69    0,00   34,33    0,00    0,00   53,98

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:22
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           5,04    0,00   32,24    0,00    0,00   62,72

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:23
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           3,78    0,00   26,20    0,00    0,00   70,03

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:24
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           9,82    0,00   33,75    0,25    0,00   56,17

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00   14,00     0,00     0,05     6,86     0,02    1,21    0,00    1,21   0,71   1,00
dm-0              0,00     0,00    0,00   14,00     0,00     0,05     6,86     0,02    1,14    0,00    1,14   0,71   1,00
dm-1              0,00     0,00    0,00   11,00     0,00     0,04     8,00     0,01    0,91    0,00    0,91   0,91   1,00
dm-2              0,00     0,00    0,00    1,00     0,00     0,00     8,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:25
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           6,28    0,00   31,41    0,00    0,00   62,31

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00   10,00     0,00     0,04     8,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00   10,00     0,00     0,04     8,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00   10,00     0,00     0,04     8,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:26
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           5,79    0,00   30,48    0,00    0,00   63,73

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:27
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           7,58    0,00   28,79    0,00    0,00   63,64

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:28
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           6,30    0,00   31,74    0,00    0,00   61,96

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

20/04/2015 11:43:29
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          10,78    0,00   32,08    0,00    0,00   57,14

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00

There is only one disk. Here is the mapping

# lsblk 
NAME                       MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda                          8:0    0 894,3G  0 disk  
├─sda1                       8:1    0     2M  0 part  
├─sda2                       8:2    0   200M  0 part  /boot
└─sda3                       8:3    0 894,1G  0 part  
  └─lvm                    254:0    0 894,1G  0 crypt 
    ├─datavg-rootlv        254:1    0    25G  0 lvm   /
    ├─datavg-homelv        254:2    0   830G  0 lvm   /home
    └─datavg-swaplv        254:3    0     2G  0 lvm   [SWAP]



Attached is, as required, the result of this script:

#!/bin/sh
export LANG=C

while true; do
        date
        echo '============================================'
        for i in `pgrep btrfs`; do
                ps $i
                sudo cat /proc/$i/stack 2>/dev/null
        done
sleep 1
done


over the same period.

Please telle me if there is something more I can provide.

Regards

Marc

--------------030102090209020908030501
Content-Type: application/gzip;
 name="btrfs_capture.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="btrfs_capture.gz"

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
--------------030102090209020908030501--
