Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965494AbbDVQbY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Apr 2015 12:31:24 -0400
Date: Wed, 22 Apr 2015 18:31:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: report failure when resize ioctl fails
Message-ID: <20150422163122.GF4996@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1429673927-3854-1-git-send-email-ce3g8jdj@umail.furryterror.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1429673927-3854-1-git-send-email-ce3g8jdj@umail.furryterror.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 21, 2015 at 11:38:47PM -0400, Zygo Blaxell wrote:
> The BTRFS_IOC_RESIZE ioctl returns 0 on success, negative for POSIX
> errors, and positive for btrfs-specific errors.
> 
> If resize fails with a btrfs-specific error, decode the error and
> report it.  If we can't decode the error, report its numeric value so
> that the userspace tool is not instantly useless when a new error code
> is defined in the kernel.
> 
> Exit with non-zero status on any resize error.  This is very important
> for scripts that will shrink the underlying storage when btrfs reports
> success!

Added the signed-off-by and applied, thanks.
