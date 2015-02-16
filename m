Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922AbbBPOot (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Feb 2015 09:44:49 -0500
Date: Mon, 16 Feb 2015 15:44:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v9 9/9] btrfs: Use sb_want_write() to protect sysfs
 feature change.
Message-ID: <20150216144446.GO8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1424048525-26274-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1424048525-26274-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 16, 2015 at 09:02:05AM +0800, Qu Wenruo wrote:
> Just like label change, use sb_want_write() to do a correct protection.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
