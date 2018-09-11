Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47720 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726670AbeIKUn7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 16:43:59 -0400
Date: Tue, 11 Sep 2018 17:44:04 +0200
From: David Sterba <dsterba@suse.cz>
To: zhong jiang <zhongjiang@huawei.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, lufq.fnst@cn.fujitsu.com,
        suy.fnst@cn.fujitsu.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] btrfs/extent_map: Remove unneeded variable "ret"
Message-ID: <20180911154404.GD2154@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1533474287-15049-1-git-send-email-zhongjiang@huawei.com>
 <5B7E9B1C.40404@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5B7E9B1C.40404@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 23, 2018 at 07:31:40PM +0800, zhong jiang wrote:
> Hi,  dsterba
> 
> Can you pick up the patch? Thanks

Please send one patch per changed function with relevant changelog that
the return value is not used and that no callees could potentially
return an error that would need to be passed.
