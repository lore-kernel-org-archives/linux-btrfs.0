Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47913 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3FNPcN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Jun 2013 11:32:13 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 51BA99A03E9
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Jun 2013 09:32:13 -0600 (MDT)
Date: Fri, 14 Jun 2013 11:32:11 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix the comment typo for
 btrfs_attach_transaction_barrier
Message-ID: <20130614153211.GB28783@localhost.localdomain>
References: <CAKXJSOEhk5tYpJd3L4r9zNsEFHRihz+tZXv4hZ5gAmDF_1G9cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAKXJSOEhk5tYpJd3L4r9zNsEFHRihz+tZXv4hZ5gAmDF_1G9cQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 14, 2013 at 02:21:24AM -0600, Wang Sheng-Hui wrote:
> The comment is for btrfs_attach_transaction_barrier, not for
> btrfs_attach_transaction. Fix the typo.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  fs/btrfs/transaction.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 0544587..6d4c595 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -490,7 +490,7 @@ struct btrfs_trans_handle
> *btrfs_attach_transaction(struct btrfs_root *root)
>  }

Word wrapped, please be careful about this sort of thing in the future, use git
send-email for example.  Thanks,

Josef
