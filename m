From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-raid questions I couldn't find an answer to on the wiki
Date: Sat, 11 Feb 2012 05:48:22 +0000 (UTC)
Message-ID: <pan.2012.02.11.05.48.22@cox.net>
References: <pan.2012.01.26.15.41.32@cox.net>
	<201201291223.40161.kreijack@inwind.it>
	<COL113-W485767962008EF29E7E27EB08D0@phx.gbl>
	<pan.2012.01.31.05.55.47@cox.net> <4F3573E7.9080306@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Phillip Susi posted on Fri, 10 Feb 2012 14:45:43 -0500 as excerpted:

> On 1/31/2012 12:55 AM, Duncan wrote:
>> Thanks!  I'm on grub2 as well.  It's is still masked on gentoo, but I
>> recently unmasked and upgraded to it, taking advantage of the fact that
>> I have two two-spindle md/raid-1s for /boot and its backup to test and
>> upgrade one of them first, then the other only when I was satisfied
>> with the results on the first set.  I'll be using a similar strategy
>> for the btrfs upgrades, only most of my md/raid-1s are 4-spindle, with
>> two sets, working and backup, and I'll upgrade one set first.
> 
> Why do you want to have a separate /boot partition?  Unless you can't
> boot without it, having one just makes things more complex/problematic. 
> If you do have one, I agree that it is best to keep it ext4 not btrfs.

For a proper picture of the situation, understand that I don't have an 
initr*, I build everything I need into the kernel and have module loading 
disabled, and I keep /boot unmounted except when I'm actually installing 
an upgrade or reconfiguring.

Having a separate /boot means that I can keep it unmounted and thus free 
from possible random corruption or accidental partial /boot tree 
overwrite or deletion, most of the time.  It also means that I can emerge 
(build from sources using the gentoo ebuild script provided for the 
purpose, and install to the live system) a new grub without fear of 
corrupting what I actually boot from -- the grub system installation and 
boot installation remain separate.

A separate /boot is also more robust in terms of file system corruption 
-- if something goes wrong with my rootfs, I can simply boot its backup, 
from a separate /boot that will not have been corrupted.  Similarly, if 
something goes wrong with /boot (or the bios partition), I can switch 
drives in the BIOS and boot from the backup /boot, then load my usual 
rootfs.

Since I'm working with four drives, and both the working /boot and 
backup /boot are two-spindle md/raid1, one on one pair, one on the other, 
I have both hardware redundancy via the second spindle of the raid1, and 
admin-fatfinger redundancy via the backup.  However, the rootfs and its 
backup are both on quad-spindle md/raid1s, thus giving me four separate 
physical copies each of rootfs and its backup.  Because the disk points 
at a single bootloader, if /boot is on rootfs, all four would point to 
either the working rootfs or the backup rootfs, and would update 
together, so I'd lose the ability to fall back to the backup /boot.

(Note that I developed the backup /boot policy and solution back on 
legacy-grub.  Grub2 is rather more flexible, particularly with a 
reasonably roomy GPT BIOS partition, and since each BIOS partition is 
installed individually, in theory, if a grub2 update failed, I could 
point the BIOS at a disk I hadn't installed the BIOS partition update to 
yet, boot to the limited grub rescue-mode-shell, and point it at the 
/boot in the backup rootfs to load the normal-mode-shell, menu, and 
additional grub2 modules as necessary.  However, being able to access a 
full normal-mode-shell grub2 on the backup /boot instead of having to 
resort to the grub2 rescue-mode-shell to reach the backup rootfs, does 
have its benefits.)

One of the nice things about grub2 normal-mode is that it allows 
(directory and plain text file) browsing of pretty much anything it has a 
module for, anywhere on the system.  That's a nice thing to be able to 
do, but it too is much more robust if /boot isn't part of rootfs, and 
thus, isn't likely to be damaged if the rootfs is.  The ability to boot 
to grub2 and retrieve vital information (even if limited to plain-text 
file storage) from a system without a working rootfs is a very nice 
ability to have! 

So you see, a separate /boot really does have its uses. =:^)

>> Meanwhile, you're right about subvolumes.  I'd not try them on a btrfs
>> /boot, either.  (I don't really see the use case for it, for a separate
>> /boot, tho there's certainly a case for a /boot subvolume on a btrfs
>> root, for people doing that.)
> 
> The Ubuntu installer creates two subvolumes by default when you install
> on btrfs: one named @, mounted on /, and one named @home, mounted on
> /home.  Grub2 handles this well since the subvols have names in the
> default root, so grub just refers to /@/boot instead of /boot, and so
> on.  The apt-btrfs-snapshot package makes apt automatically snapshot the
> root subvol so you can revert after an upgrade.  This seamlessly causes
> grub to go back to the old boot menu without the new kernels too, since
> it goes back to reading the old grub.cfg in the reverted root subvol.

Thanks for that "real world" example.  Subvolumes and particularly 
snapshots can indeed be quite useful, but I'd be rather leery of having 
all that on the same master filesystem.  Lose it and you've lost 
everything, snapshots or no snapshots, if there's not bootable backups 
somewhere.

Two experiences inform my partitioning and layout judgment here.  The 
first one was back before the turn of the century when I still did MS.  
In fact, at the time I was running an MSIE public beta for either MSIE 4 
or 5, both of which I ran but IDR which it was that this happened with.  
MS made a change to the MSIE cache indexing, keeping the index file disk 
location in memory and direct-writing to it for performance reasons, 
rather than going the usual filesystem access route.  The only problem 
was, whoever made that change didn't think about MSIE and MS (filesystem) 
Explorer being effectively merged, and that it ran all the time as it was 
the shell.

