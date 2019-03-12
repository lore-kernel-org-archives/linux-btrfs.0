Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B47AFC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 04:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80633214AE
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 04:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725792AbfCLEA1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 00:00:27 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46748 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbfCLEA0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 00:00:26 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id B07F7259A08; Tue, 12 Mar 2019 00:00:25 -0400 (EDT)
Date:   Tue, 12 Mar 2019 00:00:25 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     linux-btrfs@vger.kernel.org
Subject: Spurious "ghost" "parent transid verify failed" messages on 4.14.x,
 4.20.14
Message-ID: <20190312040024.GI9995@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 4.14.x and 4.20.14 kernels (probably all the ones in between too,
but I haven't tested those), I get what I call "ghost parent transid
verify failed" errors.  Here's an unedited recent example from dmesg:

	[16180.649285] BTRFS error (device dm-3): parent transid verify failed on 1218181971968 wanted 9698 found 9744
	[16864.457119] BTRFS error (device dm-3): parent transid verify failed on 981488238592 wanted 9758 found 9763
	[16864.459153] BTRFS error (device dm-3): parent transid verify failed on 981488238592 wanted 9758 found 9763
	[16865.409955] BTRFS error (device dm-3): parent transid verify failed on 981488238592 wanted 9758 found 9763
	[16865.413091] BTRFS error (device dm-3): parent transid verify failed on 981488238592 wanted 9758 found 9763
	[16865.583441] BTRFS error (device dm-3): parent transid verify failed on 981488238592 wanted 9758 found 9763
	[16865.586602] BTRFS error (device dm-3): parent transid verify failed on 981488238592 wanted 9758 found 9763
	[17364.870504] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
	[17364.879696] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
	[17364.901713] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
	[17376.127722] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
	[17376.129965] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
	[17376.132919] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
	[17376.250605] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
	[17376.253633] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
	[17376.577192] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
	[17376.585174] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
	[17380.720874] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
	[17380.735643] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
	[17383.282250] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
	[17383.286598] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
	[17433.417529] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
	[17433.420685] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
	[17881.816489] BTRFS error (device dm-3): parent transid verify failed on 785410277376 wanted 9786 found 9794
	[17881.820072] BTRFS error (device dm-3): parent transid verify failed on 785410277376 wanted 9786 found 9794
	[17881.824307] BTRFS error (device dm-3): parent transid verify failed on 785410277376 wanted 9786 found 9794
	[19525.602623] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
	[19525.605395] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
	[19525.829326] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
	[19525.834123] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
	[19525.905553] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
	[19525.909302] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
	[19525.914374] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
	[19525.917829] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
	[19525.980067] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
	[19525.983479] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846

They seem to occur while running these simultaneously:

	* rsync receiving a lot of data

	* snapshot delete to make space for more data

	* bees deduping said data--possibly on the snapshot being
	deleted.

All three seem to be needed--these messages do not appear if one of the
above is not running at the time.  I can get the messages on a test VM
that is running nothing but the above three things on the test filesystem.

Unlike the usual disaster cases when "parent transid verify failed"
messages appear, these incidents seem to be entirely harmless.  They've
been appearing for years (since at least the first v4.14 kernels)
and...nothing else happens.  The filesystem doesn't go read-only.
It doesn't become irreparably damaged.  Nothing locks up or crashes
(at the same time).  The system just keeps running normally, often for
months, emitting a few of these messages during longer snapshot deletes.

This happens on several different host systems.  There is no sign of
hardware failure.  It looks like a real bug, but I don't have a simpler
reproducer, and sometimes weeks or months pass between incidents on a
given machine.

Scrubs are always clean.  There are never errors recorded in btrfs
dev stat:

	# btrfs dev stat /testfs/
	[/dev/mapper/vgtest-tvdb].write_io_errs   0
	[/dev/mapper/vgtest-tvdb].read_io_errs    0
	[/dev/mapper/vgtest-tvdb].flush_io_errs   0
	[/dev/mapper/vgtest-tvdb].corruption_errs 0
	[/dev/mapper/vgtest-tvdb].generation_errs 0
	[/dev/mapper/vgtest-tvdc].write_io_errs   0
	[/dev/mapper/vgtest-tvdc].read_io_errs    0
	[/dev/mapper/vgtest-tvdc].flush_io_errs   0
	[/dev/mapper/vgtest-tvdc].corruption_errs 0
	[/dev/mapper/vgtest-tvdc].generation_errs 0

dump-tree on the offending block doesn't find a metadata page in the
block right after the error occurs.  Sometimes it finds a newer block
(higher transid) some hours later:

	# btrfs ins dump-tree -b 984570740736 /dev/mapper/vgtest-tvdc
	btrfs-progs v4.20.1
	leaf 984570740736 items 151 free space 7525 generation 9882 owner EXTENT_TREE
	leaf 984570740736 flags 0x1(WRITTEN) backref revision 1
	[...etc]

Mount options common to all systems exhibiting this behavior:

	rw,noatime,compress,space_cache=v2

	both ssd and nossd

	any of: compress, compress-force, compress-force=zstd, compress=zstd

My guess/theory:  someone is maybe holding a reference to metadata
they don't hold a lock for, and the page is being updated or replaced
underneath due to the snapshot delete, triggering the verification
failure.  The error doesn't get persisted to disk because by the time the
error is discovered, the page was already deleted by the snapshot delete.
No errors are getting persisted to disk, so it's probably something
that happens in a read operation rather than a write operation.  Every
application reads and writes data, so if it were in plain read or write
code someone else would have noticed by now.  it's probably not a common
code path.  bees seems to be required to trigger the bug (or triggers it
much more often) so it may be a problem somewhere in one of the ioctls
bees uses.  bees does a lot of FILE_EXTENT_SAME, TREE_SEARCH_V2, and
LOGICAL_INO ioctls.  It could be any of the three, but FILE_EXTENT_SAME
does writes, and TREE_SEARCH_V2 isn't used by bees to look at items in
EXTENT_TREE, which leaves LOGICAL_INO which starts from EXTENT_TREE and
works outwards to subvol trees.  So my guess is it's a bug in LOGICAL_INO.
