Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:64406 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758763Ab2HHQGy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Aug 2012 12:06:54 -0400
Message-ID: <50228E9B.8080300@giantdisaster.de>
Date: Wed, 08 Aug 2012 18:06:51 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Olivier Bonvalet <btrfs.list@daevel.fr>, Chris Samuel <chris@csamuel.org>,
        linux-btrfs@vger.kernel.org, David Sterba <dave@jikos.cz>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:5038 (linux 3.4.7)
References: <501987FF.9080304@daevel.fr> <20120802132259.GO17430@twin.jikos.cz> <501A836F.90506@daevel.fr> <20120802135354.GQ17430@twin.jikos.cz> <501AA842.5080300@daevel.fr> <501C53B7.30601@daevel.fr> <501E3578.4030809@csamuel.org> <501E7F23.3040401@daevel.fr> <20120808144557.GW17430@twin.jikos.cz>
In-Reply-To: <20120808144557.GW17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 8 Aug 2012 16:45:57 +0200, David Sterba wrote:
> On Sun, Aug 05, 2012 at 04:11:47PM +0200, Olivier Bonvalet wrote:
>> Aug  5 16:10:12 backup2 kernel: [   58.674758] parent transid verify failed on 615015833600 wanted 110423 found 110424

1st mirror fails verify_parent_transid().

>> Aug  5 16:10:12 backup2 kernel: [   58.675090] parent transid verify failed on 615015833600 wanted 110423 found 110424

2nd mirror fails verify_parent_transid().

>> Aug  5 16:10:12 backup2 kernel: [   58.675523] btrfs read error corrected: ino 1 off 615015833600 (dev /dev/mapper/vg--backupplug-backup sector 1209083504)

That's a bug. It is wrong to ignore the previous results from
verify_parent_transid() and to call repair_eb_io_failure() which
rewrites one mirror and claims to have corrected an error. But it's not
a major issue, just a misleading message in the kernel log and a disk
write operation which does not repair anything.

> This looks strange, the the corrupted block belongs to metadata, I
> assume you have the DUP profile, so there is a good copy that can be
> used instead, the error message confirms that, but ...
> 
>> Aug  5 16:10:12 backup2 kernel: [   58.675536] Failed to read block groups: -5

That's correct, because the UPTODATE flag in the extent is not set
(verify_parent_transid() clears it when it detects an error).

> ... ? -5 means EIO, which is returned when a block cannot be read, so
> unless there's a different reason for it, this looks like a missed
> oportunity to fix an error and continue.
> 
> The same error messages are present in the logs from 3.4 version.
> 
>> Aug  5 16:10:12 backup2 kernel: [   58.704720] btrfs: open_ctree failed

The summary is that the block was not correctable, both mirrors had the
same old transid. The bug is that the call to repair_io_failure() should
not have been done because verify_parent_transid() indicated errors.

I'll prepare a patch for it. Changing btree_read_extent_buffer_pages()
to set ret to -EIO if verify_parent_transid() fails should fix the issue.
