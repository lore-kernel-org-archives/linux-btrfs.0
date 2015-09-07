Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbbIGKfp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Sep 2015 06:35:45 -0400
Date: Mon, 7 Sep 2015 18:35:43 +0800
From: Eryu Guan <eguan@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] fstests: btrfs regression test for fsync after extent
 cloning
Message-ID: <20150907103543.GE18060@dhcp-13-216.nay.redhat.com>
References: <1439979128-14169-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439979128-14169-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 19, 2015 at 11:12:08AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that if we fsync a file that got one extent partially cloned into a
> lower file offset, after a power failure our file has the same content it
> had before the power failure and after the extent cloning operation.
> 
> This test is motivated by an issue found in btrfs that is fixed by the
> linux kernel patch titled:
> 
>   "Btrfs: fix file read corruption after extent cloning and fsync"
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Looks good to me.

Reviewed-by: Eryu Guan <eguan@redhat.com>
