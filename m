Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37498 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732639AbeHGRj5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 13:39:57 -0400
Date: Tue, 7 Aug 2018 17:25:00 +0200
From: David Sterba <dsterba@suse.cz>
To: zhong jiang <zhongjiang@huawei.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fs/btrfs: remove the unneeded variable "err" and
 change the function to be void function
Message-ID: <20180807152500.GJ3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1533523978-50321-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1533523978-50321-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 06, 2018 at 10:52:58AM +0800, zhong jiang wrote:
> The err is not modified after initalization, So just remove it and make
> the function to be void function.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
> v1->v2:
>  - Merge v1 series into a patch to void same changelog.

Please do one patch per function. If the change follows the same logic,
it's not a problem to use the same changelog, but the patch should be
revieweable and not doing unrelated things.

If the function prototype or return values is changed it's easier from
the reviewer's perspective to focus on just one function and the
surrounding code. Even if it looks straightforward to you to merge them
together.

When the return value changes from int -> void, it's necessary to check
wheter any of the callees is not hiding a BUG_ON that should be really
turned into proper error handling in the caller. In that case the return
type should stay and error handling added.

After a brief look I think all functions are safe here, but that's
something that should be mentioned in the changelog. Please update the
patches and resend. Thanks.
