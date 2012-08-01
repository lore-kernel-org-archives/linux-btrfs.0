Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:45231 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab2HAV5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2012 17:57:41 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Date: Wed, 1 Aug 2012 23:57:39 +0200
Cc: Marc MERLIN <marc@merlins.org>, "Fajar A. Nugraha" <list@fajar.net>
References: <20120722185848.GA10089@merlins.org> <CAG1y0sdnyv4O8zab+WwLxZ6qUJTcVryrAgnDfv5eiAw+eZh-Gg@mail.gmail.com> <20120801062156.GI12695@merlins.org> (sfid-20120801_092856_229338_ABA84691)
In-Reply-To: <20120801062156.GI12695@merlins.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201208012357.39786.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Marc,

Am Mittwoch, 1. August 2012 schrieb Marc MERLIN:
> On Wed, Aug 01, 2012 at 01:08:46PM +0700, Fajar A. Nugraha wrote:
> > > It it were a random crappy SSD from a random vendor, I'd blame the
> > > SSD, but I have a hard time believing that samsung is selling SSDs
> > > that are slower than hard drives at random IO and 'seeks'.
> > 
> > You'd be surprised on how badly some vendors can screw up :)
> 
> At some point, it may come down to that indeed :-/
> I'm still hopefully that Samsung didn't, but we'll see.

Its getting quite strange.

I lost track of whether you did that already or not, but if you didn´t
please post some

vmstat 1

iostat -xd 1

on the device while it is being slow.

I am interested in wait I/O and latencies and disk utilization.


Comparison data of Intel SSD 320 in ThinkPad T520 during

merkaba:~> echo 3 > /proc/sys/drop_caches ; du -sch /usr

on BTRFS with Kernel 3.5:


martin@merkaba:~> vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 2  1  21556 4442668   2056 502352    0    0   194    85  247  120 11  2 87  0
 1  2  21556 4408888   2448 514884    0    0 11684   328 4975 24585  5 16 65 14
 1  0  21556 4389880   2448 528060    0    0 13400     0 4574 23452  2 16 68 14
 3  1  21556 4370068   2448 545052    0    0 18132     0 5499 27220  1 18 64 16
 1  0  21556 4350228   2448 555580    0    0 10856     0 4122 25339  3 16 67 14
 1  1  21556 4315604   2448 569756    0    0 12648     0 4647 31153  5 14 66 15
 0  1  21556 4295652   2456 581480    0    0 11548    56 4093 24618  2 13 69 16
 0  1  21556 4286720   2456 591580    0    0 10824     0 3750 21445  1 12 71 16
 0  1  21556 4266308   2456 603620    0    0 12932     0 4841 26447  4 12 68 17
 1  0  21556 4248228   2456 613808    0    0 10264     4 3703 22108  1 13 71 15
 5  1  21556 4231976   2456 624356    0    0 10540     0 3581 20436  1 10 72 17
 0  1  21556 4197168   2456 639108    0    0 12952     0 4738 28223  4 15 66 15
 4  1  21556 4178456   2456 650552    0    0 11656     0 4234 23480  2 14 68 16
 0  1  21556 4163616   2456 662992    0    0 13652     0 4619 26580  1 16 70 13
 4  1  21556 4138288   2456 675696    0    0 13352     0 4422 22254  1 16 70 13
 1  0  21556 4113204   2456 689060    0    0 13232     0 4312 21936  1 15 70 14
 0  1  21556 4085532   2456 704160    0    0 14972     0 4820 24238  1 16 69 14
 2  0  21556 4055740   2456 719644    0    0 15736     0 5099 25513  3 17 66 14
 0  1  21556 4028612   2456 734380    0    0 14504     0 4795 25052  3 15 68 14
 2  0  21556 3999108   2456 749040    0    0 14656    16 4672 21878  1 17 69 13
 1  1  21556 3972732   2456 762108    0    0 12972     0 4717 22411  1 17 70 13
 5  0  21556 3949684   2584 773484    0    0 11528    52 4837 24107  3 15 67 15
 1  0  21556 3912504   2584 787420    0    0 12156     0 4883 25201  4 15 67 14


