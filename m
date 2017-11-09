Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56384 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752943AbdKIQxl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Nov 2017 11:53:41 -0500
Date: Thu, 9 Nov 2017 17:51:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 3/3] btrfs-progs: qgroup: cleanup __qgroup_search, no
 functional change
Message-ID: <20171109165148.GO27557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171031091345.9325-1-lufq.fnst@cn.fujitsu.com>
 <20171031091345.9325-4-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171031091345.9325-4-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 31, 2017 at 05:13:45PM +0800, Lu Fengqi wrote:
> 1. Use goto instead of while (1) to reduce the level of indentation

I'd rather avoid this goto pattern in new code, using while is ok. If
the indentation depth becomes problem, then the inner code should be
moved to a helper.

> 2. Replace the if statement with the switch statement

This is good.

> 3. move the BTRFS_IOC_TREE_SEARCH ioctl error handler to __qgroup_search

This one as well, but please make them into separate patches, the code
is being moved and changed at the same time. This makes the review
harder.
