Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:58018 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab3AUXEe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 18:04:34 -0500
Date: Mon, 21 Jan 2013 17:04:30 -0600
From: Ben Myers <bpm@sgi.com>
To: Liu Bo <liub.liubo@gmail.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: fix 284 ENOENT error
Message-ID: <20130121230430.GP27055@sgi.com>
References: <1357482638-27129-1-git-send-email-liub.liubo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1357482638-27129-1-git-send-email-liub.liubo@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Liu,

On Sun, Jan 06, 2013 at 10:30:38PM +0800, Liu Bo wrote:
> 284 misses a 'mkdir' operation.
> 
> Signed-off-by: Liu Bo <liub.liubo@gmail.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

Applied to git://oss.sgi.com/xfs/cmds/xfstests.git

Regards,
	Ben
