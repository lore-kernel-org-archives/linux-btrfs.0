Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53465 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750703AbdI0KyZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 06:54:25 -0400
Date: Wed, 27 Sep 2017 12:52:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: fix send ioctl on 32bit with 64bit kernel
Message-ID: <20170927105250.GX31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506458409-2428-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506458409-2428-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 26, 2017 at 04:40:09PM -0400, Josef Bacik wrote:
> We pass in a pointer in our send arg struct, this means the struct size doesn't
> match with 32bit user space and 64bit kernel space.  Fix this by adding a compat
> mode and doing the appropriate conversion.

How does this differ from the existing workaround that adds the 32bit
structure (btrfs_ioctl_timespec_32 and
btrfs_ioctl_received_subvol_args_32 at the top of ioctl.c) and the
btrfs_compat_ioctl() (at the end of ioctl.c)?