So then it comes time for the regularly scheduled system defrag, and 
defrag moves the index files out from under MSIE.  Then MSIE updates the 
index, writing to the old location, in the process overwriting whatever's 
there, causing all sorts of crosslinked files and other destruction.

A number of folks running that beta had un-backed-up data destroyed by 
that bug (which MS fixed in the release by simply marking the MSIE index 
files with the system attribute, so defrag wouldn't move them), but all 
it did to me was screw up a few files on my separate TMP partition, 
because I HAD a separate TMP partition, and because that's where I had 
put the IE cache, reasoning that it was temporary data and thus belonged 
on the TMP partition.  That decision saved my bacon!

Both before and after that, I had a number of similar but rather more 
minor incidents where a strict partitioning policy saved me trouble, as 
well.  But that one was all it took to keep me using a strict separate 
partitioning system to this day.

The second experience was when the AC failed here, in the hot Phoenix 
summer (routinely 45-48C highs).  I had left the system on and gone 
somewhere.  When the AC failed, the outside-in-the-shade-temperature was 
45C+, inside room temperature was EASILY 60C+, and the drive temperature 
was very likely 90C+!

The drive of course failed due to physical head-crash on the still-
spinning platters (I could see the grooves when I took it apart, later).

When I came home of course the system was frozen, and I turned it off.  
The CPUs survived, and surprisingly, so did much of the disk.  It was 
only where the physical head crash grooves were that the data was gone.

I didn't have off-disk backups at that time (for sure I do now!), but I 
had duplicate backup partitions for anything valuable.  Since they 
weren't mounted, I was able to recover and even continue using the backup 
rootfs, /usr, etc, for a couple months, until I could buy a new disk and 
transfer everything over.

Again, what saved me was the fact that I had everything partitioned off.  
The partitions that weren't actually mounted were pretty much undamaged, 
save for a few single scratches due to head seeking from one mounted 
partition to another, before the system itself crashed, and unlike the 
grooves worn in the mounted partitions, the disk's own error correction 
caught most of that.  An fsck fixed things up pretty good, tho I lost a 
few files.

I hate to think about what would have happened if instead of separate 
partitions, each with its own intact metadata, etc, those "unmounted" 
partitions had been simply subvolumes on a single master filesystem!  
True, btrfs has double metadata and both data and metadata checksumming, 
and I'm *DEFINITELY* looking forward to the additional protection from 
that (tho only two-way even on a 4-spindle so-called raid1 btrfs was a 
big disappointment, tho an article I read somewhere says multi-redundancy 
is scheduled for kernel 3.4 or 3.5), but the plan at least here is for 
that to be ADDITIONAL protection, NOT AN EXCUSE TO BE SLOPPY!  It's for 
that reason that I intend to keep proper partitions and probably won't 
make a lot of use of the subvolume functionality, except as it's used by 
the snapshot functionality, which I expect I WILL use, for exactly the 
type of rollback functionality you describe above.

> I have a radically different suggestion you might consider rebuilding
> your system using.  Partition each disk into only two partitions: one
> for bios_grub, and one for everything else ( or just use MBR and skip
> the bios_grub partition ).  Give the second partitions to mdadm to make
> a raid10 array out of.  If you use a 2x far and 2x offset instead of the
> default near layout, you will have an array that can still handle any 2
> of the 4 drives failing, will have twice the capacity of a 4 way mirror,
> almost the same sequential read throughput of a 4 way raid0, and about
> twice the write throughput of a 4 way mirror. Partition that array up
> and put your filesystems on it.

I like the raid-10 idea and will have to research it some more as I 
understand the idea behind "near" and "far" on raid10, but having never 
used raid-10, I don't "grok" that idea, understand it well enough to have 
appreciated the possibility for lose-an-two, before you suggested it.

And I'm only running 300 gig disks and given that I'm running a working 
and a backup copy of most of those raids/partitions, it's more like 180 
or 200 gig of actual storage, with the free-space fragmented due to the 
multiple partitions/raids, so I /am/ running a bit low on free-space and 
could definitely use the doubled space at this point!


But I believe I'll keep multiple raids for much the same reason I keep 
multiple partitions, it's a FAR more robust solution than having all 
one's eggs in one RAID basket.

Besides, I actually did try a single partitioned RAID (well, two, one for 
all the working copies, one for the backups) when I first setup md/raid, 
and came to the conclusion that the recovery time on that big a raid is 
rather longer than I like to be dealing with it.  Multiple raids, with 
the ones I'm not using ATM offline, means I don't have to worry about 
recovering the entire thing, only the raids that were online and actually 
dirty at the time of crash or whatever.  And of course write-intent 
bitmaps means even shorter recovery time in most cases, so between 
multiple raids and write-intent-bitmaps, a recovery that would take 2-3 
hours with my original all-in-one raid setup, now often takes < 5 
minutes! =:^)  Even with write-intent-bitmaps, I'd hate to go back to big 
all-in-one raids, for recovery reasons alone, and between that and the 
additional robustness of multiple raids, I just don't see myself doing 
that any time soon.


But the 2x far, 2x offset raid10 idea, to let me lose any two of the 
four, is something I will very possibly use, especially now that I've 
seen that btrfs isn't as close to ready with multi-redundancy as I had 
hoped, so it'll probably be mid-year at the earliest before I can 
reasonably play with that.  Thanks again, as that's a very practical 
suggestion indeed! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

