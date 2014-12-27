Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-05v.sys.comcast.net ([69.252.207.37]:50316 "EHLO
	resqmta-ch2-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750795AbaL0Oyg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 09:54:36 -0500
Message-ID: <549EC829.8080808@pobox.com>
Date: Sat, 27 Dec 2014 06:54:33 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>, Hugo Mills <hugo@carfax.org.uk>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
References: <3738341.y7uRQFcLJH@merkaba> <4232026.31LFOYpm2s@merkaba> <20141227093043.GJ25267@carfax.org.uk> <2235526.D1sZ4Blnlh@merkaba>
In-Reply-To: <2235526.D1sZ4Blnlh@merkaba>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/27/2014 05:55 AM, Martin Steigerwald wrote:
> Summarized at
>
> Bug 90401 - btrfs kworker thread uses up 100% of a Sandybridge core for minutes on random write into big file
> https://bugzilla.kernel.org/show_bug.cgi?id=90401
>
> see below. This is reproducable with fio, no need for Windows XP in
> Virtualbox for reproducing the issue. Next I will try to reproduce with
> a freshly creating filesystem.
>
>
> Am Samstag, 27. Dezember 2014, 09:30:43 schrieb Hugo Mills:
>> On Sat, Dec 27, 2014 at 10:01:17AM +0100, Martin Steigerwald wrote:
>>> Am Freitag, 26. Dezember 2014, 14:48:38 schrieb Robert White:
>>>> On 12/26/2014 05:37 AM, Martin Steigerwald wrote:
>>>>> Hello!
>>>>>
>>>>> First: Have a merry christmas and enjoy a quiet time in these days.
>>>>>
>>>>> Second: At a time you feel like it, here is a little rant, but also a
>>>>> bug
>>>>> report:
>>>>>
>>>>> I have this on 3.18 kernel on Debian Sid with BTRFS Dual SSD RAID with
>>>>> space_cache, skinny meta data extents – are these a problem? – and
>>>>
>>>>> compress=lzo:
>>>> (there is no known problem with skinny metadata, it's actually more
>>>> efficient than the older format. There has been some anecdotes about
>>>> mixing the skinny and fat metadata but nothing has ever been
>>>> demonstrated problematic.)
>>>>
>>>>> merkaba:~> btrfs fi sh /home
>>>>> Label: 'home'  uuid: b96c4f72-0523-45ac-a401-f7be73dd624a
>>>>>
>>>>>           Total devices 2 FS bytes used 144.41GiB
>>>>>           devid    1 size 160.00GiB used 160.00GiB path
>>>>>           /dev/mapper/msata-home
>>>>>           devid    2 size 160.00GiB used 160.00GiB path
>>>>>           /dev/mapper/sata-home
>>>>>
>>>>> Btrfs v3.17
>>>>> merkaba:~> btrfs fi df /home
>>>>> Data, RAID1: total=154.97GiB, used=141.12GiB
>>>>> System, RAID1: total=32.00MiB, used=48.00KiB
>>>>> Metadata, RAID1: total=5.00GiB, used=3.29GiB
>>>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>>>
>>>> This filesystem, at the allocation level, is "very full" (see below).
>>>>
>>>>> And I had hangs with BTRFS again. This time as I wanted to install tax
>>>>> return software in Virtualbox´d Windows XP VM (which I use once a year
>>>>> cause I know no tax return software for Linux which would be suitable
>>>>> for
>>>>> Germany and I frankly don´t care about the end of security cause all
>>>>> surfing and other network access I will do from the Linux box and I
>>>>> only
>>>>> run the VM behind a firewall).
>>>>
>>>>> And thus I try the balance dance again:
>>>> ITEM: Balance... it doesn't do what you think it does... 8-)
>>>>
>>>> "Balancing" is something you should almost never need to do. It is only
>>>> for cases of changing geometry (adding disks, switching RAID levels,
>>>> etc.) of for cases when you've radically changed allocation behaviors
>>>> (like you decided to remove all your VM's or you've decided to remove a
>>>> mail spool directory full of thousands of tiny files).
>>>>
>>>> People run balance all the time because they think they should. They are
>>>> _usually_ incorrect in that belief.
>>>
>>> I only see the lockups of BTRFS is the trees *occupy* all space on the
>>> device.
>>     No, "the trees" occupy 3.29 GiB of your 5 GiB of mirrored metadata
>> space. What's more, balance does *not* balance the metadata trees. The
>> remaining space -- 154.97 GiB -- is unstructured storage for file
>> data, and you have some 13 GiB of that available for use.
>>
>>     Now, since you're seeing lockups when the space on your disks is
>> all allocated I'd say that's a bug. However, you're the *only* person
>> who's reported this as a regular occurrence. Does this happen with all
>> filesystems you have, or just this one?
>>
>>> I *never* so far saw it lockup if there is still space BTRFS can allocate
>>> from to *extend* a tree.
>>
>>     It's not a tree. It's simply space allocation. It's not even space
>> *usage* you're talking about here -- it's just allocation (i.e. the FS
>> saying "I'm going to use this piece of disk for this purpose").
>>
>>> This may be a bug, but this is what I see.
>>>
>>> And no amount of "you should not balance a BTRFS" will make that
>>> perception go away.
>>>
>>> See, I see the sun coming out on a morning and you tell me "no, it
>>> doesn´t". Simply that is not going to match my perception.
>>
>>     Duncan's assertion is correct in its detail. Looking at your space
>
> Robert's :)
>
>> usage, I would not suggest that running a balance is something you
>> need to do. Now, since you have these lockups that seem quite
>> repeatable, there's probably a lurking bug in there, but hacking
>> around with balance every time you hit it isn't going to get the
>> problem solved properly.
>>
>>     I think I would suggest the following:
>>
>>   - make sure you have some way of logging your dmesg permanently (use
>>     a different filesystem for /var/log, or a serial console, or a
>>     netconsole)
>>
>>   - when the lockup happens, hit Alt-SysRq-t a few times
>>
>>   - send the dmesg output here, or post to bugzilla.kernel.org
>>
>>     That's probably going to give enough information to the developers
>> to work out where the lockup is happening, and is clearly the way
>> forward here.
>
> And I got it reproduced. *Perfectly* reproduced, I´d say.
>
> But let me run the whole story:
>
> 1) I downsized my /home BTRFS from dual 170 GiB to dual 160 GiB again.
>
> Which gave me:
>
> merkaba:~> btrfs fi sh /home
> Label: 'home'  uuid: b96c4f72-0523-45ac-a401-f7be73dd624a
>          Total devices 2 FS bytes used 144.19GiB
>          devid    1 size 160.00GiB used 150.01GiB path /dev/mapper/msata-home
>          devid    2 size 160.00GiB used 150.01GiB path /dev/mapper/sata-home
>
> Btrfs v3.17
> merkaba:~> btrfs fi df /home
> Data, RAID1: total=144.98GiB, used=140.95GiB
> System, RAID1: total=32.00MiB, used=48.00KiB
> Metadata, RAID1: total=5.00GiB, used=3.24GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
>
> 2) I run the Virtualbox machine again and defragmented the NTFS filesystem
> in the VDI image file. And: It worked *just* fine. Fine as in *fine*. No issues
> whatsoever.
>
>
> I got this during the run:
>
> ATOP - merkaba                          2014/12/27  12:58:42                          -----------                           10s elapsed
> PRC |  sys   10.41s |  user   1.08s |  #proc    357  | #trun      4  |  #tslpi   694 |  #tslpu     0 |  #zombie    0  | no  procacct  |
> CPU |  sys     107% |  user     11% |  irq       0%  | idle    259%  |  wait     23% |  guest     0% |  curf 3.01GHz  | curscal  93%  |
> cpu |  sys      29% |  user      3% |  irq       0%  | idle     63%  |  cpu002 w  5% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> cpu |  sys      27% |  user      3% |  irq       0%  | idle     65%  |  cpu000 w  5% |  guest     0% |  curf 3.03GHz  | curscal  94%  |
> cpu |  sys      26% |  user      3% |  irq       0%  | idle     63%  |  cpu003 w  8% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> cpu |  sys      24% |  user      2% |  irq       0%  | idle     68%  |  cpu001 w  6% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> CPL |  avg1    1.92 |  avg5    1.01 |  avg15   0.56  |               |  csw   501619 |  intr  129279 |                | numcpu     4  |
> MEM |  tot    15.5G |  free  610.1M |  cache   9.1G  | buff    0.1M  |  slab    1.0G |  shmem 183.5M |  vmbal   0.0M  | hptot   0.0M  |
> SWP |  tot    12.0G |  free   11.6G |                |               |               |               |  vmcom   7.1G  | vmlim  19.7G  |
> PAG |  scan  219141 |  steal 215577 |  stall    936  |               |               |               |  swin       0  | swout    940  |
> LVM |     sata-home |  busy     53% |  read  181413  | write      0  |  KiB/w      0 |  MBr/s  70.86 |  MBw/s   0.00  | avio 0.03 ms  |
> LVM |     sata-swap |  busy      2% |  read       0  | write    940  |  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.37  | avio 0.17 ms  |
> LVM |   sata-debian |  busy      0% |  read       0  | write      1  |  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.00  | avio 1.00 ms  |
> LVM |  msata-debian |  busy      0% |  read       0  | write      1  |  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.00  | avio 0.00 ms  |
> DSK |           sda |  busy     53% |  read  181413  | write    477  |  KiB/w      7 |  MBr/s  70.86 |  MBw/s   0.37  | avio 0.03 ms  |
> DSK |           sdb |  busy      0% |  read       0  | write      1  |  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.00  | avio 0.00 ms  |
> NET |  transport    |  tcpi      16 |  tcpo      16  | udpi       0  |  udpo       0 |  tcpao      1 |  tcppo      1  | tcprs      0  |
> NET |  network      |  ipi       16 |  ipo       16  | ipfrw      0  |  deliv     16 |               |  icmpi      0  | icmpo      0  |
> NET |  lo      ---- |  pcki      16 |  pcko      16  | si    2 Kbps  |  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
>
>    PID    TID   RUID      EUID        THR  SYSCPU   USRCPU   VGROW    RGROW   RDDSK    WRDSK  ST   EXC  S   CPUNR   CPU   CMD        1/3
>   9650      -   martin    martin       22   7.89s    0.65s      0K     128K  705.5M   382.1M  --     -  S       2   87%   VirtualBox
>   9911      -   root      root          1   0.69s    0.01s      0K       0K      0K       0K  --     -  S       3    7%   watch
>   9598      -   root      root          1   0.38s    0.00s      0K       0K      0K      20K  --     -  S       0    4%   kworker/u8:9
>   9892      -   root      root          1   0.36s    0.00s      0K       0K      0K       0K  --     -  S       1    4%   kworker/u8:17
>   9428      -   root      root          1   0.30s    0.00s      0K       0K      0K       0K  --     -  R       0    3%   kworker/u8:3
>   9589      -   root      root          1   0.23s    0.00s      0K       0K      0K       0K  --     -  S       1    2%   kworker/u8:6
>   4746      -   martin    martin        2   0.04s    0.13s      0K     -16K      0K       0K  --     -  R       2    2%   konsole
>
>
>
> Every 1,0s: cat /proc/meminfo                                                                                  Sat Dec 27 12:59:23 2014
>
> MemTotal:       16210512 kB
> MemFree:          786632 kB
> MemAvailable:   10271500 kB
> Buffers:              52 kB
> Cached:          9564340 kB
> SwapCached:        70268 kB
> Active:          6847560 kB
> Inactive:        5257956 kB
> Active(anon):    2016412 kB
> Inactive(anon):   703076 kB
> Active(file):    4831148 kB
> Inactive(file):  4554880 kB
> Unevictable:        9068 kB
> Mlocked:            9068 kB
> SwapTotal:      12582908 kB
> SwapFree:       12186680 kB
> Dirty:            972324 kB
> Writeback:             0 kB
> AnonPages:       2526340 kB
> Mapped:          2457096 kB
> Shmem:            173564 kB
> Slab:             918128 kB
> SReclaimable:     848816 kB
> SUnreclaim:        69312 kB
> KernelStack:       11200 kB
> PageTables:        64556 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:    20688164 kB
> Committed_AS:    7438348 kB
>
>
>
> I am not seeing more than one GiB of dirty here during regular usage and
> it is no problem.
>
> And kworker thread CPU usage just fine. So no, the dirty_background_ratio
> isn´t an issue with this 16 GiB ThinkPad T520. Please note: I do Linux
> performance analysis and tuning courses for about 7 years or so meanwhile.
>
> I *know* these knobs. I may have used wrong terms regarding BTRFS, and my
> understanding of BTRFS space allocation probably can be more accurate, but
> I do think that I am onto something here. This is no rotating disk, it can handle
> the write burst just fine and I generally do not tune where there is no need to
> tune. Here there isn´t. And it wouldn´t be much more than a fine tuning.
>
> With slow devices or with rsync over NFS by all means reduce it. But here it
> simply isn´t an issue as you can see with the low kworker thread CPU usage
> and the general SSD usage above.
>
>
> So defragmentation completed just nice, no issue so far.
>
> But I am close to full device space reservation already:
>
> merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
> Sa 27. Dez 13:02:40 CET 2014
> Label: 'home'  uuid: [some UUID]
>          Total devices 2 FS bytes used 151.58GiB
>          devid    1 size 160.00GiB used 158.01GiB path /dev/mapper/msata-home
>          devid    2 size 160.00GiB used 158.01GiB path /dev/mapper/sata-home
>
>
>
> I thought I can trigger it again by defragmenting in Windows XP again, but
> mind you, its defragmented already so it doesn´t to much. I did the sdelete
> dance just to trigger something and well I saw kworker a bit higher, but not
> much.
>
> But finally I got to:
>
>
>
>
> So I did, if Virtualbox can write randomly in a file, I can too.
>
> So I did:
>
>
> martin@merkaba:~> cat ssd-test.fio
> [global]
> bs=4k
> #ioengine=libaio
> #iodepth=4
> size=4g
> #direct=1
> runtime=120
> filename=ssd.test.file
>
> [seq-write]
> rw=write
> stonewall
>
> [rand-write]
> rw=randwrite
> stonewall
>
>
>
> And got:
>
> ATOP - merkaba                          2014/12/27  13:41:02                          -----------                           10s elapsed
> PRC |  sys   10.14s |  user   0.38s |  #proc    332  | #trun      2  |  #tslpi   548 |  #tslpu     0 |  #zombie    0  | no  procacct  |
> CPU |  sys     102% |  user      4% |  irq       0%  | idle    295%  |  wait      0% |  guest     0% |  curf 3.10GHz  | curscal  96%  |
> cpu |  sys      76% |  user      0% |  irq       0%  | idle     24%  |  cpu001 w  0% |  guest     0% |  curf 3.20GHz  | curscal  99%  |
> cpu |  sys      24% |  user      1% |  irq       0%  | idle     75%  |  cpu000 w  0% |  guest     0% |  curf 3.19GHz  | curscal  99%  |
> cpu |  sys       1% |  user      1% |  irq       0%  | idle     98%  |  cpu002 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> cpu |  sys       1% |  user      1% |  irq       0%  | idle     98%  |  cpu003 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> CPL |  avg1    0.82 |  avg5    0.78 |  avg15   0.99  |               |  csw     6233 |  intr   12023 |                | numcpu     4  |
> MEM |  tot    15.5G |  free    4.0G |  cache   9.7G  | buff    0.0M  |  slab  333.1M |  shmem 206.6M |  vmbal   0.0M  | hptot   0.0M  |
> SWP |  tot    12.0G |  free   11.7G |                |               |               |               |  vmcom   3.4G  | vmlim  19.7G  |
> LVM |     sata-home |  busy      0% |  read       8  | write      0  |  KiB/w      0 |  MBr/s   0.00 |  MBw/s   0.00  | avio 0.12 ms  |
> DSK |           sda |  busy      0% |  read       8  | write      0  |  KiB/w      0 |  MBr/s   0.00 |  MBw/s   0.00  | avio 0.12 ms  |
> NET |  transport    |  tcpi      16 |  tcpo      16  | udpi       0  |  udpo       0 |  tcpao      1 |  tcppo      1  | tcprs      0  |
> NET |  network      |  ipi       16 |  ipo       16  | ipfrw      0  |  deliv     16 |               |  icmpi      0  | icmpo      0  |
> NET |  lo      ---- |  pcki      16 |  pcko      16  | si    2 Kbps  |  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
>
>    PID    TID   RUID      EUID        THR  SYSCPU   USRCPU   VGROW    RGROW   RDDSK    WRDSK  ST   EXC  S   CPUNR   CPU   CMD        1/2
> 18079      -   martin    martin        2   9.99s    0.00s      0K       0K      0K      16K  --     -  R       1  100%   fio
>   4746      -   martin    martin        2   0.01s    0.14s      0K       0K      0K       0K  --     -  S       2    2%   konsole
>   3291      -   martin    martin        4   0.01s    0.11s      0K       0K      0K       0K  --     -  S       0    1%   plasma-desktop
>   1488      -   root      root          1   0.03s    0.04s      0K       0K      0K       0K  --     -  S       0    1%   Xorg
> 10036      -   root      root          1   0.04s    0.02s      0K       0K      0K       0K  --     -  R       2    1%   atop
>
> while fio was just *laying* out the 4 GiB file. Yes, thats 100% system CPU
> for 10 seconds while allocatiing a 4 GiB file on a filesystem like:
>
> martin@merkaba:~> LANG=C df -hT /home
> Filesystem             Type   Size  Used Avail Use% Mounted on
> /dev/mapper/msata-home btrfs  170G  156G   17G  91% /home
>
> where a 4 GiB file should easily fit, no? (And this output is with the 4
> GiB file. So it was even 4 GiB more free before.)

