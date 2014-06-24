Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbaFXIrv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 04:47:51 -0400
Date: Tue, 24 Jun 2014 10:47:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 3/4] btrfs-progs: delete invalid output file when
 btrfs-image failed
Message-ID: <20140624084749.GR1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140623141557.GG1553@twin.jikos.cz>
 <1403579805-7832-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403579805-7832-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 24, 2014 at 11:16:45AM +0800, Gui Hecheng wrote:
> When btrfs-image failed to create an image, the invalid output file
> had better be deleted to prevent being used mistakenly in the future.
> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
> changelog
>         v1->v2: use a new local variable to avoid return value overwritten
> 	v2->v3: fix patch format problem: tailing whitespace

Thanks, both v3 patches added to integration.
