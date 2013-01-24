Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:59144 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab3AXSm0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 13:42:26 -0500
Date: Thu, 24 Jan 2013 13:42:19 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Filipe Brandenburger <filbranden@google.com>
CC: Chris Mason <clmason@fusionio.com>, Josef Bacik <JBacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Please revert 2794ed0 (fix permissions of empty files not
 affected by umask)
Message-ID: <20130124184219.GG2349@localhost.localdomain>
References: <CADU+-uD1HTtLd3t2VmpChQm00xvAxg3wcd+pWYD9Q_WcMtF0GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CADU+-uD1HTtLd3t2VmpChQm00xvAxg3wcd+pWYD9Q_WcMtF0GA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 24, 2013 at 11:32:17AM -0700, Filipe Brandenburger wrote:
> Hi,
> 
> Please revert commit 2794ed013b3551cbae887ea1b93c52aaacb7370d. That
> patch was meant to be added to btrfs_create and not to btrfs_mknod.
> 
> (It was indeed later added to btrfs_create on commit
> 9185aa587b7425f8f4520da2e66792f5f3c2b815, so that's already OK.)
> 
> btrfs_mknod already has a call to btrfs_update_inode later in the code
> so I don't think the duplicate is really needed at that point.
> 

Hrm sorry I'll fix that in btrfs-next, I probably screwed this up when merging
the patch, I remember having to manually apply this one.  Thanks,

Josef
