Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888AbbKSRgu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 12:36:50 -0500
Date: Thu, 19 Nov 2015 18:35:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: chunk-recovery: Fix a float point error
Message-ID: <20151119173508.GE31035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1447915359-29707-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1447915359-29707-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 19, 2015 at 02:42:39PM +0800, Qu Wenruo wrote:
> Fix a zero division causing chunk-recovery fail.
> 
> Also fix a typo "strpie_length" -> "stripe_length".
> 
> Reported-by: Scotty Edmonds <scotty@scottyedmonds.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
