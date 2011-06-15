From: "Jim Schutt" <jaschut@sandia.gov>
Subject: Re: [PATCH] Btrfs: set no_trans_join after trying to expand the
 transaction
Date: Wed, 15 Jun 2011 08:36:03 -0600
Message-ID: <4DF8C353.9090301@sandia.gov>
References: <1308083139-23734-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Cc: linux-btrfs@vger.kernel.org
To: "Josef Bacik" <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1308083139-23734-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>


Josef Bacik wrote:
> We can lockup if we try to allow new writers join the transaction and we have
> flushoncommit set or have a pending snapshot.  This is because we set
> no_trans_join and then loop around and try to wait for ordered extents again.
> The problem is the ordered endio stuff needs to join the transaction, which it
> can't do because no_trans_join is set.  So instead wait until after this loop to
> set no_trans_join and then make sure to wait for num_writers == 1 in case
> anybody got started in between us exiting the loop and setting no_trans_join.
> This could easily be reproduced by mounting -o flushoncommit and running xfstest
> 13.  It cannot be reproduced with this patch.  Thanks,

FWIW, this version of the patch works fine for me
as well.

-- Jim

> 
> Reported-by: Jim Schutt <jaschut@sandia.gov>
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/transaction.c |   14 +++++++++++---
>  1 files changed, 11 insertions(+), 3 deletions(-)
> 

