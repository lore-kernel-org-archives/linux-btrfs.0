From: David Sterba <dave@jikos.cz>
Subject: Re: [RFC PATCH v2 1/3] Btrfs: add the Probabilistic Skiplist
Date: Wed, 11 Jan 2012 01:37:00 +0100
Message-ID: <20120111003700.GT7322@twin.jikos.cz>
References: <1326180696-3614-1-git-send-email-liubo2009@cn.fujitsu.com> <1326180696-3614-2-git-send-email-liubo2009@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	josef@redhat.com, dave@jikos.cz
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1326180696-3614-2-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, a few thoughts and comments below:

On Tue, Jan 10, 2012 at 03:31:34PM +0800, Liu Bo wrote:
> c) The level limit may need to be adjusted.
>    I know it is a magic number, but now for simplicity we just keep it at 16,
>    and then each skiplist is able to contain (2^32-1)/3 nodes at most.

(2^32-1)/3 = 1,431,655,765 that's a lot, I wonder what an average member
count of a skiplist would be and whether eg. maxlevel = 12 is not enough
(5,592,405 members).

or you can set the maxlevel during skiplist creation, or predefine a
"small" skiplist with compile-time-set level to whatever < 16.

this can be tuned later of course.

> --- /dev/null
> +++ b/fs/btrfs/skiplist.c
> @@ -0,0 +1,98 @@
> +inline int sl_fill_node(struct sl_node *node, int level, gfp_t mask)

I suggest to pick the full prefix "skiplist_" instead of just "sl_",
it'll be IMHO more readable and googlable. (Out of curiosity I grepped
for the sl_ prefix and it's used by drivers/net/slip/slip.c).

> +{
> +	struct sl_node **p;
> +	struct sl_node **q;
> +	int num;
> +
> +	BUG_ON(level > MAXLEVEL);
> +
> +	num = level + 1;
> +	p = kmalloc(sizeof(*p) * num, mask);
> +	BUG_ON(!p);

you can drop the BUG_ON

> +	if (!p)
        ^^^^^^^

> +		return -ENOMEM;
> +	q = kmalloc(sizeof(*q) * num, mask);
> +	BUG_ON(!q);
        ^^^^^^^^^^

> +	if (!q) {
> +		kfree(p);
> +		return -ENOMEM;
> +	}
> +
> +	node->next = p;
> +	node->prev = q;
> +	node->level = level;
> +	return 0;
> +}
> +
> diff --git a/fs/btrfs/skiplist.h b/fs/btrfs/skiplist.h
> new file mode 100644
> index 0000000..3e414b5
> --- /dev/null
> +++ b/fs/btrfs/skiplist.h
> +
> +#define MAXLEVEL 16
> +/* double p = 0.25; */
> +
> +struct sl_node {
> +	struct sl_node **next;
> +	struct sl_node **prev;
> +	unsigned int level;
> +	unsigned int head:1;

the bitfield will use another sizeof(int) bytes, but the level is at
most 16, you can reduce it's size eg to unsigned short.
on the other hand, the structure has to start at address aligned to
sizeof(void*) and the bytes after 'head' up to next sizeof(void*)
boundary will be left unusable anyway. then, 'head' could be a full int
or bool so the compiler is not restricted and forced to keep state of
the single bit. if access to these items is exptected to be frequent,
the diffenence could be mesurable.

> +};


david
