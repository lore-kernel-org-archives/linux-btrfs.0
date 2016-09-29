Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47019 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934253AbcI2RTC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Sep 2016 13:19:02 -0400
Date: Thu, 29 Sep 2016 19:19:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH] btrfs-progs: qgroup: Fix regression leads to corrupted
 qgroup status
Message-ID: <20160929171859.GE5531@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160907025419.23284-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160907025419.23284-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 07, 2016 at 10:54:19AM +0800, Qu Wenruo wrote:
> Commit 93dabf211d74daf6e3de642bdd887a90a00f7b49
> Author: Mark Fasheh <mfasheh@suse.de>
> Date:   Fri Jun 17 13:37:48 2016 -0700
> 
>     btrfs-progs: check: verify qgroups above level 0
> 
> This commit introduced a new regression which corrupts
> read_qgroup_status, since it iterate leaf with manually specified slot,
> not correct path->slot[0].
> 
> This leads to wrong slot[0] and read_qgroup_status() will read out wrong
> flags, leading to regression.
> 
> Fix read_qgroup_status() by using eb and slot instread of wrong path
> strucutre.
> 
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Cc: Mark Fasheh <mfasheh@suse.de>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

I'm adding this patch to devel.  Do you have a test for the regression please?
