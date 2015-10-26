Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37760 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbbJZS6f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 14:58:35 -0400
Date: Mon, 26 Oct 2015 19:57:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, chandan@mykolab.com
Subject: Re: [PATCH] Btrfs-progs: Prevent creation of filesystem with 'mixed
 bgs' and having differing sectorsize and nodesize.
Message-ID: <20151026185710.GQ13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1444844438-20001-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444844438-20001-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 14, 2015 at 11:10:38PM +0530, Chandan Rajendra wrote:
> mkfs.btrfs allows creation of Btrfs filesystem instances with mixed block
> group feature enabled and having a sectorsize different from nodesize.
> For e.g:
> 
> [root@localhost btrfs-progs]# mkfs.btrfs -f -M -s 4096 -n 16384  /dev/loop0
> Forcing mixed metadata/data groups
> btrfs-progs v3.19-rc2-404-gbbbd18e-dirty
> See http://btrfs.wiki.kernel.org for more information.
> 
> Performing full device TRIM (4.00GiB) ...
> Label:              (null)
> UUID:               c82b5720-6d88-4fa1-ac05-d0d4cb797fd5
> Node size:          16384
> Sector size:        4096
> Filesystem size:    4.00GiB
> Block group profiles:
>   Data+Metadata:    single            8.00MiB
>   System:           single            4.00MiB
> SSD detected:       no
> Incompat features:  mixed-bg, extref, skinny-metadata
> Number of devices:  1
> Devices:
>   ID        SIZE  PATH
>    1     4.00GiB  /dev/loop6
> 
> This commit fixes the issue by setting BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS
> feature bit before checking the validity of nodesize that was specified on the
> command line.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Test added and applied, thanks.
