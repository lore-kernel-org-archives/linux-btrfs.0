Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:53333 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753689Ab3ISW5c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Sep 2013 18:57:32 -0400
Message-ID: <523B8157.4050508@hurleysoftware.com>
Date: Thu, 19 Sep 2013 18:57:27 -0400
From: Peter Hurley <peter@hurleysoftware.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, walken@google.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] rwsem: add rwsem_is_contended V2
References: <1379605688-987-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1379605688-987-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/19/2013 11:48 AM, Josef Bacik wrote:
> Btrfs needs a simple way to know if it needs to let go of it's read lock on a
> rwsem.  Introduce rwsem_is_contended to check to see if there are any waiters on
> this rwsem currently.  This is just a hueristic, it is meant to be light and not
> 100% accurate and called by somebody already holding on to the rwsem in either
> read or write.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
> V1->V2: took everybodys suggestions and simplified it to just one function in
> rwsem.h so it works for both the spinlock case and non-spinlock case.
>
>   include/linux/rwsem.h | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
>
> diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
> index 0616ffe..c340493 100644
> --- a/include/linux/rwsem.h
> +++ b/include/linux/rwsem.h
> @@ -75,6 +75,19 @@ do {								\
>   } while (0)
>
>   /*
> + * This is the same regardless of which rwsem implementation that is being used.
> + * It is just a heuristic meant to be called by somebody alreadying holding the
> + * rwsem to see if somebody from  the opposite type is wanting access to the
                                         ^^^^^^^^^^^^^

Readers can infer that at least one writer is waiting if the wait_list is
!empty; however, writers cannot infer anything other than some other
thread is waiting -- it could be a reader or a writer or multiples of either.


> + * lock.
> + */
> +static inline int rwsem_is_contended(struct rw_semaphore *sem)
> +{
> +	if (!list_empty(&sem->wait_list))
> +		return 1;
> +	return 0;

How about

         return !list_empty(&sem->wait_list);

?

> +}
> +
> +/*
>    * lock for reading
>    */
>   extern void down_read(struct rw_semaphore *sem);
>

