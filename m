Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40679 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757584AbdECUke (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 16:40:34 -0400
Date: Wed, 3 May 2017 13:40:25 -0700
From: Marc MERLIN <marc@merlins.org>
To: Roman Mamedov <rm@romanrm.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>
Subject: Re: btrfs check --repair: failed to repair damaged filesystem,
 aborting
Message-ID: <20170503204025.t5xqoqaey2m4gdut@merlins.org>
References: <20170501170641.GG3516@merlins.org>
 <20170501180856.GH3516@merlins.org>
 <CAJCQCtR4Hr5ekASiqWn2RNju5pHz8itS91N=M29Cz8Nqx8=kqA@mail.gmail.com>
 <20170502032346.ayhh3n3uh5d5ekbb@merlins.org>
 <CAJCQCtRaeejj4b+J6M7VTsDAe7Sn4PUtBwcvHXgfLNAFe=8Jqg@mail.gmail.com>
 <20170502051155.igmbqcqgzi4ukefg@merlins.org>
 <20170502184722.GN3516@merlins.org>
 <20170503060008.t35vdhgz2suj3e5l@merlins.org>
 <20170503061711.jowqa5wh3mtzjbww@merlins.org>
 <20170503113226.757f492e@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170503113226.757f492e@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 03, 2017 at 11:32:26AM +0500, Roman Mamedov wrote:
> > Actually, another thought:
> > Is there or should there be a way to repair around the bit that cannot
> > be repaired?
> > Separately, or not, can I locate which bits are causing the repair to
> > fail and maybe get a pointer to the path/inode so that I can hopefully
> > just delete those bad data structures (assuming deleting them is even
> > possible and that the FS won't just go read only as I try to do that)
> 
> There is the "btrfs-corrupt-block" tool which helped me to kick Btrfsck
> further along its course in a similar "unrepairable" situation.
> https://www.spinics.net/lists/linux-btrfs/msg53061.html
> 
> In your case it appears like the block 2899180224512 is giving it the most
> trouble, so you could start with killing that one. From what I can tell this
> tool zeroes out the entire block, so Btrfsck can simply delete the reference
> and forget it, rather than repeatedly trying to figure out solutions and
> bailing out with "failed to repair damaged filesystem, aborting".
> 
> Depending on what was stored in it, you may have either no visible effect, or
> a complete filesystem failure, or anything in between. Hence if you want to
> experiment with this, find a way to work on writable overlay snapshots (also
> described in the linked message).

Thanks for the tip. This does not seem to have worked at all, though.
Did I do something wrong?

gargamel:/var/local/src/btrfs-progs# ./btrfs-corrupt-block -l  2899180224512 /dev/mapper/dshelf2
mirror 1 logical 2899180224512 physical 2814363009024 device /dev/mapper/dshelf2
corrupting 2899180224512 copy 1
mirror 2 logical 2899180224512 physical 2814899879936 device /dev/mapper/dshelf2
corrupting 2899180224512 copy 2


gargamel:/mnt/btrfs_pool1# btrfs check --repair /dev/mapper/dshelf2
(...)
checksum verify failed on 2899180224512 found F25BEE55 wanted 00000000
checksum verify failed on 2899180224512 found F25BEE55 wanted 00000000
checksum verify failed on 2899180224512 found E5245DBD wanted 00000000
checksum verify failed on 2899180224512 found F25BEE55 wanted 00000000
bytenr mismatch, want=2899180224512, have=0
Repaired extent references for 3566695825408
ref mismatch on [6674127745024 32768] extent item 0, found 1
Backref 6674127745024 parent 7566652473344 owner 0 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 6674127745024 parent 7566652473344 owner 0 offset 0 found 1 wanted 0 back 0x555cb4e9ced0
backpointer mismatch on [6674127745024 32768]
checksum verify failed on 6983266418688 found 393B112A wanted 2B19CD5C
checksum verify failed on 6983266418688 found 393B112A wanted 2B19CD5C
checksum verify failed on 6983266418688 found BCBF9E15 wanted 785FF67E
checksum verify failed on 6983266418688 found 393B112A wanted 2B19CD5C
bytenr mismatch, want=6983266418688, have=13671317608077697645
checksum verify failed on 2899180224512 found F25BEE55 wanted 00000000
checksum verify failed on 2899180224512 found F25BEE55 wanted 00000000
checksum verify failed on 2899180224512 found E5245DBD wanted 00000000
checksum verify failed on 2899180224512 found F25BEE55 wanted 00000000
bytenr mismatch, want=2899180224512, have=0
failed to repair damaged filesystem, aborting

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
