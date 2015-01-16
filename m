Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbbAPKzd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Jan 2015 05:55:33 -0500
Date: Fri, 16 Jan 2015 11:55:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: cleanup init for list in free-space-cache
Message-ID: <20150116105532.GN3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1419990695-2062-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1419990695-2062-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 31, 2014 at 09:51:35AM +0800, Gui Hecheng wrote:
> o removed an unecessary INIT_LIST_HEAD after LIST_HEAD
> 
> o merge a declare & INIT_LIST_HEAD pair into one LIST_HEAD
> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
