Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f53.google.com ([209.85.212.53]:51854 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3LPAGh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Dec 2013 19:06:37 -0500
Received: by mail-vb0-f53.google.com with SMTP id o19so2723171vbm.12
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Dec 2013 16:06:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$9369c$4a56c817$cc0b6bdf$1b4a6541@cox.net>
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
Date: Mon, 16 Dec 2013 01:06:36 +0100
Message-ID: <CAD_cGvHQkO23gXtXmCF48Fh+Cxb6Z3b0yiD6pzPyQunGhgD5MA@mail.gmail.com>
Subject: Re: Blocket for more than 120 seconds
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

torrents are really only one thing my storage server get hammered
with. It also does a lot more IO intensive stuff. I actually run
enterprise storage drives in a Supermicro-server for a reason, even if
it is my home setup, consumer stuff just don't cut it with my storage
abuse :)
It runs KVM virtualisation (not on btrfs though) with several VMs,
including windows machines, do lots of manipulation of large files,
offsite backups at 100 mbit/s for days on end, reencoding large
amounts of audio files, runs lots of web sites, constantly streams
blu-rays to at least one computer, and chews through enormous amounts
of internet bandwith constantly. Last week it consumed ~10TB of
internet bandwith alone. I was at about 140 mbit/s average throughput
on a  100/100 link over a full 7 day week, peaking at 177 mbit/s
average over 24 hours, and that is not counting the local gigabit
traffic for all the video remuxing and stuff.
In other words, all 19 storage drives in that server is driven really
hard, and it is no wonder that this triggers some subtleties that
normal users just don't hit.

But since torrenting are clearly the worst offender when it comes to
fragmentation I can comment on that.
Using btrfs with partitioning stops me from using the btrfs multidisk
handling that I ideally need, so that is really not an option. I also
think that if I were to use partitions (no multidisk), no COW and
hence no checksumming, I might as well use ext4 which is more
optimized for that usage scenario. Ideally I could use just a subvol
with nodatacow and quota for this purpose, but per subvolume nodatacow
is not available yet as far as I have understood (correct me if I'm
wrong).

What I will do now, as a way of removing the worst offender from
messing up the general storage pool, is to shrink the btrfs array from
8x4TB drives in btrfs RAID10 to a 7 disk array, and dedicate a drive
for rtorrent, running ext4 with preallocation.
I have, until btrfs, normally just made one large array of all storage
drives matching in performance characteristics, thinking that all the
data can benefit from the extra IO-performance of the array. This has
been a good compromise for a limited budget home setup where ideal
storage teering with SSD hybrid SANs and such is not an option. But as
I am now experiencing with btrfs, COW kind of changes the rules in a
profound noticable all-the-time way. With COWs inherent
random-write-to-large-file fragmentation penalty I think there is no
other way than to separate the different workloads into separate
storage pools going to different hardware. In my case it would
probably mean having one storage pool for general storage, one for VMs
and one for torrenting, as all of those react in their own way to COW
and will get heavily affected by the other workloads in the worst case
if run from the same drives with COW.

Your system of a "cache" is actually already implemented logically in
my setup, in the form of a post-processing script that rtorrent runs
on completion. It moves completed files in dedicated per-tracker
seeding folders, and then makes a copy (using cp --reflink=auto on
btrfs) of the file, processes it if needed (tag clean up, reencoding,
decompresssing or what not), and then moves it to another "finished"
folder. This makes it easy to know what the new stuff is, and I can
manipulate, rename and clean up all the data without messing up the
seeds.

I think that the "finished" folder could still be located on the
RAID10 btrfs volume with COW, as I can use an internal move into the
organized archive when I am actually sitting at the computer instead
of a drive to drive copy via the network.

Regards,
H-K


On 16 December 2013 00:08, Duncan <1i5t5.duncan@cox.net> wrote:
> Hans-Kristian Bakke posted on Sun, 15 Dec 2013 15:51:37 +0100 as
> excerpted:
>
>> # Regarding torrents and preallocation I have actually turned
>> preallocation on specifically in rtorrent thinking that it did btrfs a
>> favour like with ext4 (system.file_allocate.set = yes). It is easy to
>> turn it off.
>> Is the "ideal" solution for btrfs and torrenting (or any other random
>> writes to large files) to use preallocation and NOCOW, or use no
>> preallocation and NOCOW? I am thinking the first, although I still do
>> not understand quite why preallocation is worse than no preallocation
>> for btrfs with COW enabled (or is both just as bad?)
>
> I'm not a dev only an admin who follows this list as I run btrfs too, and
> thus don't claim to be an expert on the above -- it's mostly echoing what
> I've seen here previously.
>
> That said, preallocation with nocow is the choice I'd make here.
>
> Meanwhile, a subpoint I didn't make explicit previously, tho it's a
> logical conclusion from the explanation, is that once the writing is
> finished and the file becomes like most media files effectively read-
> only, no further writes, NOCOW is no longer important.  That is, you can
> (sequentially) copy the file somewhere else and not have to worry about
> it.  In fact, that's a reasonably good idea, since NOCOW turns off btrfs
> checksumming too, and presumably you're still interested in maintaining
> file integrity on the thing.
>
> So what I'd do is setup a torrent download dir (or as I mentioned, a
> dedicated partition, since I like that sort of thing because it enforces
> size discipline on the stuff I've downloaded but not fully sorted thru...
> that's what I do with binary newsgroup downloading, which I've been doing
> on and off since well before bittorrent was around), set/mount it NOCOW/
> nowdatacow, and use it as a temporary download "cache".  Then after a
> file is fully downloaded to "cache", I'd copy it off to a final
> destination in my normal media partition, ultimately removing my NOCOW
> copy.
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
