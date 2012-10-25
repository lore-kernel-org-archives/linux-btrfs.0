Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:46939 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935788Ab2JYQoU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 12:44:20 -0400
Date: Thu, 25 Oct 2012 18:43:50 +0200
From: David Sterba <dave@jikos.cz>
To: Rock Lee <zimilo@code-trick.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2][BTRFS-PROGS] [BUG] Fix Bug to corrupt the img file
 Reply-To: dave@jikos.cz
Message-ID: <20121025164350.GL10679@twin.jikos.cz>
References: <CAMRmmpLUsC=L=4sUf09Gx97W1hvc2FoOMmqOydiZQ6XwumUoYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMRmmpLUsC=L=4sUf09Gx97W1hvc2FoOMmqOydiZQ6XwumUoYQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 26, 2012 at 12:12:24AM +0800, Rock Lee wrote:
> Fix Bug to corrupt the img file
> 
> Reproduce steps:
>   > dd if=/dev/zero of=btrfs-small.img bs=1M count=1
>   > ls -lh btrfs-small.img
>   -rw-rw-r--. 1 rock rock 1.0M Oct 24 09:51 btrfs-small.img
>                                       ^^^
>   > mkfs.btrfs btrfs-small.img
>   -rw-rw-r--. 1 rock rock 2.0M Oct 24 09:53 btrfs-small.img
>                                       ^^^
> 
> Here you can see the original img file's size goes larger to 2Mb.

Thanks, fixes this particular bug; although it crashes later at

  mkfs.btrfs: volumes.c:796: btrfs_alloc_chunk: Assertion `!(ret)' failed

but this is a separate issue and you've sent patches for that IIRC.

> --- a/utils.c
> +++ b/utils.c
> @@ -557,6 +557,12 @@ int btrfs_prepare_device(int fd, char *file, int
> zero_end, u64 *block_count_ret,
>         }
>         if (max_block_count)
>                 block_count = min(block_count, max_block_count);
> +
> +       if (block_count < 2 * 1024 * 1024) {
> +               fprintf(stderr, "size of %s is too small(less than
> 2Mb)\n", file);

line wrapped, please check your mailer (easy to fix but additional
unnecessary work)

> +               exit(1);
> +       }
> +

Otherwise ack from me.

david