No. /usr/bin/df is an _approximation_ in BTRFS because of the limits of 
the fsstat() function call. The fstat function call was defined in 1990 
and "can't understand" the dynamic allocation model used in BTRFS as it 
assumes fixed geometry for filesystems. You do _not_ have 17G actually 
available. You need to rely on btrfs fi df and btrfs fi show to figure 
out how much space you _really_ have.

According to this block you have a RAID1 of ~ 160GB expanse (two 160G disks)

 > merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
 > Sa 27. Dez 13:26:39 CET 2014
 > Label: 'home'  uuid: [some UUID]
 >          Total devices 2 FS bytes used 152.83GiB
 >          devid    1 size 160.00GiB used 160.00GiB path 
/dev/mapper/msata-home
 >          devid    2 size 160.00GiB used 160.00GiB path 
/dev/mapper/sata-home

And according to this block you have about 4.49GiB of data space:

 > Btrfs v3.17
 > Data, RAID1: total=154.97GiB, used=149.58GiB
 > System, RAID1: total=32.00MiB, used=48.00KiB
 > Metadata, RAID1: total=5.00GiB, used=3.26GiB
 > GlobalReserve, single: total=512.00MiB, used=0.00B

154.97
   5.00
   0.032
+ 0.512

Pretty much as close to 160GiB as you are going to get (those numbers 
being rounded up in places for "human readability") BTRFS has allocate 
100% of the raw storage into typed extents.

