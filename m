Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53629 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752021AbeDFM5t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Apr 2018 08:57:49 -0400
Date: Fri, 6 Apr 2018 14:55:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Peter Kjellerstedt <peter.kjellerstedt@axis.com>
Cc: linux-btrfs@vger.kernel.org, pkj@axis.com
Subject: Re: [PATCH] btrfs-progs: build: Do not use cp -a to install files
Message-ID: <20180406125517.GA8557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180404140459.20644-1-pkj@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180404140459.20644-1-pkj@axis.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 04, 2018 at 04:04:59PM +0200, Peter Kjellerstedt wrote:
> Using cp -a to install files will preserve the ownership of the
> original files (if possible), which is typically not wanted. E.g., if
> the files were built by a normal user, but are being installed by
> root, then the installed files would maintain the UIDs/GIDs of the
> user that built the files rather than be owned by root.
> 
> Signed-off-by: Peter Kjellerstedt <peter.kjellerstedt@axis.com>

Applied and added to 4.16, thanks.
