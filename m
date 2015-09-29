Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24288 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755109AbbI2BwD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 21:52:03 -0400
Subject: Re: [PATCH] btrfs: remove empty header file extent-tree.h
To: <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>
References: <1435886274-8309-1-git-send-email-quwenruo@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5609EEBF.2010804@cn.fujitsu.com>
Date: Tue, 29 Sep 2015 09:51:59 +0800
MIME-Version: 1.0
In-Reply-To: <1435886274-8309-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Would you please merge this patch?

The empty header is introduced by my qgroup accounting rework, and the 
cleanup patch is missed in 4.2.

Thanks,
Qu

Qu Wenruo wrote on 2015/07/03 09:17 +0800:
> The empty file is introduced as an careless 'git add', remove it.
>
> Reported-by: David Sterba <dsterba@suse.cz>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   fs/btrfs/extent-tree.h | 0
>   1 file changed, 0 insertions(+), 0 deletions(-)
>   delete mode 100644 fs/btrfs/extent-tree.h
>
> diff --git a/fs/btrfs/extent-tree.h b/fs/btrfs/extent-tree.h
> deleted file mode 100644
> index e69de29..0000000
>
