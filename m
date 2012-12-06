Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:33394 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab2LFOfV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Dec 2012 09:35:21 -0500
Date: Thu, 6 Dec 2012 15:34:58 +0100
From: Mathieu Chouquet-Stringer <mathieu@csetco.com>
To: linux-btrfs@vger.kernel.org
Cc: sami.liedes@iki.fi, chris.mason@fusionio.com, sensille@gmx.net
Subject: GPF in read_extent_buffer while scrubbing on 3.7.0-rc8-00014-g27d7c2a
Message-ID: <20121206143458.GA24396@kashmir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

	Hello,

Using the last couple of kernels (3.6 or 3.7), scrubbing my btrfs fs (which is
on a luks based lvm device) will always end up crashing my pc.

The error (screenshot: http://mathieu.csetco.com/btrfs-scrub-crash.jpeg) looks
very similar to this crash (that's why I'm Cc'ing Sami):

btrfs GPF in read_extent_buffer() while scrubbing with kernel 3.4.2
http://marc.info/?t=134127076600002&r=1&w=2

(I transcribed this from the picture)
Pid: 518, comm: btrfs-endio-met Tainted: G       W    3.7.0-rc8-00014-g27d7c2a
RIP: 0010:[<fffffffff8136c186>]  [<ffffffff8136c186>] memcpy+0x6/0x110
[...]
Call Trace:
 [<ffffffff812aa8a3>] ? read_extent_buffer+0xc3/0x120
 [<ffffffff812a15e2>] btrfs_node_key+0x22/0x30
 [<ffffffff812dd150>] __readahead_hook.isra.5+0x3a0/0x3f0
 [<ffffffff812dd544>] btree_readahead_hook+0x24/0x40
 [<ffffffff81285a99>] btree_readpage_end_io_hook+0x139/0x290
[...]

Looking at the email thread, I can't seem to be able to find a happy
ending.  It looks like this could still be open.

Here's my btrfs device:

Label: none  uuid: 02c68790-78a5-418a-901c-59eda67b0e6e
        Total devices 1 FS bytes used 197.60GB
        devid    1 size 460.41GB used 289.07GB path /dev/dm-2

The output of fi df /:
Data: total=269.00GB, used=195.88GB
System, DUP: total=32.00MB, used=32.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=10.00GB, used=1.71GB

Anything I could do to help diagnose the issue?  I've seen Chris
suggested to enable slub (I use slub, not slab) and pagealloc debug.

What else?

-- 
Mathieu Chouquet-Stringer                         mathieu@csetco.com
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
