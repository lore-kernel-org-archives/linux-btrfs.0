From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH 3/3] btrfs: Update comment above ulist_next
Date: Fri, 04 May 2012 21:10:16 +0200
Message-ID: <4FA42998.6020700@gmx.net>
References: <1336157665-17328-1-git-send-email-ablock84@googlemail.com> <1336157665-17328-3-git-send-email-ablock84@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Alexander Block <ablock84@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1336157665-17328-3-git-send-email-ablock84@googlemail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/04/12 20:54, Alexander Block wrote:
> The comment above ulist_next stated that it's allowed to call ulist_add
> while enumerating. This is actually not allowed as an add may realocate
> the nodes buffer und thus make the prev pointer invalid.
>
> Signed-off-by: Alexander Block<ablock84@googlemail.com>

I'd much prefer to fix the problem in ulist_next, as being able to add
values while enumerating is a key feature of ulist. If it's unfixable,
it should be thrown out completely.

-Arne

> ---
>   fs/btrfs/ulist.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
> index 12f5147..07ea3e5 100644
> --- a/fs/btrfs/ulist.c
> +++ b/fs/btrfs/ulist.c
> @@ -198,8 +198,8 @@ EXPORT_SYMBOL(ulist_add);
>    * end is reached. No guarantee is made with respect to the order in which
>    * the elements are returned. They might neither be returned in order of
>    * addition nor in ascending order.
> - * It is allowed to call ulist_add during an enumeration. Newly added items
> - * are guaranteed to show up in the running enumeration.
> + * It is not allowed to call ulist_add during an enumeration as this would
> + * cause undefined behavior.
>    */
>   struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_node *prev)
>   {

