Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46108 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755273AbeEHRdW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 13:33:22 -0400
Date: Tue, 8 May 2018 19:30:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs-progs: qgroup: swap the argument in the
 caller of update_qgroup_relation
Message-ID: <20180508173043.GM6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180508054803.20851-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180508054803.20851-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 08, 2018 at 01:48:02PM +0800, Lu Fengqi wrote:
> The QGROUP_RELATION item is very special, it always exists in pairs
> (objectid and offset exchange). Its objectid and offset are the ids of a
> pair of parent and child qgroups, respectively. The larger one is
> parent and the smaller one is child. After the following commit, the order
> of the parameters is wrong and causes qgroup show to output the wrong
> qgroup parent-child relationship.
> 
> Fixes: aaf2dac5ef37 ("btrfs-progs: qgroup: split update_qgroup to reduce arguments")
> Issue: #129
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
> V2: Rename variables instead of the comment to make it clear.

Applied, thanks.
