Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58614 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729257AbeHVTMH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Aug 2018 15:12:07 -0400
Date: Wed, 22 Aug 2018 17:46:31 +0200
From: David Sterba <dsterba@suse.cz>
To: zhong jiang <zhongjiang@huawei.com>
Cc: dsterba@suse.com, jbacik@fb.com, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 0/3] btrfs: remove unneeded variable and if possbile
Message-ID: <20180822154631.GK24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1534437435-51605-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534437435-51605-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 17, 2018 at 12:37:12AM +0800, zhong jiang wrote:
> v3->v4:
>  -  btrfs_destroy_delayed_refs return value would be actually needed.
>     so just remove the unneeded variable "ret" and modify the subject
> 
> v2->v3:
>  - repost the patches with detailed commit message.
> 
> v1->v2:
>  - Fix v1 issue that forget to return after remove the variable "ret".
> 
> zhong jiang (3):
>   btrfs: remove unneeded variable "ret" in btrfs_destroy_delayed_refs
>   btrfs: change btrfs_free_reserved_bytes to be void funtion
>   btrfs: change btrfs_pin_log_trans to be void function

Patches 2 and 3 applied, thanks, but the first one dropped.
