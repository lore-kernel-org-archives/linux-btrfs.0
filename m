Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:45856 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759924Ab2JYPhk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 11:37:40 -0400
Date: Thu, 25 Oct 2012 17:37:31 +0200
From: David Sterba <dave@jikos.cz>
To: Rock Lee <zimilo@code-trick.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [BUG][BTRFS-PROGS] Fix Bug to corrupt the img file
Message-ID: <20121025153731.GI10679@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAMRmmpL01PqR1nZPGhyDv1ECdWaBDrhVbx-9FH83x-3ez+M_pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMRmmpL01PqR1nZPGhyDv1ECdWaBDrhVbx-9FH83x-3ez+M_pQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 24, 2012 at 10:04:47AM +0800, Rock Lee wrote:
> @@ -572,7 +576,7 @@ int btrfs_prepare_device(int fd, char *file, int
> zero_end, u64 *block_count_ret,
>                 discard_blocks(fd, 0, block_count);
>         }
> 
> -       ret = zero_dev_start(fd);
> +       ret = zero_dev_start(fd, block_count);
>         if (ret) {
>                 fprintf(stderr, "failed to zero device start %d\n", ret);
>                 exit(1);

Please add a separate check for a minimal image size instead, right after

 553         block_count = device_size(fd, &st);
 554         if (block_count == 0) {
 555                 fprintf(stderr, "unable to find %s size\n", file);
 556                 exit(1);
 557         }
 558         if (max_block_count)
 559                 block_count = min(block_count, max_block_count);

	     if (block_count < 2 MB ) {
		     fprintf(stderr, "Image too small (less than 2MB)");
		     exit
	     }

thanks,
david
