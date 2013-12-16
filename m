Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:36414 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3LPKzl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 05:55:41 -0500
Received: by mail-ve0-f175.google.com with SMTP id jx11so3114266veb.6
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 02:55:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$39434$1fcf3006$dfc308a2$84507249@cox.net>
References: <CAD_cGvFdrhwC2erqYTMjPRG7Y=69tsT2O+S-GHYK7+wpBwFSFQ@mail.gmail.com>
	<46A0D70E-99DF-46FE-A4E8-71E9AC45129F@colorremedies.com>
	<CAD_cGvHkpkuveYFKm4kjgc0SkJ=mQ4mpChes0F25fdjc5r3PmQ@mail.gmail.com>
	<337E6C9D-298E-4F77-91D7-648A7C65D360@colorremedies.com>
	<CAD_cGvGLHgHagW-G5Qz1yXY4w14BBiZsJj3K0-FmjEGzoo-_rw@mail.gmail.com>
	<840381F8-BDCA-43BF-A170-6E10C2908B8A@colorremedies.com>
	<CAD_cGvF8-pxXXvwpB+yNYnKRW09S4c0VuKUGiWa7=8C2uFkvqA@mail.gmail.com>
	<pan$e9ec8$f8abd102$9f0d15ad$59d83b5d@cox.net>
	<CAD_cGvHU0yaXj-CzVgNYbeqzu7ZH0mUOiwjT-GmU7F5JTqx=jw@mail.gmail.com>
	<pan$9369c$4a56c817$cc0b6bdf$1b4a6541@cox.net>
	<CAD_cGvHQkO23gXtXmCF48Fh+Cxb6Z3b0yiD6pzPyQunGhgD5MA@mail.gmail.com>
	<pan$39434$1fcf3006$dfc308a2$84507249@cox.net>
Date: Mon, 16 Dec 2013 11:55:40 +0100
Message-ID: <CAD_cGvHAnS4r6MNxd32x6NMAgBRHxR53vVdjnc3EhZdxzipD_A@mail.gmail.com>
Subject: Re: Blocket for more than 120 seconds
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stupid me, I completely forgot that you can run multidisk arrays with
just block level partitions, just like with md raid! It will introduce
a rather significant management overhead in my case though, as
managing several individual partitions per drive is quite annoying
with so many drives.

What happens If I do cp --reflink=auto from a NOCOW file in a NOCOW
folder to a folder with COW set on the same btrfs volume? Do I still
get "free" copying, and is the resulting file COW or NOCOW?


Mvh

Hans-Kristian Bakke


