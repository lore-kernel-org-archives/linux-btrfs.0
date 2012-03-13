From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH] Btrfs: convert refs and pages_reading to ints
Date: Tue, 13 Mar 2012 10:51:04 +0100
Message-ID: <4F5F1888.7060901@jan-o-sch.net>
References: <1331309197-5389-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1331309197-5389-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

On 09.03.2012 17:06, Josef Bacik wrote:
> I need to be able to safely deal with refs in my next patch, so convert refs and

Did I miss your next patch?

> pages_reading to ints and introduce an eb_lock spinlock so I can use this to
> safely manipulate the refs count when marking eb's as stale.  Thanks,

I don't see what makes this version safer, are you synchronizing
eb->refs with eb->pages_reading? This would be strange, because
eb->pages_reading sounds like it could never be != 0 when eb->refs goes
down to 0. Could you extend your description a bit, please?

> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index f030a2d..d11e872 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -128,8 +128,9 @@ struct extent_buffer {
>  	unsigned long map_len;
>  	unsigned long bflags;
>  	struct extent_io_tree *tree;
> -	atomic_t refs;
> -	atomic_t pages_reading;
> +	spinlock_t eb_lock;

If you need that one, then please use another name for this. We already
have the extent buffer's rwlock, it'll only be a matter of time until
somebody (me) confuses eb->lock and eb->eb_lock. I'd like something
representing its purpose (which I didn't catch yet). eb->refs_lock or
eb->pages_lock might be appropriate.

> +	int refs;
> +	int pages_reading;
>  	struct list_head leak_list;
>  	struct rcu_head rcu_head;
>  	pid_t lock_owner;

Thanks,
-Jan
