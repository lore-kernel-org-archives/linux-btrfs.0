Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36451 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdI0OlA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 10:41:00 -0400
Received: by mail-qt0-f194.google.com with SMTP id t46so9179847qtj.3
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 07:41:00 -0700 (PDT)
Date: Wed, 27 Sep 2017 10:40:58 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: David Sterba <dsterba@suse.cz>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] btrfs: fix send ioctl on 32bit with 64bit kernel
Message-ID: <20170927144057.x3yqjrqbux5fixmf@destiny>
References: <1506458409-2428-1-git-send-email-jbacik@fb.com>
 <20170927105250.GX31640@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170927105250.GX31640@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 27, 2017 at 12:52:50PM +0200, David Sterba wrote:
> On Tue, Sep 26, 2017 at 04:40:09PM -0400, Josef Bacik wrote:
> > We pass in a pointer in our send arg struct, this means the struct size doesn't
> > match with 32bit user space and 64bit kernel space.  Fix this by adding a compat
> > mode and doing the appropriate conversion.
> 
> How does this differ from the existing workaround that adds the 32bit
> structure (btrfs_ioctl_timespec_32 and
> btrfs_ioctl_received_subvol_args_32 at the top of ioctl.c) and the
> btrfs_compat_ioctl() (at the end of ioctl.c)?

This is different because it's for SEND not RECIEVED_SUBVOL.  We have a pointer
in the send args struct which is differently sized on 64bit from 32bit, so we
need the compat struct so it's the right size when it comes into the kernel, and
then we translate from there.  Without this send is broken with 32bit userspace
and a 64bit kernel.  Thanks,

Josef
