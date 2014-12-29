Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067AbaL2ON6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 09:13:58 -0500
Date: Mon, 29 Dec 2014 15:13:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: Remove unnecessary placeholder in btrfs_err_code
Message-ID: <20141229141355.GF6490@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <549A5484.9000202@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <549A5484.9000202@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 24, 2014 at 02:52:04PM +0900, Satoru Takeuchi wrote:
> I once submit the similar patch to btrfs-progs.
> Then Gui Hecheng tell me fixing original code in kernel
> is better.

The kernel header is exported and the authoritative source for the ioctl
definitions, progs usually copy the required portions but should be
identical in the end.

Reviewed-by: David Sterba <dsterba@suse.cz>
