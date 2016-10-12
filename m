Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49579 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933101AbcJLPio (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 11:38:44 -0400
Date: Wed, 12 Oct 2016 17:38:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH v2] btrfs: block incompatible optional features at scan
Message-ID: <20161012153802.GT11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458088355-513-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458088355-513-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 16, 2016 at 08:32:35AM +0800, Anand Jain wrote:
> For the matter of completeness we need to check if the device
> being scanned has features that are known to the kernel. As of
> now if it doesn't - the mount will fails, then what is the point
> in having those devices added to the btrfs_fs_devices list at
> device_list_add().
> 
> So block those devices at scan. Which means the original block at
> open_ctee() won't reach in case of device with unsupported feature.
> But I am leaving that code as it is, without deleting.

I think it makes some sense to skip registration of devices with unknown
features. On the other hand, we'd never be able to test-mount a multiple
device filesystem as the devices won't be in the list. The mount would
fail anyway, but I'd rather keep the decision in one place.

Also, device scan would return a new error condition, so the userspace
tools would need to be updated (not a problem) but older versions with
new kernel will become a bit confusing.

Registration of unsupported device should be silently skipped. Current
state will silently register it, but will never let it past mount, so
it's IMHO OK.
