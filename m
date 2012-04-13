From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btr fs unmountable after disk failure
Date: Fri, 13 Apr 2012 20:32:06 +0000 (UTC)
Message-ID: <pan.2012.04.13.20.32.06@cox.net>
References: <alpine.LNX.2.01.1204131252070.26191@frira.zrqbmnf.qr>
	<20120413105822.GF4856@carfax.org.uk>
	<alpine.LNX.2.01.1204131536110.24064@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Jan Engelhardt posted on Fri, 13 Apr 2012 15:42:14 +0200 as excerpted:

> On Friday 2012-04-13 12:58, Hugo Mills wrote:
>>On Fri, Apr 13, 2012 at 12:55:43PM +0200, Jan Engelhardt wrote:
>>> 
>>> I originally created a RAID1(0) compound out of 4 drives. One of them
>>> [sdf] failed recently and was removed. The filesystem is no longer
>>> mountable with the 3 drives left.

>>   I think you need "-o degraded" in this case.
> 
> Yes indeed, -o degraded makes it go. Where is such documented? I know I
> can't expect mount(8) to yet have it, but there is not a mount.btrfs(8)
> either.

To the extent that it /is/ documented, probably the wiki.

http://btrfs.ipv5.de/index.php?title=Main_Page

(Note that there's an old/stale wiki at btrfs.wiki.kernel.org as well, 
but it's read-only since the kernel.org breakin and thus is quite stale 
by now.)

Looking at the mount options listed there, "degraded" is the first on the 
list. =:^)

http://btrfs.ipv5.de/index.php?title=Mount_options


> # btrfs fi show
> Label: 'srv'  uuid: 88300cd5-dbcb-4147-9ee4-c65a1c895e1d
>         Total devices 5 FS bytes used 1.23TB
>	  devid    2 size 1.36TB used 692.88GB path /dev/sdd
>         devid    5 size 1.36TB used 51.00GB path /dev/sdf
>         devid    3 size 1.36TB used 692.88GB path /dev/sde
>         devid    1 size 1.36TB used 692.90GB path /dev/sdc
>         *** Some devices missing
> 
> devices are missing, but how would I remove the old devid 4 (the "some"
> that's "missing")? `btrfs fi del` does not take ids, unfortunately.

You probably know my answer: wiki! =:^)

See the using btrfs with multiple devices page:

http://btrfs.ipv5.de/index.php?title=Using_Btrfs_with_Multiple_Devices

Look under replacing failed devices.

In particular, btrfs device del missing /mnt/pnt  (device not filesystem, 
missing tells btrfs to remove the first missing device).

If you're asking this sort of questions it should be obvious that there's 
a lot more info you'll likely find useful on the wiki as well, so I'd 
encourage you to spend some time browsing around.  Your btrfs filesystems 
and consequently, your stress levels managing them, should thank you for 
it. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

