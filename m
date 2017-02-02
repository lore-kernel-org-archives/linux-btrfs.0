Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45935 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750777AbdBBSXb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Feb 2017 13:23:31 -0500
Date: Thu, 2 Feb 2017 19:23:13 +0100
From: Greg KH <greg@kroah.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, luke@dashjr.org, jbacik@fb.com,
        dsterba@suse.com, clm@fb.com, linux-btrfs@vger.kernel.org,
        1619918@bugs.launchpad.net
Subject: Re: Subject: [REVERT][v4.x.y] btrfs: bugfix: handle
 FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
Message-ID: <20170202182313.GA10670@kroah.com>
References: <c5c953d1-c276-daec-faf4-4115827dd381@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c5c953d1-c276-daec-faf4-4115827dd381@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 02, 2017 at 12:38:33PM -0500, Joseph Salisbury wrote:
> Hello,
> 
> Please consider reverting commit
> 4c63c2454eff996c5e27991221106eb511f7db38 in the next v4.x.y release.

What release can I remove it from?

It isn't in 4.4.y, and 4.9.y doesn't make much sense, unless it's
reverted in Linus's tree already?

totally confused.

greg k-h
