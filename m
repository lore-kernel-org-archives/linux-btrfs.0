Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645AbbG3JUS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jul 2015 05:20:18 -0400
Date: Thu, 30 Jul 2015 11:20:05 +0200
From: David Sterba <dsterba@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, jamespharvey20@gmail.com
Subject: Re: [PATCH] btrfs-progs: Add missing exit for parse_profile function
Message-ID: <20150730092005.GN6306@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <1438136897-11590-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438136897-11590-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 29, 2015 at 10:28:17AM +0800, Qu Wenruo wrote:
> In parse_profile() function, in error handling route, it output error
> message but forgot to exit(1), causing even profile is not valid, it
> will just fallback to single.
> 
> Reported-by: James Harvey <jamespharvey20@gmail.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
