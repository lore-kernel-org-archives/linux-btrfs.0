Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40621 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbaLDEto (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Dec 2014 23:49:44 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XwOMI-0006dZ-9t
	for linux-btrfs@vger.kernel.org; Thu, 04 Dec 2014 05:49:42 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 05:49:42 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 05:49:42 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: If btrfs-find-root doesn't find tree roots is the filesystem
 lost?
Date: Thu, 4 Dec 2014 04:49:31 +0000 (UTC)
Message-ID: <pan$27ab5$e7278279$13537424$8737ae33@cox.net>
References: <CAPs0BigJG7_Z34iZXdjSQjSkMGi6SOMnbf60_DjYTotrmqYJ8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sandy McArthur Jr posted on Wed, 03 Dec 2014 20:20:38 -0500 as excerpted:

> mcplex src # btrfs-find-root /dev/sdh1
> Super think's the tree root is at 18948425080832, chunk root 22179840
> Well block 31789056 seems great, but generation doesn't match,
> have=720011, want=720141 level 0

> [many lines similar to the above repeated a lot but no Generation lines]

Actually the numbers in those "have 720011, want 720141 ..." lines refer 
to exactly that, generations, aka transids (the two labels are used 
interchangeably).

I take it you are referring to this on the wiki:

https://btrfs.wiki.kernel.org/index.php/Restore

That information gives you a general /idea/ of what to do, but it's 
/very/ dated at this point, and even healthy filesystems don't have the 
Generation: lines anymore, or at least I don't get them here.

Instead, use btrfs restore -l -t <bytenr> to get the tree-list.  -l gets 
you the tree-list; -t <bytenr> tells restore which bytenr/blockaddr to 
use.

Output from btrfs-find-root (repeat-quoting the above):

> Well block 31789056 seems great, but generation doesn't match,
> have=720011, want=720141 level 0

31789056 is the bytenr/blocknr.  720011 is the generation/transid of that 
root, 720141 is the generation/transid that the superblock says it wants.

On a healthy filesystem, after a bunch of "Well... but..." lines, it'll 
find the tree-root matching the one in the superblock.  Here's an example 
from a healthy filesystem without a lot of commits and thus a relatively 
low generation/transid of 41:

Super think's the tree root is at 112164864, chunk root 20971520
Well block 29360128 seems great, but generation doesn't match, have=27, 
want=41 level 0
Well block 61505536 seems great, but generation doesn't match, have=28, 
want=41 level 0
Well block 61734912 seems great, but generation doesn't match, have=29, 
want=41 level 0
Well block 61997056 seems great, but generation doesn't match, have=30, 
want=41 level 0
Well block 62308352 seems great, but generation doesn't match, have=31, 
want=41 level 0
Well block 62685184 seems great, but generation doesn't match, have=32, 
want=41 level 0
Well block 63012864 seems great, but generation doesn't match, have=33, 
want=41 level 0
Well block 67534848 seems great, but generation doesn't match, have=34, 
want=41 level 0
Well block 73875456 seems great, but generation doesn't match, have=35, 
want=41 level 0
Well block 74465280 seems great, but generation doesn't match, have=36, 
want=41 level 0
Well block 78938112 seems great, but generation doesn't match, have=37, 
want=41 level 0
Well block 111230976 seems great, but generation doesn't match, have=38, 
want=41 level 0
Well block 111575040 seems great, but generation doesn't match, have=39, 
want=41 level 0
Well block 111886336 seems great, but generation doesn't match, have=40, 
want=41 level 0
Found tree root at 112164864 gen 41 level 0

41 commits, with a history going back from 41 to 27.  See how that last 
"Found tree root" block-addr matches the one from the first "Super 
thinks" line?  That's what should happen if it's healthy.

Running btrfs restore -l without the -t will list the other trees 
available in the healthy tree root (gen 41, there's no subvolumes on this 
filesystem so all it has is the basic trees):

tree key (EXTENT_TREE ROOT_ITEM 0) 112197632 level 2
 tree key (DEV_TREE ROOT_ITEM 0) 111853568 level 0
 tree key (FS_TREE ROOT_ITEM 0) 927072256 level 2
 tree key (CSUM_TREE ROOT_ITEM 0) 112295936 level 2
 tree key (UUID_TREE ROOT_ITEM 0) 29458432 level 0
 tree key (DATA_RELOC_TREE ROOT_ITEM 0) 111837184 level 0

Now, picking the block from generation 27 just because...

btrfs restore -l -t 29360128 <device>

parent transid verify failed on 29360128 wanted 41 found 27
parent transid verify failed on 29360128 wanted 41 found 27
parent transid verify failed on 29360128 wanted 41 found 27
parent transid verify failed on 29360128 wanted 41 found 27
Ignoring transid failure
 tree key (EXTENT_TREE ROOT_ITEM 0) 29376512 level 2
 tree key (DEV_TREE ROOT_ITEM 0) 29474816 level 0
 tree key (FS_TREE ROOT_ITEM 0) 927072256 level 2
 tree key (CSUM_TREE ROOT_ITEM 0) 57573376 level 2
 tree key (UUID_TREE ROOT_ITEM 0) 29458432 level 0
 tree key (DATA_RELOC_TREE ROOT_ITEM 0) 29442048 level 0

See how the transids are all 27, but wanted 41?  That's because the 
superblock says generation/transid 41, so that's what's wanted, but I 
told restore to look at a block of a different generation, in this case 
27.


So supposing the generation 41 root got corrupted and couldn't be used.  
I could use find-root to see what else was available, then use restore -l 
with the blocks corresponding to generations going backward, 40, 39, 
38...  until I found one with what looked to be the full set of trees.

Then I'd try restore with the -D (dry run) option, feeding it the block 
corresponding to the generation/transid I had chosen, to see if it looked 
like I could restore most of what I needed.  If so, I'd run the command 
without the -D.  If not, I'd try a block corresponding to a different 
generation to see if it gave me better luck.


Additional notes on restore: 

* At least when I tried it a few userspace version cycles ago, it seemed 
to do a reasonable job at restoring file data.  However, all the restored 
files were written using the user (root) and umask I was working with, so 
file ownership and permissions (meta)data is lost (not restored).  
Additionally, no symlinks at all were restored so I had to recreate those 
manually.

* If restore runs into a large directory it'll think it's looping over 
the same thing over and over (apparently there's a filesystem error that 
will cause it to actually loop like that, thus the test), and prompt 
whether you want to continue or skip to the next directory.  Check and 
see that it's actually writing new files and not actually looping, and 
answer yes, or you'll only get a few of the files in the larger dirs.

Back when I ran it, it would just skip the rest of the directory without 
asking, and I had to run it over and over, pointing it at the same place 
to restore to each time (without overwrite enabled), so it would do a few 
more files each time, until it quit giving me the warning.  I haven't 
actually had to do it with the new prompting code, so I don't know 
exactly how it works, but you may find out. =:^)

Meanwhile, if the above works for you and you'd like, please feel free to 
update that wiki page.  For whatever reason I seem to work better on 
lists/newsgroups than on wiki pages, and I don't have an account on the 
wiki.  But it does need updated, and if you want to quote large parts of 
the above verbatim in ordered to do so I wouldn't mind at all. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

