Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58236 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728958AbeHVTKs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Aug 2018 15:10:48 -0400
Date: Wed, 22 Aug 2018 17:45:11 +0200
From: David Sterba <dsterba@suse.cz>
To: zhong jiang <zhongjiang@huawei.com>
Cc: dsterba@suse.com, jbacik@fb.com, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 1/3] btrfs: remove unneeded variable "ret" in
 btrfs_destroy_delayed_refs
Message-ID: <20180822154510.GJ24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1534437435-51605-1-git-send-email-zhongjiang@huawei.com>
 <1534437435-51605-2-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534437435-51605-2-git-send-email-zhongjiang@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 17, 2018 at 12:37:13AM +0800, zhong jiang wrote:
> btrfs_destroy_delayed_refs defines the variable "ret" for return value,
> but it is not modified after initialization. So it is safe to drop the
> unneeded value "ret".

No it's not, please read my previous reply again.
