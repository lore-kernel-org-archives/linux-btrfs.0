Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793AbcDGRdI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Apr 2016 13:33:08 -0400
Date: Thu, 7 Apr 2016 10:33:05 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: Fix qgroup accounting when creating
 snapshot
Message-ID: <20160407173305.GJ2187@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1459908294-11200-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160407024337.GI2187@wotan.suse.de>
 <570618A1.2080609@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <570618A1.2080609@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 07, 2016 at 04:21:53PM +0800, Qu Wenruo wrote:
> I ran into one soft lockup with my patch only. So I assume it's not
> caused by your inherit patch though.
> But I didn't reproduce it once more. Not sure why.
> 
> What's the reproduce rate in your environment?

It happens every time for me. Just wait about 30 seconds or so (my guess is
to let a transaction commit kick in). Also I can force the issue to show up
if I unmount.
	--Mark

--
Mark Fasheh
