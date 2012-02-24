From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Strange prformance degradation when COW writes happen at fixed
 offsets
Date: Fri, 24 Feb 2012 06:38:07 +0000 (UTC)
Message-ID: <pan.2012.02.24.06.38.07@cox.net>
References: <CAB3q8748dryFek4UZnh+5__feqp_ffCX-VdZNkcs62B=X47Ghw@mail.gmail.com>
	<CAB3q874F+6HrjvxYduex3sKcskMYcVXOa_CqW6i1F=gDv8+u7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Nik Markovic posted on Thu, 23 Feb 2012 20:31:02 -0600 as excerpted:

> I noticed a few errors in the script that I used. I corrected it and it
> seems that degradation is occurring even at fully random writes:

I don't have an ssd, but is it possible that you're simply seeing erase-
block related degradation due to multi-write-block sized erase-blocks?

It seems to me that when originally written to the btrfs-on-ssd, the file 
will likely be written block-sequentially enough that the file as a whole 
takes up relatively few erase-blocks.  As you COW-write individual 
blocks, they'll be written elsewhere, perhaps all the changed blocks to a 
new erase-block, perhaps each to a different erase block.

As you increase the successive COW generation count, the file's file-
system/write blocks will be spread thru more and more erase-blocks, 
basically fragmentation but of the SSD-critical type, into more and more 
erase blocks, thus affecting modification and removal time but not read 
time.

IIRC I saw a note about this on the wiki, in regard to the nodatacow 
mount-option.  Let's see if I can find it again.  Hmm... yes...

http://btrfs.ipv5.de/index.php?title=Getting_started#Mount_Options

In particular this (for nodatacow, read the rest as there's additional 
implications):

>>>>>
Performance gain is usually < 5% unless the workload is random writes to 
large database files, where the difference can become very large.
<<<<<

In addition to nodatacow, see the note on the autodefrag option.

IOW, with the repeated generations of random-writes to cow-copies, you're 
apparently triggering a cow-worst-case fragmentation situation.  It 
shouldn't affect read-time much on SSD, but it certainly will affect copy 
and erase time, as the data and metadata (which as you'll recall is 2X by 
default on btrfs) gets written to more and more blocks that need updated 
at copy/erase time, 


That /might/ be the problem triggering the freezes you noted that set off 
the original investigation as well, if the SSD firmware is running out of 
erase blocks and having to pause access while it rearranges data to allow 
operations to continue.  Since your original issue on "rotating rust" 
drives was fragmentation, rewriting would seem to be something you do 
quite a lot of, triggering different but similar-cause issues on SSDs as 
well.

FWIW, with that sort of database-style workload, large files constantly 
random-change rewritten, something like xfs might be more appropriate 
than btrfs.  See the recent xfs presentations (were they at ScaleX or 
LinuxConf.au? both happened about the same time and were covered in the 
same LWN weekly edition) as covered a couple weeks ago on LWN for more.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