On 16 December 2013 11:19, Duncan <1i5t5.duncan@cox.net> wrote:
> Hans-Kristian Bakke posted on Mon, 16 Dec 2013 01:06:36 +0100 as
> excerpted:
>
>> torrents are really only one thing my storage server get hammered with.
>> It also does a lot more IO intensive stuff. I actually run enterprise
>> storage drives in a Supermicro-server for a reason, even if it is my
>> home setup, consumer stuff just don't cut it with my storage abuse :)
>> It runs KVM virtualisation (not on btrfs though) with several VMs,
>> including windows machines, do lots of manipulation of large files,
>> offsite backups at 100 mbit/s for days on end, reencoding large amounts
>> of audio files, runs lots of web sites, constantly streams blu-rays to
>> at least one computer, and chews through enormous amounts of internet
>> bandwith constantly. Last week it consumed ~10TB of internet bandwith
>> alone. I was at about 140 mbit/s average throughput on a  100/100 link
>> over a full 7 day week, peaking at 177 mbit/s average over 24 hours, and
>> that is not counting the local gigabit traffic for all the video
>> remuxing and stuff.
>> In other words, all 19 storage drives in that server is driven really
>> hard, and it is no wonder that this triggers some subtleties that normal
>> users just don't hit.
>
> Wow!  Indeed!
>
>> But since torrenting are clearly the worst offender when it comes to
>> fragmentation I can comment on that.
>> Using btrfs with partitioning stops me from using the btrfs multidisk
>> handling that I ideally need, so that is really not an option.
>
> ??  I'm not running near what you're running, but I *AM* running multiple
> independent multi-device btrfs filesystems (raid1 mode) on a single pair
> of partitioned 256 MB (238 MiB) SSDs, just as pre-btrfs and pre-SSD, I
> ran multiple 4-way md/raid1 volumes on individual partitions on
> 4-physical-spindle spinning rust.
>
> Like md/raid, btrfs' multi-device support takes generic block devices.
> It doesn't care whether they're physical devices, partitions on physical
> devices, LVM2 volumes on physical devices, md/raid volumes on physical
> devices, partitions on md-raid on lvm2 on physical devices... you get the
> idea.  As long as you can mkfs.btrfs it, you can run multiple-device
> btrfs on it.
>
> In fact, I have that pair of SSDs GPT partitioned up, with 11 independent
> btrfs, 9 of which are btrfs raid1 mode across similar partitions (one
> /var/log, plus working and primary backup for each of root, /home, gentoo
> distro packages tree with sources and binpkgs as well, and a 32-bit chroot
> that's an install image for my netbook) on each device, with the other
> two being /boot and its backup on the other device, my only two non-raid1-
> mode btrfs.
>
> So yes, you can definitely run btrs multi-device on partition block-
> devices instead of directly on the physical device block devices, as I
> know quite well since my setup depends on that! =:^)
>
>> I also
>> think that if I were to use partitions (no multidisk), no COW and hence
>> no checksumming, I might as well use ext4 which is more optimized for
>> that usage scenario. Ideally I could use just a subvol with nodatacow
>> and quota for this purpose, but per subvolume nodatacow is not available
>> yet as far as I have understood (correct me if I'm wrong).
>
> Well, if your base assumption, that you couldn't use btrfs multi-device
> on partitions, only on physical devices, was correct... But it's not.
>
> Which means you /can/ partition if you like, and then use whatever
> filesystem on those partitions you want, combining multi-device btrfs on
> some of them, with ext4 on md/raid if you want multi-device support for
> it, since unlike btrfs, ext4 doesn't support multi-device natively.
>
> You could even throw lvm2 in there, if you like, giving you additional
> sizing and deployment flexibility.  Before btrfs here, I actually used
> reiserfs on lvm2 on mdraid on physical devices, and it worked, but that
> was complex enough I wasn't confident of my ability to manage it in a
> disaster recovery scenario, and lvm2 requires userspace and thus an initr*
> to handle root on lvm2, while root on mdraid can be handled directly from
> the kernel commandline so no initr* required, so I kept the mdraid and
> dropped lvm2.
>
> [snipped further discussion along that invalid assumption line]
>
>> I have, until btrfs, normally just made one large array of all storage
>> drives matching in performance characteristics, thinking that all the
>> data can benefit from the extra IO-performance of the array. This has
>> been a good compromise for a limited budget home setup where ideal
>> storage teering with SSD hybrid SANs and such is not an option. But as I
>> am now experiencing with btrfs, COW kind of changes the rules in a
>> profound noticable all-the-time way. With COWs inherent
>> random-write-to-large-file fragmentation penalty I think there is no
>> other way than to separate the different workloads into separate storage
>> pools going to different hardware. In my case it would probably mean
>> having one storage pool for general storage, one for VMs and one for
>> torrenting, as all of those react in their own way to COW and will get
>> heavily affected by the other workloads in the worst case if run from
>> the same drives with COW.
>
> Luckily, the partitioning thing does work.  Additionally, as mentioned
> you can set NOCOW on directories and have new files in them inherit
> that.  So you have quite a bit more flexibility than you might have
> though.  Tho of course it's your system and you may well prefer
> administering whole physical devices to dealing with permissions, just as
> I decided lvm2 wasn't appropriate to me, altho many people use it for
> everything.
>
>> Your system of a "cache" is actually already implemented logically in my
>> setup, in the form of a post-processing script that rtorrent runs on
>> completion. It moves completed files in dedicated per-tracker seeding
>> folders, and then makes a copy (using cp --reflink=auto on btrfs) of the
>> file, processes it if needed (tag clean up, reencoding, decompresssing
>> or what not), and then moves it to another "finished" folder. This makes
>> it easy to know what the new stuff is, and I can manipulate, rename and
>> clean up all the data without messing up the seeds.
>>
>> I think that the "finished" folder could still be located on the RAID10
>> btrfs volume with COW, as I can use an internal move into the organized
>> archive when I am actually sitting at the computer instead of a drive to
>> drive copy via the network.
>
> That makes sense.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
