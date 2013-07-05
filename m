Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:46783 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3GEWiD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jul 2013 18:38:03 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20130705204129.GB15943@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
	<20130705204100.GA15943@logfs.org>
	<20130705204129.GB15943@logfs.org>
Date: Fri, 5 Jul 2013 23:38:01 +0100
Message-ID: <CAL3q7H75aO8YvJLppif88P=CumfA8WjHUTfwEcZSvL+MUu8tJw@mail.gmail.com>
Subject: Re: [PATCH 1/2] list: add list_del_each_entry
From: Filipe David Manana <fdmanana@gmail.com>
To: =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 5, 2013 at 9:41 PM, Jörn Engel <joern@logfs.org> wrote:
> I have seen a lot of boilerplate code that either follows the pattern of
>         while (!list_empty(head)) {
>                 pos = list_entry(head->next, struct foo, list);
>                 list_del(pos->list);
>                 ...
>         }
> or some variant thereof.
>
> With this patch in, people can use
>         list_del_each_entry(pos, head, list) {
>                 ...
>         }
>
> The patch also adds a list_del_each variant, even though I have
> only found a single user for that one so far.
>
> Signed-off-by: Joern Engel <joern@logfs.org>
> ---
>  include/linux/list.h |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/include/linux/list.h b/include/linux/list.h
> index 6a1f8df..ab39c7d 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -557,6 +557,24 @@ static inline void list_splice_tail_init(struct list_head *list,
>  #define list_safe_reset_next(pos, n, member)                           \
>         n = list_entry(pos->member.next, typeof(*pos), member)
>
> +/**
> + * list_del_each - removes an entry from the list until it is empty
> + * @pos:       the &struct list_head to use as a loop cursor.
> + * @head:      the head of your list.
> + */
> +#define list_del_each(pos, head) \
> +       while (list_empty(head) ? 0 : (pos = (head)->next, list_del(pos), 1))
> +
> +/**
> + * list_del_each_entry - removes an entry from the list until it is empty
> + * @pos:       the type * to use as loop cursor.
> + * @head:      the head of your list.
> + * @member:    the name of the list_struct within the struct
> + */
> +#define list_del_each_entry(pos, head, member) \
> +       while (list_empty(head) && (pos = list_first_entry((head), \
> +               typeof(*pos), member), list_del((head)->next), 1))
> +

Shouldn't it be while (!list_empty(head) ... ?
(not operator addition)

thanks

>  /*
>   * Double linked lists with a single pointer list head.
>   * Mostly useful for hash tables where the two pointer list head is
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
