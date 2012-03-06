From: Duncan <1i5t5.duncan@cox.net>
Subject: Re:   =?ISO-8859-1?Q?=20=08Understanding?= metadata efficiency of btrfs
Date: Tue, 6 Mar 2012 05:30:23 +0000 (UTC)
Message-ID: <pan.2012.03.06.05.30.23@cox.net>
References: <F728B049-9007-4FA6-B75B-0249A472E40C@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Kai Ren posted on Mon, 05 Mar 2012 21:16:34 -0500 as excerpted:

> I've run a little wired benchmark on comparing Btrfs v0.19 and XFS:

[snip description of test]
> 
> I monitor the number of disk read requests
> 
>        #WriteRq  #ReadRq  #WriteSect  #ReadSect
> Btrfs   2403520  1571183    29249216   13512248 
> XFS      625493   396080    10302718    4932800
> 
> I found the number of write quests of Btrfs is significant larger than
> XFS.

> I am not quite familiar with how btrfs commits the metadata change into
> the disks. From the website, it is said that btrfs uses COW B-tree
> which never overwrite previous disk pages. I assume that Btrfs also
> keep an in-memory buffer to keep the metadata changes.  But it is
> unclear to me that how often Btrfs will commit these changes
> and what is the behind mechanism.
> 
> Could anyone please comment on the experiment results and give a brief
> explanation of Btrfs's metadata committing mechanism?

First...

You mentioned "the web site", but didn't specify which one.  FWIW, the 
kernel.org breakin of some months ago threw a monkey wrench in a lot of 
things, one of them being the btrfs wiki.  The official 
btrfs.wiki.kernel.org site is currently a static copy of the wiki from 
before the breakin, so while it has the general btrfs ideas which haven't 
changed from back then, current status, etc, is now rather stale.

But there's a "temporary" (that could end up being permanent, it's been 
months...) btrfs wiki that's MUCH more current, at:

http://btrfs.ipv5.de/index.php?title=Main_Page

So before going further, catch up with things on the current
(temporary?) wiki.  From your post, I'd suggest you read up a bit more 
than you have, because you failed to mention at all the most important 
metadata differences between the two filesystems.  I'm not deep enough 
into filesystem internals to know if these facts explain the whole 
differences above; in fact, the wiki's where I got most of my btrfs 
specific info myself, but they certainly explain a good portion of it!

The #1 biggest difference between btrfs and most other filesystems is 
that btrfs, by default, duplicates all metadata -- two copies of all 
metadata, one copy of data, by default.  On a single disk/partition, 
that's called DUP mode, else it's referred to (not entirely correctly) as 
raid1 or raid10 mode depending on layout.  (The not entirely correctly 
bit is because a true raid1 will have as many copies as there are active 
disks, while btrfs presently only does two-way mirroring.  As such, with 
three plus disks, it's not proper raid1, only two-way-mirroring.  3-way 
and possibly N-way mirroring is on the roadmap for after raid5/6 support, 
which is roadmapped for kernels 3.4 or 3.5, so multi-way-mirroring is 
presumably 3.5 or 3.6.)

It IS possible to setup only single-copy metadata, SINGLE mode, or two 
mirror data as well, but by default, btrfs keeps two copies of metadata, 
only one of data.

So that doubles the btrfs metadata writes, right there, since by default, 
btrfs double-copies all metadata.

The #2 big factor is that btrfs (again, by default, but this is a major 
feature of btrfs, otherwise, you might as well run something else) does 
full checksumming for both data and metadata.  Unlike most filesystems, 
if cosmic rays or whatever start flipping bits on your data, btrfs will 
catch that, and if possible, retrieve a correct copy from elsewhere.  
This is actually one of the reasons for dual-copy metadata... and data 
too if you configure btrfs for it -- if the one copy is bad (fails the 
checksum validation) and there's another copy, btrfs will try to use it, 
instead.

And of course all these checksums must be written somewhere as well, so 
that's another huge increase in written metadata, even for 0-length 
files, since the metadata itself is checksummed!

And the checksumming goes some way toward explaining all those extra 
reads, as well, as any sysadmin who has run raid5/6 against raid1 can 
tell you, because in ordered to write out the new checksums, unchanged 
(meta)data must be read in, and on btrfs, existing checksums read in and 
verified as well, to make sure the existing version is valid, before 
making the change and writing it back out.

As I said, I don't know if this explains /all/ the difference that you're 
seeing, but it should be quite plain that the btrfs double-metadata and 
integrity checking is going to be MULTIPLE TIMES more work and I/O than 
what more traditional filesystems such as the xfs you're comparing 
against must do.

That's all covered in the wiki, actually, both of them, since those are 
btrfs basics that haven't changed (except the multi-way-mirroring roadmap) 
in some time.  That they're such big factors and that you didn't mention 
them at all, indicates to me that you've quite some reading to do about 
btrfs, since they're so very basic to what makes it what it is.  
Otherwise, you might as well just be using some other filesystem instead, 
especially since btrfs is still quite experimental, while there's many 
more traditional filesystems out there that are fully production ready.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

