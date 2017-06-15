Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54213 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750749AbdFOQLE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 12:11:04 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D17ECAC29
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jun 2017 16:11:02 +0000 (UTC)
Date: Thu, 15 Jun 2017 18:09:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, jeffm@suse.com
Subject: Re: [PATCH 0/2] Ensure size values are rounded down
Message-ID: <20170615160958.GD25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1497531155-9703-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1497531155-9703-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 15, 2017 at 03:52:33PM +0300, Nikolay Borisov wrote:
> We got an internal report about a file system not wanting to mount 
> following 99e3ecfcb9f4 ("Btrfs: add more validation checks for superblock"). 
> 
> BTRFS error (device sdb1): super_total_bytes 1000203816960 mismatch with
> fs_devices total_rw_bytes 1000203820544
> 
> Substracting the numbers we get a difference of less than a 4kb. Upon closer 
> inspection it became apparent that mkfs actually rounds down the size of the 
> device to a multiple of sector size. However, the same cannot be said for 
> various functions which modify the total size and are called from btrfs_balanace
> as well as when adding a new device. 
> 
> The first patch in the series re-implements the btrfs_device_total_bytes
> getter/setters manually so that we can add a WARN_ON to catch future offenders. 
> I haven't implemented all 4 function that the macros do since we only ever use
> the getter and setter. 
> 
> The second patch ensures that all the values passed to the setter are rounded 
> down to a multiple of sectorsize. I also have an xfstest patch which passes
> after this series is applied. 
> 
> 
> Nikolay Borisov (2):
>   btrfs: Manually implement device_total_bytes getter/setter
>   btrfs: Round up values which are written for total_bytes_size

The fixes look good, but I have a comment about the changelogs. The
first patch just extends the helpers, that's a minor update and should
not contain description of the bug, as it's not the real fix. OTOH, the
2nd patch is the real fix and does not contain any bug description at
all (because it was in another patch and cover letter).

Why do I care about that? Say I'm reading the code and find that some of
the superblock values are rounded down and want to find out why. I look
up the patch in history and land in ... a patch that has no changelog or
even pointers where to look for more information. I'll naturally try to
find a patch that's close in the history but could also fail to find the
right one.

The first patch should be just expansion of the SETGET macro, without
any changes, as the added WARN_ON changes the semantics a bit.

The first three paragraphs of the cover letter hold the information that
should go to the second patch because that actually fixes the problem.
Now it's also good time to extend the setter/getter with the checks.

Also please fix the over >80 lines.
