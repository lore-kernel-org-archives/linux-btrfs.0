Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab3AJOMk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 09:12:40 -0500
Date: Thu, 10 Jan 2013 15:12:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <liub.liubo@gmail.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: fix 284 ENOENT error
Message-ID: <20130110141239.GF20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1357482638-27129-1-git-send-email-liub.liubo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1357482638-27129-1-git-send-email-liub.liubo@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 06, 2013 at 10:30:38PM +0800, Liu Bo wrote:
> 284 misses a 'mkdir' operation.
> 
> Signed-off-by: Liu Bo <liub.liubo@gmail.com>
Tested-by: David Sterba <dsterba@suse.cz>
