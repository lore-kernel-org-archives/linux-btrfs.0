Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372AbcDYMKC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 08:10:02 -0400
Date: Mon, 25 Apr 2016 14:09:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, mfasheh@suse.de
Subject: Re: [PATCH 1/3] btrfs-progs: Fix return value bug of qgroups check
Message-ID: <20160425120950.GG23222@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1460946429-578-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460946429-578-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 18, 2016 at 10:27:07AM +0800, Qu Wenruo wrote:
> Before this patch, although btrfsck will check qgroups if quota is
> enabled, it always return 0 even qgroup numbers are corrupted.
> 
> Fix it by allowing return value from report_qgroups function (formally
> defined as print_qgroup_difference).
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

All three applied, thanks.
