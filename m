Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-sy3aus01on0043.outbound.protection.outlook.com ([104.47.117.43]:54360
        "EHLO AUS01-SY3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751205AbdISLct (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 07:32:49 -0400
From: Paul Jones <paul@pauljones.id.au>
To: "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: kernel BUG at fs/btrfs/extent_io.c:1989
Date: Tue, 19 Sep 2017 11:32:46 +0000
Message-ID: <MEXPR01MB2168CB4F1A1E9F616997FBD89E600@MEXPR01MB2168.ausprd01.prod.outlook.com>
References: <MEXPR01MB2168C2FE0ABD1B78F120044E9E630@MEXPR01MB2168.ausprd01.prod.outlook.com>
 <20170918170930.GC6357@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
In-Reply-To: <20170918170930.GC6357@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: Liu Bo [mailto:bo.li.liu@oracle.com]
> Sent: Tuesday, 19 September 2017 3:10 AM
> To: Paul Jones <paul@pauljones.id.au>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: kernel BUG at fs/btrfs/extent_io.c:1989
> 
> 
> This 'mirror 0' looks fishy, (as mirror comes from btrfs_io_bio->mirror_num,
> which should be at least 1 if raid1 setup is in use.)
> 
> Not sure if 4.13.2-gentoo made any changes on btrfs, but can you please
> verify with the upstream kernel, say, v4.13?

It's basically a vanilla kernel with a handful of unrelated patches.
The filesystem fell apart overnight, there were a few thousand checksum errors and eventually it went read-only. I tried to remount it, but got open_ctree failed. Btrfs check segfaulted, lowmem mode completed with so many errors I gave up and will restore from the backup.

I think I know the problem now - the lvm cache was in writeback mode (by accident) so during a defrag there would be gigabytes of unwritten data in memory only, which was all lost when the system crashed (motherboard failure). No wonder the filesystem didn't quite survive.

I must say though, I'm seriously impressed at the data integrity of BTRFS - there were near 10,000 checksum errors, 4 which were uncorrectable, and from what I could tell nearly all of the data was still intact according to rsync checksums.

Cheers,
Paul.
