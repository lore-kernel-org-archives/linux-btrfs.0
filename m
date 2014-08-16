Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50711 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaHPN61 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Aug 2014 09:58:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XIeUz-0005RC-HZ
	for linux-btrfs@vger.kernel.org; Sat, 16 Aug 2014 15:58:25 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Aug 2014 15:58:25 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Aug 2014 15:58:25 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Advisability of using nocow via chattr +C
Date: Sat, 16 Aug 2014 13:58:12 +0000 (UTC)
Message-ID: <pan$64ae9$d8bfd06e$5efb4313$34eb1fc9@cox.net>
References: <CAH-HCWWvOKMEdPx8fK9oqr38iQqPo63vDkQBmxKrTixxur0BvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Shriramana Sharma posted on Sat, 16 Aug 2014 15:36:48 +0530 as excerpted:

> Hello. I am new to BTRFS, and I don't have it actually running on my
> system as of yet, at least not for serious data. I am actually
> hesitating whether or not to take the plunge and entrust my data to this
> new FS.

FWIW, btrfs is new and not entirely stable yet, so keeping good, tested 
backups, updated at a frequency appropriate to your needs such that 
should you lose the filesystem you won't be overly upset as you can 
restore from backup, is even more important than it is with a fully 
mature and stable filesystem.

Additionally, staying current, typically latest stable series kernel (now 
3.16) is strongly recommended, altho at present there's a known bug 
they're working on that affects stability back thru 3.15, so the latest 
3.14-stable kernel is recommended temporarily, until the fix for that 
hits 3.17 devel and 3.16 stable (hopefully for 3.16.2).

Keeping current with btrfs-progs userspace (3.14.2 is current) isn't /
quite/ as important, but you don't want to get /too/ far behind.  
Currently you'd want at least 3.12.

If you're willing to do that, and follow this list as well, in ordered to 
keep abreast of the latest (like that bug mentioned above), great, btrfs 
has some nice features and can use testers. =:^)  If not, I'd suggest 
waiting on btrfs for now and checking back in a year or so as it's 
beginning to stabilize now, but there's still some way to go before it's 
fully stable.

> I have been reading various articles on the wiki, lwn.net and elsewhere
> re this FS. One thing I read was an advice to mark large files requiring
> frequent random changes (such as databases or VBox images) as nocow
> using chattr +C as to avoid fragmentation.

Good!  You're doing your research! =:^)

> However, it is also my understanding that BTRFS avoids having to use a
> journal because it does COW, whereby new data is written in empty space
> and the new metadata pointing to this new data is also written in empty
> space, and finally the file pointer points to the new metadata, freeing
> up the old data/metadata blocks. (Correct me if I am wrong.)
> 
> In this case, I am wondering whether using nocow will not affect my
> image adversely as far as data safety is concerned (and this is more
> important than avoiding fragmentation). Say the VBox image is being
> written to directly by overwriting the blocks, but the writing is not
> yet complete, and the system crashes, wouldn't that potentially leave my
> image in an unusable state?
> 
> If the image were in COW mode, then all the new writes would be done to
> a separate block/extent and probably the metadata would not be updated
> or something, whereby the VBox image was just left in its older (usable)
> state without the newer modifications written. If the FS had journaling,
> there would be a different way to provide crash resistance.
> 
> But since BTRFS doesn't have journaling, it seems that this suggestion
> to disable COW on the image file to avoid defragmentation would only
> make it vulnerable to data corruption.

It could, but that's why with any filesystem, by definition if you care 
about the data, you have backups, and if you don't have backups, you self-
evidently don't care /that/ much about the data.  Since that applies even 
more to btrfs in its not yet fully mature state than it does to more 
mature filesystems, either you have that tested backup so it's no big 
deal, or you don't, because you don't care about the data so much anyway, 
so it's still no big deal.  Since either way it's no big deal, the 
performance issues triggered with potentially hundreds of thousands of 
extents due to constant rewrites tend to be the bigger deal.  *BUT*...

