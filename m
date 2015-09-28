Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36920 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbbI1CTm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Sep 2015 22:19:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZgO2U-0005VT-CR
	for linux-btrfs@vger.kernel.org; Mon, 28 Sep 2015 04:19:38 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 04:19:38 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 04:19:38 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mkfs.btrfs(8) --data outdated?
Date: Mon, 28 Sep 2015 02:19:32 +0000 (UTC)
Message-ID: <pan$d27fc$1a42a006$3814459b$d2b2ea95@cox.net>
References: <mu9jpv$l25$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Juan Francisco Cantero Hurtado posted on Sun, 27 Sep 2015 22:33:01 +0200
as excerpted:

> kernel: 4.1.7
> btrfs-progs: 4.2
> 
> mkfs.btrfs(8) man page says:

> -d|--data <type>
>      Specify how the data must be spanned across the devices specified.
>      Valid values are raid0, raid1, raid5, raid6, raid10 or single.
> 
> $ sudo mkfs.btrfs -d dup -m dup -M -O no-holes -f /dev/sdb1
> SMALL VOLUME: forcing mixed metadata/data groups
> btrfs-progs v4.2
> See http://btrfs.wiki.kernel.org for more information.
> 
> Label:              (null)
> UUID:               29de8c3e-92da-4fe1-aa31-830c1068f532
> Node size:          4096
> Sector size:        4096
> Filesystem size:    3.00GiB
> Block group profiles:
>    Data+Metadata:    DUP             161.56MiB
>    System:           DUP             12.00MiB
> SSD detected:       no
> Incompat features:  mixed-bg, extref, skinny-metadata, no-holes
> Number of devices:  1
> Devices:
>     ID        SIZE  PATH
>      1     3.00GiB  /dev/sdb1
> 
> 
> The man page doesn't mention the option "-d dup". Am I missing something
> or the man page is outdated?. The partition will contain two copies of
> the data blocks?

The manpage isn't exactly outdated (for that, but see below), you just 
missed the implications of what it said about another option, -M|--mixed, 
and the SMALL VOLUME notation.

The...

SMALL VOLUME: forcing mixed metadata/data groups

... explicitly tell you it's enabling mixed mode (which is the default 
for 1 GiB and smaller filesystems, tho the manpage just says recommended, 
not mentioning that it's the default, so it's arguably outdated in that 
regard, tho the mkfs.btrfs output is explicit if there's any doubt).

But while you have a 3.00 GiB filesystem that wouldn't default to mixed-
mode, you specifically enabled it with the -M option.

In fact, there has been some discussion about upping the default breakover 
between separate data/metadata block groups and mixed-mode, to something 
like 32 GiB, but AFAIK, nobody has ever actually submitted a patch to do 
so, so the default breakover remains 1 GiB, despite it being apparently 
generally agreed on-list that mixed-mode would be a better default to at 
least 16 if not 32 GiB.  (Tho with btrfs now automatically cleaning empty 
chunks, the need for this is less than it was back before that change, 
around 3.17, IIRC, but it's arguably still a good idea.)

So at 3 GiB, your choice of mixed-mode was arguably wise. =:^)

But that you specifically chose mixed-mode with the -M option, and yet 
are still posting this question, indicates that while you might well know 
it's recommended at the 3 GiB filesystem level, you remain confused as to 
what it actually does.

What mixed-mode does is this.  Instead of creating separate data and 
metadata chunks (aka block-groups), data and metadata are combined into a 
single, mixed-chunk, format.  While slightly less efficient performance-
wise, this allows maximum flexibility in terms of space usage, allowing 
you to fill the filesystem much closer to 100% without running out of 
space in either data or metadata chunks while still having plenty of room 
in the other.  As such, with data chunks nominally 1 GiB (tho they're 
smaller as space gets tight and initial data chunks can be bigger on TiB-
scale filesystems) and metadata chunks nominally 256 MiB, the extra 
flexibility of being able to use that last bit of space on a small 
filesystem can really make a difference.

OTOH, metadata defaults to dup mode on single-device filesystems (except 
on SSD) for reliability reasons, with data defaulting to single mode.  
And mixed mode takes that default from the metadata side, so it too 
defaults to dup, for data as well as metadata since they're mixed in the 
same block-groups -- on the smallest filesystems, where dup mode data 
*REALLY* puts a crimp in how much room you actually have to store stuff!


So mixed-bg mode is definitely a tradeoff, since with mixed-bg you can't 
set data and metadata replication modes separately because they're 
combined in the same chunks/bgs, meaning you have to choose either the 
riskier single mode for metadata as well as data, or the duplicating and 
thus space gobbling dup mode for data as well as metadata... on a small 
filesystem that's likely already tight on space!

On the bright side, with dup mode mixed-bgs, the increased reliability of 
dup mode metadata now applies to data too, so damage to the device that 
doesn't take out the entire device, just some parts of it, is less likely 
to trigger loss of access to the file, as there's a second copy available 
that with a bit of luck hasn't been damaged. =:^)

