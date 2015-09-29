Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbbI2O4g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 10:56:36 -0400
Date: Tue, 29 Sep 2015 16:55:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Yaowei Bai <bywxiaobai@163.com>
Cc: viro@zeniv.linux.org.uk, clm@fb.com, jbacik@fb.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/17] fs/btrfs: remove unnecessary new_valid_dev check
Message-ID: <20150929145535.GE11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1443446807-4838-1-git-send-email-bywxiaobai@163.com>
 <1443447540-5098-1-git-send-email-bywxiaobai@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443447540-5098-1-git-send-email-bywxiaobai@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 28, 2015 at 09:39:00PM +0800, Yaowei Bai wrote:
> As new_valid_dev always returns 1, so !new_valid_dev check is not
> needed, remove it.
> 
> Signed-off-by: Yaowei Bai <bywxiaobai@163.com>

Acked-by: David Sterba <dsterba@suse.com>