martin@merkaba:~> iostat -xd 1 /dev/sda
Linux 3.5.0-tp520 (merkaba)     01.08.2012      _x86_64_        (4 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               1,29     1,44   11,58   12,78   684,74   299,75    80,81     0,24    9,86    0,95   17,93   0,29   0,71

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00 2808,00    0,00 11232,00     0,00     8,00     0,57    0,21    0,21    0,00   0,19  54,50

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00 2967,00    0,00 11868,00     0,00     8,00     0,63    0,21    0,21    0,00   0,21  60,90

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00    11,00 2992,00    4,00 11968,00    56,00     8,03     0,64    0,22    0,22    0,25   0,21  62,00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00 2680,00    0,00 10720,00     0,00     8,00     0,70    0,26    0,26    0,00   0,25  66,70

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00 3153,00    0,00 12612,00     0,00     8,00     0,72    0,23    0,23    0,00   0,22  69,30

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00 2769,00    0,00 11076,00     0,00     8,00     0,63    0,23    0,23    0,00   0,21  58,00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00 2523,00    1,00 10092,00     4,00     8,00     0,74    0,29    0,29    0,00   0,28  71,30

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00 3026,00    0,00 12104,00     0,00     8,00     0,73    0,24    0,24    0,00   0,21  64,00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00 3069,00    0,00 12276,00     0,00     8,00     0,67    0,22    0,22    0,00   0,20  62,00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00 3346,00    0,00 13384,00     0,00     8,00     0,64    0,19    0,19    0,00   0,18  59,90

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00 3188,00    0,00 12752,00     0,00     8,00     0,80    0,25    0,25    0,00   0,17  54,00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00 3433,00    0,00 13732,00     0,00     8,00     1,03    0,30    0,30    0,00   0,17  57,00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00 3565,00    0,00 14260,00     0,00     8,00     0,92    0,26    0,26    0,00   0,16  57,30

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00 3972,00    0,00 15888,00     0,00     8,00     1,13    0,29    0,29    0,00   0,16  62,90

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00 3743,00    0,00 14972,00     0,00     8,00     1,03    0,28    0,28    0,00   0,16  59,40

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00 3408,00    0,00 13632,00     0,00     8,00     1,08    0,32    0,32    0,00   0,17  56,70

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00 3730,00    3,00 14920,00    16,00     8,00     1,14    0,31    0,31    0,00   0,15  56,30




I also suggest to use fio with with the ssd-test example on the SSD. I
have some comparison data available for my setup. Heck it should be
publicly available in my ADMIN magazine article about fio. I used a bit
different fio jobs with block sizes of 2k to 16k, but its similar enough
and I might even have some 4k examples at hand or can easily create one.
I also raised size and duration a bit.

An example based on whats in my article:

[global]
ioengine=libaio
direct=1
iodepth=64
runtime=60

filename=testfile
size=2G
bsrange=2k-16k

refill_buffers=1

[randomwrite]
stonewall
rw=randwrite

[sequentialwrite]
stonewall
rw=write

[randomread]
stonewall
rw=randread

[sequentialread]
stonewall
rw=read

Remove bsrange if you want 4k blocks only. I put the writes above the
reads cause the writes with refill_buffers=1 initialize the testfile
with random data. It would contain only zeros which will be compressible
nicely by modern SandForce controllers otherwise. Above job is untested,
but it should do.

Please remove the test file and fstrim your disk unless you have discard
mount option on after having run any write tests. (Not necessarily after
each one ;).


Also I am interested in

merkaba:~> hdparm -I /dev/sda | grep -i queue
        Queue depth: 32
           *    Native Command Queueing (NCQ)

output for your SSD.

Try to load the ssd with different iodepths up to twice the amount
displayed by hdparm.

But note: a du -sch will not reach that high iodepth. I expect it to
get as low as an iodepth of one in that case. You see in my comparison
output that a single du -sch is not able to load the Intel SSD 320 fully,
but load is just about 50-70%. And iowait is just about 10-20%.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
