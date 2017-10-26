Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36383 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932331AbdJZSGp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 14:06:45 -0400
Date: Thu, 26 Oct 2017 20:04:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: qgroup: fix qgroup show sort by multi items
Message-ID: <20171026180456.GE3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171026083251.13454-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171026083251.13454-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 26, 2017 at 04:32:51PM +0800, Lu Fengqi wrote:
> We should not free the string until we don't call strtok any longer.
> 
> If the string is freed in advance, in fact, the second and subsequent
> sort items will be ignored.
> 
> Fixes: 9fcdf8f8945b ("btrfs-progs: don't write to optarg in btrfs_qgroup_parse_sort_string")
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Huh, what an old bug, thanks for the fix.
