Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:35772 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932877AbaLJUt6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 15:49:58 -0500
Received: from mail-in-10-z2.arcor-online.net (mail-in-10-z2.arcor-online.net [151.189.8.27])
	by mx.arcor.de (Postfix) with ESMTP id D01ED21237C
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 21:49:55 +0100 (CET)
Message-ID: <5488AED6.4030801@arcor.de>
Date: Wed, 10 Dec 2014 21:36:38 +0100
From: Martin Wilck <mwilck@arcor.de>
MIME-Version: 1.0
To: Btrfs Mailing list <linux-btrfs@vger.kernel.org>
CC: Martin Wilck <mwilck@arcor.de>
Subject: A story of btrfs corruption and recovery
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In April 2014, I reported a btrfs corruption on the linux-btrfs
mailing list (http://www.spinics.net/lists/linux-btrfs/msg33318.html).
8 months later, I am happy to be able to say I've been able to recover
the data with a combination of persistence and luck. I want to share
some of my insight with this list in the hope it that may be useful in
future cases.

I also did some work on the btrfs tools to be able to better
understand what was wrong; I will submit the additions and changes I
made for review later.

1. The history

I had created this file system in late 2012 when I installed OpenSUSE
12.2 on a friend's laptop. "btrfs was still unstable at that time", I
imagine you say.  That's easy to say in hindsight. OpenSUSE's
installer offered btrfs as a tier-1 choice, as far as I
remember. Articles written at the time (e.g.
http://rainbowtux.blogspot.de/2012/09/to-btrfs-or-not-to-btrfs.html)
suggest that I wasn't the only person considering it worth a serious
try. Today I wish I hadn't incautiously put my friend's /home on that
FS, too - I've certainly paid for that carelessness. So, /home was
subvolume 263 in this file system.  Complicating matters further, I
had created encrypted home file systems using ecryptfs on top of
btrfs.

2. The disaster

It all went well until April 14, 2014. On that day, the laptop
suddenly crashed.  OpenSUSE Kernel 3.4.11-2.16 was running at the time
of the crash.  Subsequent reboot attempts failed. I described the
phenomena in my posting to linux-btrfs, desparately hoping someone
would give me an easy recipe for recovery. It didn't happen. I got the
recommendation to use a newer version of the kernel and btrfs tools,
but they didn't get me any further. Whatever tool I tried, /home
appeared to be completely empty. I had to dig deeper.

3. The quest

After quite some time, I found the hint, looking at the root
of the /home subvolume, which was a level 2 node:

# ./btrfs-debug-tree -b 980717568 /dev/XX
node 980717568 level 2 items 78 free 43 generation 39637 owner 263
   key (256 INODE_ITEM 0) block 1012207616 (247121) gen 35754

Looking at the supposed level-1 subnode at 1012207616, I found that it
contained data of the wrong level (0), owner (2 - the extent tree),
and generation:

leaf 1012207616 items 26 free space 1967 generation 39622 owner 2
   item 0 key (8266870784 EXTENT_ITEM 12288) itemoff 3942 itemsize 53

So, the tree was massively corrupted at this crucial point; the top
inode of the subvolume couldn't be found, explaining why /home had
appeared empty on every recovery attempt. I looked at the other
children of the children of the tree root, and was pleasantly
surprised that these didn't look bad; I saw inodes and directory
entries of ecryptfs-encrypted home directories, as I had expected.

The obvious next thing to try was to look for previous generations of
the root of the /home subvolume, hoping they weren't corrupted. I
started with the super block root backups, with no luck. Later I went
back all the way from generation 39637 to 38081 (the oldest copy of
this root node I could find), but it was just as corrupted as the last
one - they all pointed to the same wrong level 1 block 1012207616.

I began to wonder whether the all-important level 1 and leaf meta data
of this part of the file system had survived somewhere at all. I
hacked together a tool to search for a specific btrfs key in all of
the meta data, and used it to search for the the key 256-1-0 of the
subvolume 263 (the first inode of the /home file system).  Luckily, I
found exactly one copy of a leaf containing this key, and a handful of
level 1 nodes referring to it.

At this point I didn't yet dare to even think of repairing the file
system.  Rather, I made additional debugging steps. One strange thing
I found was that beyond the 603 top (level 2) copies of /home's root
node, there were several instances with the same generation number:

node 1037123584 level 2 items 78 free 43 generation 39636 owner 263
node 1041215488 level 2 items 78 free 43 generation 39636 owner 263
node 980566016 level 2 items 78 free 43 generation 39636 owner 263
node 980717568 level 2 items 78 free 43 generation 39637 owner 263

Looking at the details of these blocks, I found that the various
level-2-gen-39636-owner-263 were actually different. I have no idea if
this can happen under any circumstances, but it gave me another hint
towards the final solution. Out of the generation 39636 roots listed
above, only the last one showed the original corruption I described -
the others actually had reasonable data in slot 1. My first hope that
these root copies might actually be healthy was quickly destroyed - a
tree dump showed other errors. But, and that was key, these other
corruptions were at different points of the tree. Taking the three
gen-39636 roots together, I was able to find sane data for every part
of the tree.  I was lucky insofar as the total number of corruptions I
needed to fix turned out to be so low that it was doable by hand.

4. The recovery

So I came up with a plan to fix the problem: for each broken link in
one tree, identify a healthy substitute in another one and fix the
link manually. For that purpose, I hacked together another tool
allowing me to do low-level editing of btrfs metadata and insert a
correct checksum at writeback. I verified manually that the metadata
items in the leafs remained well-ordered with the changes I had in
mind.

Eventually, I just needed to fix broken links at three points in the
tree.  I crossed my fingers and ran "btrfs restore" on the hacked tree
- and it extracted the complete /home tree. After that, I still needed
to mess around with ecryptfs tools to recover the pass phrase and make
the plain text data visible again. It certainly felt good when that
finally succeeded!

The encrypted home directories had been a burden in the first place,
because they impeded every debug technique based on searching for
known data. At this stage, they were a big benefit - I could be fairly
sure that there is no more "hidden" data corruption by any problems in
the FS i might have missed, because any such corruption would cause
files to be undecryptable.

5. Can this be generalized?

The repair technique I used could be generalized for a file
system repair tool. If a corrupted link is found in the tree
(unexpected level/owner/ generation), look for a suitable candidate to
substitute the broken link. Try it first by walking ealier
generations of the broken tree. If this fails, do a brute force search
through all meta data. If candidate nodes are found, make a sanity
check (make sure all data in the leaves after the repair are still
well ordered), and then pick the best (latest) node for which the
sanity check succeeded. I am leaving the implementation of this
technique to other interested parties.

6. Further remarks

After having recovered my friend's data, my motivation to do further
debugging decreased. However, I did some further research. As noted
above, the meta data contained several copies of the root of subvol
263 with the same generation.  The same applies to other trees as
well, in particular the root tree and the extent tree. Actually, at
least since generation 39610 (last was 39637), two distinct instances
of both trees seem to have existed.

The two extent trees had different ideas of which blocks were used,
and where meta data was stored (for example, the block 1012207616
mentioned above was listed as a level 1 block of subvol 263 in one of
the extent trees, and as part of the extent tree itself in the
other). Both instances have coexisted through at least 27 generations
(when this mess actually started is hard to tell). Clearly, this could
easily lead to meta data corruption. I can't be sure that this was
actually the root cause, though - some other corruption may have caused
it in the first place.

I have uploaded a sparse file with the system and meta data chunks of
the file system on DropBox
(https://www.dropbox.com/sh/utv8b3qd0do6a04/zTwGQCrN9x; file
img-metadat-sparse.tar.gz; unpack with tar xfzS), just in case anyone
with more btrfs insight than myself wants to take closer look.

Regards and thanks for reading this far,
Martin
