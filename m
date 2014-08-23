Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:51982 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaHWSpX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Aug 2014 14:45:23 -0400
Received: by mail-la0-f43.google.com with SMTP id gi9so8784952lab.30
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Aug 2014 11:45:22 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <87mway82qp.fsf@elisp.net>
References: <87mway82qp.fsf@elisp.net>
Date: Sat, 23 Aug 2014 19:45:22 +0100
Message-ID: <CAL3q7H61-uAP08uXNzsZfwKT8h1ZjRAR_GvD69wRKuRPpkbh9A@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: Do not free dirty extent buffer
From: Filipe David Manana <fdmanana@gmail.com>
To: Naohiro Aota <naota@elisp.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 21, 2014 at 1:07 PM, Naohiro Aota <naota@elisp.net> wrote:
> free_some_buffer() should not free dirty extent buffers. They should be
> left for later commit.
>
> Signed-off-by: Naohiro Aota <naota@elisp.net>
> ---
>  extent_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/extent_io.c b/extent_io.c
> index a127e54..8a668be 100644
> --- a/extent_io.c
> +++ b/extent_io.c
> @@ -552,7 +552,7 @@ static int free_some_buffers(struct extent_io_tree *tree)
>
>         list_for_each_safe(node, next, &tree->lru) {
>                 eb = list_entry(node, struct extent_buffer, lru);
> -               if (eb->refs == 1) {
> +               if (eb->refs == 1 && !(eb->flags && EXTENT_DIRTY)) {

Hi,

Did you meant bitwise and (&) and not logical and (&&) right?


>                         free_extent_buffer(eb);
>                         if (tree->cache_size < cache_hard_max)
>                                 break;
> --
> 2.0.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
