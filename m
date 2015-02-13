Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbbBMPZV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 10:25:21 -0500
Date: Fri, 13 Feb 2015 16:25:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: cleanup: remove unuesd DEDINE_WAIT() in
 btrfs_bio_counter_inc_blocked()
Message-ID: <20150213152518.GD8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1423726931-7706-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423726931-7706-1-git-send-email-zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 12, 2015 at 03:42:11PM +0800, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> 1: Remove unused DEFINE_WAIT(wait)
> 2: Add likely() for BTRFS_FS_STATE_DEV_REPLACING condition

Using likely() here is poitnless, it's not a performance sensitive path
at all.

> 3: Use a look instead of goto
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Ack, for the rest.
