Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zinan.dashjr.org ([192.3.11.21]:58216 "EHLO zinan.dashjr.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750715AbdAFRwA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Jan 2017 12:52:00 -0500
From: Luke Dashjr <luke@dashjr.org>
To: Joseph Salisbury <joseph.salisbury@canonical.com>, jbacik@fb.com
Subject: Re: [Regression 4.7-rc1] btrfs: bugfix: handle FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
Date: Fri, 6 Jan 2017 17:38:31 +0000
Cc: dsterba@suse.com, stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        clm@fb.com, linux-btrfs@vger.kernel.org, 1619918@bugs.launchpad.net
References: <a555bec3-f0c8-b973-52e0-02bc2e3b5b29@canonical.com>
In-Reply-To: <a555bec3-f0c8-b973-52e0-02bc2e3b5b29@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201701061738.33482.luke@dashjr.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, January 06, 2017 5:22:34 PM Joseph Salisbury wrote:
>     btrfs: bugfix: handle FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in
> btrfs_ioctl
> 
> However, this commit introduced a new regression.  With this commit
> applied, "btrfs fi show" no longer works and the btrfs snapshot
> functionality breaks.

I don't see how this is even possibly related. Furthermore, "btrfs fi show" as 
well as snapshots seem to work just fine for me.

That being said, I've given up on running a 32-bit userspace, so I don't 
really care if this bugfix gets reverted or not.

Luke
