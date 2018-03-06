Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54788 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750864AbeCFKQw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Mar 2018 05:16:52 -0500
Date: Tue, 6 Mar 2018 11:14:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Ken Swenson <flat@imo.uto.moe>, linux-btrfs@vger.kernel.org
Subject: Re: ERROR: unsupported checksum algorithm 35355
Message-ID: <20180306101431.GK5942@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1b11c57b-ee9f-b94a-3d79-bbacf01ba3bf@imo.uto.moe>
 <8baab099-5779-396b-354a-5f1dfc68f915@gmx.com>
 <4b7057c1-474b-68bc-ec44-e63d40d5e597@imo.uto.moe>
 <eec52354-a579-b2b2-328b-fd01ae2b2f0c@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <eec52354-a579-b2b2-328b-fd01ae2b2f0c@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 06, 2018 at 04:45:40PM +0800, Qu Wenruo wrote:
> Here is the fixed superblock.
> 
> csum type and incompat flags get fixed.
> 
> I'm not sure if they are the only problems, but I strongly recommend to
> run btrfs check before mount.

I haven't found any other obviously corrupted items. The only
overwritten data are at offset 0xc0 (192) and it's 6 bytes. Not an ascii
pattern nor a looks-like-a-pointer value.

Value on offset 192 looks like a valid block pointer 0x176d2000, but the
csum_type looks quite random and not related to anything I'd suspect.

The overwrite could have happened any time after the last successful
mount, the incompat flags or csum type are not updated on each write
(unlike th tree root pointers or levels, or checksum).

This does not look like a direct memory bitflip, but rather a mysterious
mermory corruption, that could be a bitflip in a pointer that got
redirected to the fs_info::super_copy structure, or something else. A
'check' would tell more.
