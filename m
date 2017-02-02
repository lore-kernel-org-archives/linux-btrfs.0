Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52597 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751201AbdBBU5S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Feb 2017 15:57:18 -0500
Date: Thu, 2 Feb 2017 21:57:00 +0100
From: Greg KH <greg@kroah.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>, luke@dashjr.org,
        jbacik@fb.com, dsterba@suse.com, clm@fb.com,
        linux-btrfs@vger.kernel.org, 1619918@bugs.launchpad.net
Subject: Re: [REVERT][v4.10][V2] btrfs: bugfix: handle
 FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
Message-ID: <20170202205700.GB28202@kroah.com>
References: <c5c953d1-c276-daec-faf4-4115827dd381@canonical.com>
 <20170202182313.GA10670@kroah.com>
 <36fa4d7d-1b59-7fe4-ad3f-d47372e11416@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <36fa4d7d-1b59-7fe4-ad3f-d47372e11416@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 02, 2017 at 02:58:16PM -0500, Joseph Salisbury wrote:
> On 02/02/2017 01:23 PM, Greg KH wrote:
> > On Thu, Feb 02, 2017 at 12:38:33PM -0500, Joseph Salisbury wrote:
> >> Hello,
> >>
> >> Please consider reverting commit
> >> 4c63c2454eff996c5e27991221106eb511f7db38 in the next v4.x.y release.
> > What release can I remove it from?
> >
> > It isn't in 4.4.y, and 4.9.y doesn't make much sense, unless it's
> > reverted in Linus's tree already?
> >
> > totally confused.
> >
> > greg k-h
> 
> Sorry, commit 4c63c2454eff996c5e27991221106eb511f7db38 was introduced in
> mainline in v4.7-rc1.  The request should be only for kernels newer than
> 4.7-rc1, so 4.9 and 4.10.
> 
> I assume it will come down to 4.9 once reverted in mainline. 

Let me know when it is reverted, and what that revert commit is please.

thanks,

greg k-h