In fact, because separate data/metadata doesn't even give you the option 
of dup mode for data, only for metadata, some people actually choose to 
use mixed-mode on much larger filesystems as well, even at the expense of 
performance mixed mode implies, simply to be able to get the extra 
protection dup mode gives them. =:^)


Meanwhile, while we're on the topic, it may be useful to note another 
difference of mixed-bg mode that doesn't affect normal operation, but 
that you'll run into if you try to use btrfs balance filters.  Balance 
filters are normally applied using the -d[<filters>] -m[<filters>] 
options, for data and metadata chunks, respectively.  As such, there's no 
explicit balance-filters support for mixed-bg mode, but they can still be 
applied, provided both the -d and -m options are given, and the filters 
element for both exactly match.  So for instance you can run...

btrfs balance start -dusage=5 -musage=5 /

... and on a mixed-bg /, it'll work, because the identical usage=5 filter 
has been given for both data and metadata.  But...

btrfs balance start -dusage=5

... without the similar -musage=5, will not run, instead giving you an 
error.  Similarly...

btrfs balance start -dusage=5 -musage=2

... will fail with an error, because it's a usage filter in both cases, 
but the values are different.


(The rest is simply personal experience, with explanation of how I came 
to have a 256 MiB mixed-bg dup mode btrfs in the first place.  Skip it if 
you are pressed for time or your curiosity isn't as active as mine. =:^)

I have two ssds, partitioned identically, with various mostly btrfs raid1 
filesystems setup on the parallel partitions on each ssd.  However, my /
boot partition is an exception, since grub can only point at one /boot, 
so my normal backup method of setting up two partitions of the same size 
on each device, each still raid1 but here two separate copies of the 
filesystem on the same device, one for the working copy filesystem, the 
other for the backup, won't work for /boot, because grub can only point 
at one of them.  (Tho granted, grub2, with its rescue mode, is more 
flexible in this regard than was grub1.  In theory, I could use grub 
rescue mode to point grub at a backup boot partition if i needed to.  
However, grub's rescue mode is much more limited than regular mode, and 
worth avoiding if possible.  And since I had developed this technique 
back on grub1 which didn't have a rescue mode, I could simply continue to 
use it with grub2, thereby avoiding rescue mode unless things get REALLY 
bad. =:^)

So instead of creating /boot as a btrfs raid1, with a second btrfs raid1 
on other partitions on the same devices, I setup only one boot partition 
and filesystem on each device, with grub setup on each device to point at 
its own boot partition.  Since I can select the boot device from BIOS, 
with the BIOS then loading grub as the boot manager from that device, and 
grub in turn pointing at its /boot on the same device, that gives me a 
working copy /boot on one device, and its backup on the other one. =:^)

But without the normal protection of the btrfs raid1 on both the working 
and backup copy that I have for other partitions, I at least wanted btrfs 
dup mode, and it was the default anyway, since the filesystems were well 
under a gig.

The problem is, when I originally did my partition setup, I only setup 
256 MiB partitions for /boot and its backup, thinking that should be 
plenty, as like my other filesystems, it was the same or bigger than the 
partitions I had used previously, when I was using reiserfs.  And I mount 
with compress=lzo on all my btrfs, so in most cases, they actually ended 
up taking less space than the reiserfs version, so the same or more space 
was fine.

But what I forgot to account for was the extra space required for the 
single-device dup-mode data, on the 256 MiB /boot partition on the one 
ssd and its backup on the other.  So instead of extra room due to the 
compression as I had on the other btrfs, on /boot and its backup, I only 
ended up with 128 MiB due to the dup, with the reserved system chunks 
taking several MiB of that! =:^(

So my /boot and its backup ended up with under 128 MiB capacity due to 
the dup, half what I had planned, and as a result, they run *MUCH* closer 
to full than I had intended.  What with the grub2 files as well, I can't 
fit nearly the number of kernels on /boot as I would have liked, and 
while I can still fit several, generally a tested stable, plus a few pre-
release rc kernels, I have to delete those pre-releases a whole lot 
faster than I was used to back with the old reiserfs /boot and its 
backup, where I could generally keep a whole kernel cycle's worth of 
testing kernels, handy when I'm doing a bisect, for instance.

I rebalance occasionally too, trying to keep at least /some/ unallocated 
space on the filesystem.  Which is why I know about having to keep the
-mfilter and -dfilter exactly the same on mixed-bg mode btrfs.

Anyway, I've adapted to it, but they're still smaller than I'd like.  I 
try to fit all my tiny partitions in the first gig, arranging sizes so 
the last one ends at the 1 GiB boundary and all further filesystems are 
in multiples of a GiB and thus GiB aligned.  But when I next repartition, 
I'll probably create /boot and its backup as 384 MiB instead of 256, 
giving it another 128 MiB and thus another 64 MiB capacity with dup.  
Since I'll still be trying to keep the sub-GiB filesystems to the first 
GiB, that means something else will be 128 MiB smaller, probably
/var/log, 512 MiB instead of its current 640 MiB.  (Like the others 
excepting boot and the reserved GPT BIOS and EFI partitions, log is btrfs 
raid1, so while it's tiny and thus mixed-bg too, the dup mode problem 
doesn't apply.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

