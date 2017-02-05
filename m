Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49165 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751344AbdBEMI2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Feb 2017 07:08:28 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1caLcA-0003QE-4R
        for linux-btrfs@vger.kernel.org; Sun, 05 Feb 2017 13:08:18 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs receive leaves new subvolume modifiable during operation
Date: Sun, 5 Feb 2017 13:08:17 +0100
Message-ID: <20170205130817.57a67173@jupiter.sol.kaishome.de>
References: <1485905578.6441.20.camel@gmail.com>
        <pan$4ecd$16bc5e8e$14657c4$261368ad@cox.net>
        <4edfd08e-8d7f-d8d7-bdea-0589b46e4d2b@gmail.com>
        <7ead5d42-9c00-b2df-3fbf-5b8f287760f6@cobb.uk.net>
        <pan$16525$cf7fe24b$7c044b9$74b32f27@cox.net>
        <5c503d69-aaed-680f-de30-75a7323bc753@cobb.uk.net>
        <pan$5f1de$80937cf$9c306858$cafb9e40@cox.net>
        <1b69d1a8-c08b-c9f3-c95b-1d7d71c7d642@cobb.uk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Thu, 2 Feb 2017 10:52:26 +0000
schrieb Graham Cobb <g.btrfs@cobb.uk.net>:

> On 02/02/17 00:02, Duncan wrote:
> > If it's a workaround, then many of the Linux procedures we as
> > admins and users use every day are equally workarounds.  Setting
> > 007 perms on a dir that doesn't have anything immediately security
> > vulnerable in it, simply to keep other users from even potentially
> > seeing or being able to write to something N layers down the subdir
> > tree, is standard practice.  
> 
> No. There is no need to normally place a read-only snapshot below a
> no-execute directory just to prevent write access to it. That is not
> part of the admin's expectation.

Wrong. If you tend to not be in control of the permissions below a
mountpoint, you prevent access to it by restricting permissions on a
parent directory of the mountpoint. It's that easy and it always has
been. That is standard practice. While your backup is running, you have
no control of it - thus use this standard practice!

If you want to make selective or general access to the backups,
snapshot them to a different location later. You should really learn
how to work with scratch locations for a backup. The receiver is such a
scratch location and should be handled like it.

Scratch directories for backup locations are not a bug and not a
workaround. It's just how you should handle it and how it works. By
definition, the target directory cannot be read-only while the backup
is running - so by definition you need other means to protect it.

That in turn defines all your current locations for snapshot as scratch
locations. Put your final snapshots somewhere else if you want your
users access these after successful finishing a backup. You never want
people to access in-transit or partial backups. In-transit and partial
always goes to the scratch directory. Only then, after success of the
backup, a backup should be made available in a final directory.

Maybe your design of your backup is wrong, and not how btrfs handles
that? Using scratch locations is a design you should really really
always use for backups. Every sophisticated admin would agree that this
should be best practice.


-- 
Regards,
Kai

Replies to list-only preferred.

