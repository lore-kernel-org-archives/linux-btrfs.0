Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37666 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751620AbdHPPmH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 11:42:07 -0400
Date: Wed, 16 Aug 2017 17:40:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: copy fsid to super_block s_uuid
Message-ID: <20170816154043.GJ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170801103508.19746-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170801103508.19746-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 01, 2017 at 06:35:08PM +0800, Anand Jain wrote:
> We didn't copy fsid to struct super_block.s_uuid so Overlay disables
> index feature with btrfs as the lower FS.
> 
> kernel: overlayfs: fs on '/lower' does not support file handles, falling back to index=off.
> 
> Fix this by publishing the fsid through struct super_block.s_uuid.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> I tried to know if in case did we deliberately missed this for some reason,
> however there is no information on that. If we mount a non-default subvol in
> the next mount/remount, its still the same FS, so publishing the FSID
> instead of subvol uuid is correct, OR I can't think any other reason for
> not using s_uuid for btrfs.

I think that setting s_uuid is the last missing bit. Overlay needs the
file handle encoding support from the lower filesystem, which is
supported. Filling the whole filesystem id is correct, the subvolume id
is encoded in the file handle buffer from inside btrfs_encode_fh.

>From that point I think the patch is ok, but haven't tested it.
