Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42868 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbbEBQaQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 May 2015 12:30:16 -0400
Date: Sat, 2 May 2015 09:30:10 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Manana <fdmanana@gmail.com>, christian@vivaldi.com
Message-ID: <20150502163010.GK13624@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150502141102.GB1809@merlins.org>
 <20150501210013.GH13624@merlins.org>
 <20150429232130.GA23814@merlins.org>
Subject: Re: 3.19.3: check tree block failed + WARNING: device 0 not present
 on scrub
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm Cc'ing Christian because he reported the same problem of getting
this during scrub:
WARNING: device 0 not present
scrub device /dev/sda3 (id 1) done
    scrub started at Sat Apr 25 23:55:56 2015 and finished after 233 seconds
    total bytes scrubbed: 100.39GiB with 0 errors
scrub device  (id 0) canceled
    scrub started at Sat Apr 25 23:55:56 2015 and was aborted after 0 seconds
    total bytes scrubbed: 0.00B with 0 errors

Mine was doing it too, but then it stopped out of the blue.

So I was debugging a btrfs send issue with Filipe, and then we found
this:

btrfs-debug-tree -t 2 /dev/mapper/cryptroot 2>&1 | tee /tmp/debug_2.txt

leaf 372551614464 items 125 free space 7363 generation 1911640 owner 2
fs uuid 79a9a6c7-0955-4820-b81e-0c0681a657c1
chunk uuid a45c7819-9aee-4999-8a39-566181679f9c
	item 0 key (291412238336 EXTENT_ITEM 16384) itemoff 16178 itemsize 105
		extent refs 5 gen 688250 flags DATA
		extent data backref root 23942 objectid 2028 offset 27253407744 count 1
		shared data backref parent 919382933504 count 1
		shared data backref parent 510112530432 count 1
		shared data backref parent 510100160512 count 1
		shared data backref parent 230103220224 count 1
(...)
	item 123 key (291431116800 EXTENT_ITEM 4096) itemoff 10554 itemsize 37
		extent refs 1 gen 172150 flags DATA
		shared data backref parent 510226677760 count 1
	item 124 key (291431120896 EXTENT_ITEM 32768) itemoff 10488 itemsize 66
		extent refs 2 gen 334924 flags DATA
		extent data backref root 23942 objectid 2028 offset 85580054528 count 1
		shared data backref parent 504622628864 count 1
Check tree block failed, want=612294639616, have=687330107929042309
Check tree block failed, want=612294639616, have=687330107929042309
Check tree block failed, want=612294639616, have=10656972372562425046
Check tree block failed, want=612294639616, have=10656972372562425046
Check tree block failed, want=612294639616, have=10656972372562425046
read block failed check_tree_block
failed to read 612294639616 in tree 2
parent transid verify failed on 935174963200 wanted 1912353 found 1912435
parent transid verify failed on 935174963200 wanted 1912353 found 1912435
parent transid verify failed on 935174963200 wanted 1912353 found 1912435
parent transid verify failed on 935174963200 wanted 1912353 found 1912435
Ignoring transid failure
print-tree.c:1071: btrfs_print_tree: Assertion failed.
btrfs-debug-tree[0x410489]
btrfs-debug-tree[0x411dbf]
btrfs-debug-tree[0x402adb]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7fc2bc6b9b45]
btrfs-debug-tree[0x402d85]
 

On Sat, May 02, 2015 at 07:11:02AM -0700, Marc MERLIN wrote:
> On Sat, May 02, 2015 at 12:24:14PM +0100, Filipe David Manana wrote:
> > That looks bad.
> > Is this by chance a multi devices fs? Is some device missing?
>  
> It's not. It's a single device.
> 
> I run scrub from cron nightly, no errors.
> 
> > Given that you have such errors reported for the extent tree (id 2),
> > which is a critical tree for the fs to work, I wouldn't expect you to
> > be able to use the fs and maybe not even mount it - but since you
> > never had the fs turn into readonly mode or reported any crashes, etc,
> > lets hope it's just one device missing due to udev rules (I never
> > looked into that part myself).
> 
> It's not, laptop is working just fine (seemingly) and scrub is passing
> nightly.
> 
> btrfs check, I'll have to reboot my laptop from another device before I
> can run this since I can't check my mounted filesystem, correct?
> 
> Oooh, but not that you mention it, I have had scrub return this for a few
> days:
> WARNING: device 0 not present
> during a scrub, even though I had a single device filesystem.
> 
> It then went away on its own without me being able to figure out what it
> was.

Does anyone know what that 'WARNING: device 0 not present' on scrub
could be considering my filesystem is a single device filesystem?

Next, I can't read only btrfs check a mounted filesystem, correct?

If so, should I boot from rescue media, do check and or repair, or try
something else first?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