A large datafile can only fit in the 154.97-149.58 = 5.39

Trying to allocate that 4GiB file into that 5.39GiB of space becomes an 
NP-complete (e.g. "very hard") problem if it is very fragmented.

I also don't know what kind of tool you are using, but it might be 
repeatedly trying and failing to fallocate the file as a single extent 
or something equally dumb.

If the tool that takes those .fio files "isn't smart" about transient 
allocation failures it might be trying the same allocation again, and 
again, and again, and again.... forever... which is not a problem with 
BTRFS but which _would_ lead to runaway CPU usage with no actual disk 
activity.

So try again with more normal tools and see if you can allocate 4GiB.

dd if=/dev/urandom of=file bs=1m count=4096

Does that create a four-gig file? Probably works fine.

You need to isolate not "overall cpu usage" but _what_ program is doing 
what an why. So strace your fio program or whatever it is to see what 
function call(s) it is making and what is being returned.

But seriously dude, if the DD works and the fio doesn't, then that's a 
problem with fio.

(I've got _zero_ idea what fio is, but if it does "testing" and 
repeatedly writes random bits of the file, since you've only got 5.39G 
of space it's likely going to have a lot of problems doing _anything_ 
"intensive" to a COW file of 4G.

So yea, that simultaneous write/rewrite test is going to fail. You don't 
have enough room to permute that file.

None of the results below "surprise me" given that you _don't_ have 
enough room to do the tests you (seem to have) initiated on a COW file. 
Minimum likely needed space is just under 8GiB. Maximum could be much, 
much larger.

>
>
> But it gets even more visible:
>
> martin@merkaba:~> fio ssd-test.fio
> seq-write: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
> rand-write: (g=1): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
> fio-2.1.11
> Starting 2 processes
> Jobs: 1 (f=1): [_(1),w(1)] [19.3% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 01m:57s]
> 0$ zsh  1$ zsh  2$ zsh  3-$ zsh  4$ zsh  5$* zsh
>
>
> yes, thats 0 IOPS.
>
> 0 IOPS and in zero IOPS. For minutes.
>
>
>
> And here is why:
>
> ATOP - merkaba                          2014/12/27  13:46:52                          -----------                           10s elapsed
> PRC |  sys   10.77s |  user   0.31s |  #proc    334  | #trun      2  |  #tslpi   548 |  #tslpu     3 |  #zombie    0  | no  procacct  |
> CPU |  sys     108% |  user      3% |  irq       0%  | idle    286%  |  wait      2% |  guest     0% |  curf 3.08GHz  | curscal  96%  |
> cpu |  sys      72% |  user      1% |  irq       0%  | idle     28%  |  cpu000 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> cpu |  sys      19% |  user      0% |  irq       0%  | idle     81%  |  cpu001 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> cpu |  sys      11% |  user      1% |  irq       0%  | idle     87%  |  cpu003 w  1% |  guest     0% |  curf 3.19GHz  | curscal  99%  |
> cpu |  sys       6% |  user      1% |  irq       0%  | idle     91%  |  cpu002 w  1% |  guest     0% |  curf 3.11GHz  | curscal  97%  |
> CPL |  avg1    2.78 |  avg5    1.34 |  avg15   1.12  |               |  csw    50192 |  intr   32379 |                | numcpu     4  |
> MEM |  tot    15.5G |  free    5.0G |  cache   8.7G  | buff    0.0M  |  slab  332.6M |  shmem 207.2M |  vmbal   0.0M  | hptot   0.0M  |
> SWP |  tot    12.0G |  free   11.7G |                |               |               |               |  vmcom   3.4G  | vmlim  19.7G  |
> LVM |     sata-home |  busy      5% |  read     160  | write  11177  |  KiB/w      3 |  MBr/s   0.06 |  MBw/s   4.36  | avio 0.05 ms  |
> LVM |    msata-home |  busy      4% |  read      28  | write  11177  |  KiB/w      3 |  MBr/s   0.01 |  MBw/s   4.36  | avio 0.04 ms  |
> LVM |   sata-debian |  busy      0% |  read       0  | write    844  |  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.33  | avio 0.02 ms  |
> LVM |  msata-debian |  busy      0% |  read       0  | write    844  |  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.33  | avio 0.02 ms  |
> DSK |           sda |  busy      5% |  read     160  | write  10200  |  KiB/w      4 |  MBr/s   0.06 |  MBw/s   4.69  | avio 0.05 ms  |
> DSK |           sdb |  busy      4% |  read      28  | write  10558  |  KiB/w      4 |  MBr/s   0.01 |  MBw/s   4.69  | avio 0.04 ms  |
> NET |  transport    |  tcpi      35 |  tcpo      33  | udpi       3  |  udpo       3 |  tcpao      2 |  tcppo      1  | tcprs      0  |
> NET |  network      |  ipi       38 |  ipo       36  | ipfrw      0  |  deliv     38 |               |  icmpi      0  | icmpo      0  |
> NET |  eth0      0% |  pcki      22 |  pcko      20  | si    9 Kbps  |  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
> NET |  lo      ---- |  pcki      16 |  pcko      16  | si    2 Kbps  |  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
>
>    PID    TID   RUID      EUID        THR  SYSCPU   USRCPU   VGROW    RGROW   RDDSK    WRDSK  ST   EXC  S   CPUNR   CPU   CMD        1/3
> 14973      -   root      root          1   8.92s    0.00s      0K       0K      0K     144K  --     -  S       0   89%   kworker/u8:14
> 17450      -   root      root          1   0.86s    0.00s      0K       0K      0K      32K  --     -  R       3    9%   kworker/u8:5
>    788      -   root      root          1   0.25s    0.00s      0K       0K    128K   18880K  --     -  S       3    3%   btrfs-transact
> 12254      -   root      root          1   0.14s    0.00s      0K       0K     64K     576K  --     -  S       2    1%   kworker/u8:3
> 17332      -   root      root          1   0.11s    0.00s      0K       0K    112K    1348K  --     -  S       2    1%   kworker/u8:4
>   3291      -   martin    martin        4   0.01s    0.09s      0K       0K      0K       0K  --     -  S       1    1%   plasma-deskto
>
>
>
>
> ATOP - merkaba                          2014/12/27  13:47:12                          -----------                           10s elapsed
> PRC |  sys   10.78s |  user   0.44s |  #proc    334  | #trun      3  |  #tslpi   547 |  #tslpu     3 |  #zombie    0  | no  procacct  |
> CPU |  sys     106% |  user      4% |  irq       0%  | idle    288%  |  wait      1% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> cpu |  sys      93% |  user      0% |  irq       0%  | idle      7%  |  cpu002 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> cpu |  sys       7% |  user      0% |  irq       0%  | idle     93%  |  cpu003 w  0% |  guest     0% |  curf 3.01GHz  | curscal  94%  |
> cpu |  sys       3% |  user      2% |  irq       0%  | idle     94%  |  cpu000 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> cpu |  sys       3% |  user      2% |  irq       0%  | idle     95%  |  cpu001 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> CPL |  avg1    3.33 |  avg5    1.56 |  avg15   1.20  |               |  csw    38253 |  intr   23104 |                | numcpu     4  |
> MEM |  tot    15.5G |  free    4.9G |  cache   8.7G  | buff    0.0M  |  slab  336.5M |  shmem 207.2M |  vmbal   0.0M  | hptot   0.0M  |
> SWP |  tot    12.0G |  free   11.7G |                |               |               |               |  vmcom   3.4G  | vmlim  19.7G  |
> LVM |    msata-home |  busy      2% |  read       0  | write   2337  |  KiB/w      3 |  MBr/s   0.00 |  MBw/s   0.91  | avio 0.07 ms  |
> LVM |     sata-home |  busy      2% |  read      36  | write   2337  |  KiB/w      3 |  MBr/s   0.01 |  MBw/s   0.91  | avio 0.07 ms  |
> LVM |  msata-debian |  busy      1% |  read       1  | write   1630  |  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.65  | avio 0.03 ms  |
> LVM |   sata-debian |  busy      0% |  read       0  | write   1019  |  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.41  | avio 0.02 ms  |
> DSK |           sdb |  busy      2% |  read       1  | write   2545  |  KiB/w      5 |  MBr/s   0.00 |  MBw/s   1.45  | avio 0.07 ms  |
> DSK |           sda |  busy      1% |  read      36  | write   2461  |  KiB/w      5 |  MBr/s   0.01 |  MBw/s   1.28  | avio 0.06 ms  |
> NET |  transport    |  tcpi      20 |  tcpo      20  | udpi       1  |  udpo       1 |  tcpao      1 |  tcppo      1  | tcprs      0  |
> NET |  network      |  ipi       21 |  ipo       21  | ipfrw      0  |  deliv     21 |               |  icmpi      0  | icmpo      0  |
> NET |  eth0      0% |  pcki       5 |  pcko       5  | si    0 Kbps  |  so    0 Kbps |  erri       0 |  erro       0  | drpo       0  |
> NET |  lo      ---- |  pcki      16 |  pcko      16  | si    2 Kbps  |  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
>
>    PID    TID   RUID      EUID        THR  SYSCPU   USRCPU   VGROW    RGROW   RDDSK    WRDSK  ST   EXC  S   CPUNR   CPU   CMD        1/3
> 17450      -   root      root          1   9.96s    0.00s      0K       0K      0K       0K  --     -  R       2  100%   kworker/u8:5
>   4746      -   martin    martin        2   0.06s    0.15s      0K       0K      0K       0K  --     -  S       1    2%   konsole
> 10508      -   root      root          1   0.13s    0.00s      0K       0K     96K    4048K  --     -  S       1    1%   kworker/u8:18
>   1488      -   root      root          1   0.06s    0.06s      0K       0K      0K       0K  --     -  S       0    1%   Xorg
> 17332      -   root      root          1   0.12s    0.00s      0K       0K     96K     580K  --     -  R       3    1%   kworker/u8:4
> 17454      -   root      root          1   0.11s    0.00s      0K       0K     32K    4416K  --     -  D       1    1%   kworker/u8:6
> 17516      -   root      root          1   0.09s    0.00s      0K       0K     16K     136K  --     -  S       3    1%   kworker/u8:7
>   3268      -   martin    martin        3   0.02s    0.05s      0K       0K      0K       0K  --     -  S       1    1%   kwin
> 10036      -   root      root          1   0.05s    0.02s      0K       0K      0K       0K  --     -  R       0    1%   atop
>
>
>
> So BTRFS is basically busy with itself and nothing else. Look at the SSD
> usage. They are *idling* around. Heck 2400 write accesses in 10 seconds.
> Thats a joke with SSDs that can do 40000 IOPS (depending on how and what
> you measure of course, like request size, read, write, iodepth and so).
>
> Its kworker/u8:5 utilizing 100% of one core for minutes.
>
>
>
> Its the random write case it seems. Here are values from fio job:
>
> martin@merkaba:~> fio ssd-test.fio
> seq-write: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
> rand-write: (g=1): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
> fio-2.1.11
> Starting 2 processes
> Jobs: 1 (f=1): [_(1),w(1)] [3.6% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 01h:06m:26s]
> seq-write: (groupid=0, jobs=1): err= 0: pid=19212: Sat Dec 27 13:48:33 2014
>    write: io=4096.0MB, bw=343683KB/s, iops=85920, runt= 12204msec
>      clat (usec): min=3, max=38048, avg=10.52, stdev=205.25
>       lat (usec): min=3, max=38048, avg=10.66, stdev=205.43
>      clat percentiles (usec):
>       |  1.00th=[    4],  5.00th=[    4], 10.00th=[    4], 20.00th=[    4],
>       | 30.00th=[    4], 40.00th=[    5], 50.00th=[    5], 60.00th=[    5],
>       | 70.00th=[    7], 80.00th=[    8], 90.00th=[    8], 95.00th=[    9],
>       | 99.00th=[   14], 99.50th=[   20], 99.90th=[  211], 99.95th=[ 2128],
>       | 99.99th=[10304]
>      bw (KB  /s): min=164328, max=812984, per=100.00%, avg=345585.75, stdev=201695.20
>      lat (usec) : 4=0.18%, 10=95.31%, 20=4.00%, 50=0.18%, 100=0.12%
>      lat (usec) : 250=0.12%, 500=0.02%, 750=0.01%, 1000=0.01%
>      lat (msec) : 2=0.01%, 4=0.01%, 10=0.03%, 20=0.01%, 50=0.01%
>    cpu          : usr=13.55%, sys=46.89%, ctx=7810, majf=0, minf=6
>    IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       issued    : total=r=0/w=1048576/d=0, short=r=0/w=0/d=0
>       latency   : target=0, window=0, percentile=100.00%, depth=1
>
> Seems fine.
>
>
> But:
>
> rand-write: (groupid=1, jobs=1): err= 0: pid=19243: Sat Dec 27 13:48:33 2014
>    write: io=140336KB, bw=1018.4KB/s, iops=254, runt=137803msec
>      clat (usec): min=4, max=21299K, avg=3708.02, stdev=266885.61
>       lat (usec): min=4, max=21299K, avg=3708.14, stdev=266885.61
>      clat percentiles (usec):
>       |  1.00th=[    4],  5.00th=[    5], 10.00th=[    5], 20.00th=[    5],
>       | 30.00th=[    6], 40.00th=[    6], 50.00th=[    6], 60.00th=[    6],
>       | 70.00th=[    7], 80.00th=[    7], 90.00th=[    9], 95.00th=[   10],
>       | 99.00th=[   18], 99.50th=[   19], 99.90th=[   28], 99.95th=[  116],
>       | 99.99th=[16711680]
>      bw (KB  /s): min=    0, max= 3426, per=100.00%, avg=1030.10, stdev=938.02
>      lat (usec) : 10=92.63%, 20=6.89%, 50=0.43%, 100=0.01%, 250=0.02%
>      lat (msec) : 250=0.01%, 500=0.01%, >=2000=0.02%
>    cpu          : usr=0.06%, sys=1.59%, ctx=28720, majf=0, minf=7
>    IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       issued    : total=r=0/w=35084/d=0, short=r=0/w=0/d=0
>       latency   : target=0, window=0, percentile=100.00%, depth=1
>
> Run status group 0 (all jobs):
>    WRITE: io=4096.0MB, aggrb=343682KB/s, minb=343682KB/s, maxb=343682KB/s, mint=12204msec, maxt=12204msec
>
> Run status group 1 (all jobs):
>    WRITE: io=140336KB, aggrb=1018KB/s, minb=1018KB/s, maxb=1018KB/s, mint=137803msec, maxt=137803msec
>
>
> What? 254 IOPS? With a Dual SSD BTRFS RAID 1?
>
> What?
>
> Ey, *what*?
>
>
>
> Repeating with the random write case.
>
> Its a different kworker now, but similar result:
>
> ATOP - merkaba                          2014/12/27  13:51:48                          -----------                           10s elapsed
> PRC |  sys   10.66s |  user   0.25s |  #proc    330  | #trun      2  |  #tslpi   545 |  #tslpu     2 |  #zombie    0  | no  procacct  |
> CPU |  sys     105% |  user      3% |  irq       0%  | idle    292%  |  wait      0% |  guest     0% |  curf 3.07GHz  | curscal  95%  |
> cpu |  sys      92% |  user      0% |  irq       0%  | idle      8%  |  cpu002 w  0% |  guest     0% |  curf 3.19GHz  | curscal  99%  |
> cpu |  sys       8% |  user      0% |  irq       0%  | idle     92%  |  cpu003 w  0% |  guest     0% |  curf 3.09GHz  | curscal  96%  |
> cpu |  sys       3% |  user      2% |  irq       0%  | idle     95%  |  cpu000 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> cpu |  sys       2% |  user      1% |  irq       0%  | idle     97%  |  cpu001 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> CPL |  avg1    1.00 |  avg5    1.32 |  avg15   1.23  |               |  csw    34484 |  intr   23182 |                | numcpu     4  |
> MEM |  tot    15.5G |  free    5.4G |  cache   8.3G  | buff    0.0M  |  slab  334.8M |  shmem 207.2M |  vmbal   0.0M  | hptot   0.0M  |
> SWP |  tot    12.0G |  free   11.7G |                |               |               |               |  vmcom   3.4G  | vmlim  19.7G  |
> LVM |     sata-home |  busy      1% |  read      36  | write   2502  |  KiB/w      4 |  MBr/s   0.01 |  MBw/s   0.98  | avio 0.06 ms  |
> LVM |    msata-home |  busy      1% |  read      48  | write   2502  |  KiB/w      4 |  MBr/s   0.02 |  MBw/s   0.98  | avio 0.04 ms  |
> LVM |  msata-debian |  busy      0% |  read       0  | write      6  |  KiB/w      7 |  MBr/s   0.00 |  MBw/s   0.00  | avio 1.33 ms  |
> LVM |   sata-debian |  busy      0% |  read       0  | write      6  |  KiB/w      7 |  MBr/s   0.00 |  MBw/s   0.00  | avio 0.17 ms  |
> DSK |           sda |  busy      1% |  read      36  | write   2494  |  KiB/w      4 |  MBr/s   0.01 |  MBw/s   0.98  | avio 0.06 ms  |
> DSK |           sdb |  busy      1% |  read      48  | write   2494  |  KiB/w      4 |  MBr/s   0.02 |  MBw/s   0.98  | avio 0.04 ms  |
> NET |  transport    |  tcpi      32 |  tcpo      30  | udpi       2  |  udpo       2 |  tcpao      2 |  tcppo      1  | tcprs      0  |
> NET |  network      |  ipi       35 |  ipo       32  | ipfrw      0  |  deliv     35 |               |  icmpi      0  | icmpo      0  |
> NET |  eth0      0% |  pcki      19 |  pcko      16  | si    9 Kbps  |  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
> NET |  lo      ---- |  pcki      16 |  pcko      16  | si    2 Kbps  |  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
>
>    PID    TID   RUID      EUID        THR  SYSCPU   USRCPU   VGROW    RGROW   RDDSK    WRDSK  ST   EXC  S   CPUNR   CPU   CMD        1/2
> 11746      -   root      root          1  10.00s    0.00s      0K       0K      0K       0K  --     -  R       2  100%   kworker/u8:0
> 12254      -   root      root          1   0.16s    0.00s      0K       0K    112K    1712K  --     -  S       3    2%   kworker/u8:3
> 17517      -   root      root          1   0.16s    0.00s      0K       0K    144K    1764K  --     -  S       1    2%   kworker/u8:8
>
>
>
> And now the graphical environemnt is locked. Continuining on TTY1.
>
> Doing another fio job with tee so I can get output easily.
>
> Wow! I wonder whether this is reproducable with a fresh BTRFS with fio stressing it.
>
> Like a 10 GiB BTRFS with 5 GiB fio test file and just letting it run.
>
>
> Okay, I let the final fio job complete and include the output here.
>
>
> Okay, and there we are and I do have sysrq-t figures.
>
> Okay, this is 1,2 MiB xz packed. So I better start a bug report about this
> and attach it there. Is dislike cloud URLs that may disappear at some time.
>
>
>
> Now please finally acknowledge that there is an issue. Maybe I was not
> using the correct terms at the beginning, but there is a real issue. I do
> performance things for half a decade at least, I know that there is an issue
> when I see it.
>
>
>
>
> There we go:
>
> Bug 90401 - btrfs kworker thread uses up 100% of a Sandybridge core for minutes on random write into big file
> https://bugzilla.kernel.org/show_bug.cgi?id=90401
>
> Thanks,
>

