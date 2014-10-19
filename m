Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:54645 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaJSTet convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Oct 2014 15:34:49 -0400
MIME-Version: 1.0
Date: Sun, 19 Oct 2014 21:34:47 +0200
Message-ID: <CAMuHMdUnEZ35U3Qby1OFuFYnAysf9JhHxbDxcUMiFuMefy9idQ@mail.gmail.com>
Subject: btrfs extent_state.private compiler warning (Re: Btrfs: cleanup the
 read failure record after write or when the inode is freeing)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Miao Xie <miaox@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 11, 2014 at 2:08 PM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=f612496bca664bff6a09a99a9a7506410b6e876e
> Commit:     f612496bca664bff6a09a99a9a7506410b6e876e

>     Btrfs: cleanup the read failure record after write or when the inode is freeing
>
>     After the data is written successfully, we should cleanup the read failure record
>     in that range because
>     - If we set data COW for the file, the range that the failure record pointed to is
>       mapped to a new place, so it is invalid.
>     - If we set no data COW for the file, and if there is no error during writting,
>       the corrupted data is corrected, so the failure record can be removed. And if
>       some errors happen on the mirrors, we also needn't worry about it because the
>       failure record will be recreated if we read the same place again.
>
>     Sometimes, we may fail to correct the data, so the failure records will be left
>     in the tree, we need free them when we free the inode or the memory leak happens.

> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c

> +void btrfs_free_io_failure_record(struct inode *inode, u64 start, u64 end)
> +{
> +       struct extent_io_tree *failure_tree = &BTRFS_I(inode)->io_failure_tree;
> +       struct io_failure_record *failrec;
> +       struct extent_state *state, *next;

> +               failrec = (struct io_failure_record *)state->private;

On 32-bit:

fs/btrfs/extent_io.c: In function ‘btrfs_free_io_failure_record’:
fs/btrfs/extent_io.c:2166: warning: cast to pointer from integer of
different size

Is there any specific reason extend_state.private is "u64", and not
"unsigned long", or better "void *", or even better
"struct io_failure_record *"?

That would get rid of the (double) cast tricks.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
