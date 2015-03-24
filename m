Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbbCXNnE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 09:43:04 -0400
Date: Tue, 24 Mar 2015 14:43:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Mark Brown <broonie@kernel.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix implicit inclusion of linux/uio.h
Message-ID: <20150324134301.GT20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1427042775-8258-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427042775-8258-1-git-send-email-broonie@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 22, 2015 at 04:46:15PM +0000, Mark Brown wrote:
> The btrfs inode.c relies on implicit inclusion of linux/uio.h for
> definitions of struct iov_iter and iov_iter_alignment() which breaks the
> current ARM allmodconfig build where that implicit inclusion does not
> happen.  Add an explicit include to fix that.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Acked-by: David Sterba <dsterba@suse.cz>
