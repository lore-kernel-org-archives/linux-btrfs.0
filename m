Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from phi.wiserhosting.co.uk ([77.245.66.218]:47661 "EHLO
        phi.wiserhosting.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbdIKWXu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 18:23:50 -0400
Received: from cpc129066-ando7-2-0-cust212.know.cable.virginm.net ([80.2.13.213]:35568 helo=[172.16.100.1])
        by phi.wiserhosting.co.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.89)
        (envelope-from <pete@petezilla.co.uk>)
        id 1drWO3-000Bbo-7y
        for linux-btrfs@vger.kernel.org; Mon, 11 Sep 2017 22:37:00 +0100
Subject: Re: Storage and snapshots as historical yearly
To: linux-btrfs@vger.kernel.org
References: <9208764.SjP1vfhOIA@pcsenen>
 <07ff0aeb-d4a8-ffb9-3a13-695ab9b2e65f@gmail.com>
From: Pete <pete@petezilla.co.uk>
Message-ID: <34d8d690-d999-0081-4a80-65a6de439639@petezilla.co.uk>
Date: Mon, 11 Sep 2017 22:36:59 +0100
MIME-Version: 1.0
In-Reply-To: <07ff0aeb-d4a8-ffb9-3a13-695ab9b2e65f@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/11/2017 07:49 PM, Austin S. Hemmelgarn wrote:

> Unfortunately, I don't know of any overlay mount implementation that
> works correctly and reliably with BTRFS.  I know for a fact that
> OverlayFS (the upstream in-kernel implementation) does not work, and I
> believe that AUFS3 and UnionFS (the third-party options that are used by
> most LiveCD's) don't work either.  UnionFS-FUSE (a userspace
> implementation completely unrelated to UnionFS) might work, but I've
> never tested it and it will likely have performance issues because it's
> implemented in userspace.  As far as I know, whiteout support is the
> primary missing piece here, but I may be mistaken.
> 

Diverting away from the original topic, what issues with overlayfs and
btrfs?

I'm using btrfs to create 'base' operating system containers (btrfs) and
then using overlayfs for a few 'upper' containers for specific
applications, so the upper parts of the overlays contain only the config
and data files and I can apply OS updates only on the lower ones.

I do note that changes in the 'base' os can take time to propagate to
the upper containers and I'm probably not being sensible in not stopping
the upper containers when updating the lower ones.  This is also does
not seem to be what overlaysfs is intended for.  However, for my light
usage it generally works OK and is useful to me.

Pete