You mentioned journaled filesystems.  It's worth noting that at least for 
ext3/4 and reiserfs, unless you have data=journal (which tends to be much 
slower since the data, not just the much smaller metadata, is written 
twice) set, the journal ONLY JOURNALS METADATA, NOT DATA.  And because 
unlike COW-based filesystems they're overwrite-in-place, you don't get 
any specific protection against data corruption in the event of a crash 
while rewriting that data anyway.  So btrfs isn't any worse there, even 
with NOCOW set, tho admittedly if you're running data=journal a journaled 
filesystem is going to be safer, but given btrfs isn't fully stable yet, 
that should be considered to be the case regardless.

Meanwhile, NOCOW is set on the file data, not its metadata, which is 
still COW based.  So the same metadata that's protected by journal on a 
journaling filesystem is still protected by COW on btrfs, even if you set 
the file itself NOCOW.  Now in normal COW mode, btrfs has much better 
protection, both because it COWs the data as well as the metadata that's 
always COWed, and because unlike most other filesystems it checksums the 
data written.  You do lose that extra protection if you set the file 
NOCOW, but when the alternative is a multi-gig image file with literally 
hundreds of thousands of extents due to constant rewriting, and because 
most such large-file-rewrite-pattern apps have already had to evolve at 
least /limited/ file integrity mechanisms of their own to deal with the 
possibility of corruption on ordinary non-checksumming filesystems, 
turning off btrfs COW, and with it the btrfs checksumming (and 
compression if you otherwise have btrfs compression on), isn't as bad as 
it might seem, and in any case not worse than the normal state on other 
filesystems.

> Comments please? Thanks!

Since you're doing your research you might have seen this already, but 
just in case, if you intend to use btrfs snapshotting there's an 
additional twist to NOCOW to be aware of as well.  Since a snapshot locks 
into place the existing extents so they stay available for reading that 
snapshot, the first time a (4 KiB) block of an otherwise NOCOW file is 
written to after a snapshot, it must be COWed anyway, since it can't be 
written in-place due to the snapshot locking in place the old version.  

The file does remain NOCOW and subsequent writes to the same block, until 
the next snapshot anyway, will be rewritten in-place to the location the 
block was copied to with the first write after the snapshot, but if 
you're doing something like scripted snapshots every minute or even every 
half-hour, and your otherwise NOCOW file is being more or less actively 
rewritten at the same time, NOCOW ends up doing very little good, since 
many of those writes will be the first writes to a block after a 
snapshot, and thus will be COWed in any case.

The workaround for this issue involves creating a separate subvolume for 
the directory containing your NOCOW files, since snapshots stop at 
subvolume boundaries.  That allows you to continue taking snapshots of 
the parent subvolume, while excluding the dedicated subvolume with all 
your NOCOW files on it, so they don't end up constantly COWed anyway.

Then, you can use traditional backups for that subvolume, or if you don't 
have enough VM downtime to do reliable backups, snapshot the NOCOW 
subvolume separately but much less frequently, perhaps once a day, take 
your backup of that snapshot and then delete it.  You can then run btrfs 
defrag on the file or subvolume periodically, say once a week, to 
eliminate the fragmentation buildup that did occur due to the less 
frequent but not entirely disabled snapshotting.

Of course it's worth keeping in mind that while this might seem to be a 
bad limitation, most filesystems don't have a snapshotting feature at 
all, and a snapshotting feature with a couple limitations beats no 
snapshotting feature at all any day of the week. =:^)


Meanwhile, if you're that concerned about data corruption, you might wish 
to run a dual-device btrfs in raid1 mode for both data and metadata.  In 
addition to the protection against device failure that raid1 normally 
provides, with btrfs' data-integrity and checksumming features having two 
copies of the data due to the raid1 gives it a second copy to pull from 
in case the checksum verify fails on the first one it tries.  When I've 
crashed here, a lot of the time after a reboot I can run a scrub and 
recover from the corruption of the one copy of whatever was being written 
at the time, by replacing it with the other, still good copy.

I did have one time I had to run btrfs restore and recover from what it 
gave me and backups, but as I said, btrfs isn't fully mature and stable 
yet, so a problem once in awhile might be expected and I was reasonably 
prepared for it, altho the backups weren't actually as current as I might 
have liked, but that was entirely my own fault.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

