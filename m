Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33147 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162888AbdKRHFY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Nov 2017 02:05:24 -0500
Date: Sat, 18 Nov 2017 08:05:19 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org,
        kernel-team@fb.com, daniel@iogearbox.net, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 2/4] btrfs: make open_ctree error injectable
Message-ID: <20171118070519.nkgh22van7ftsgom@gmail.com>
References: <1510941607-3997-1-git-send-email-josef@toxicpanda.com>
 <1510941607-3997-3-git-send-email-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1510941607-3997-3-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


* Josef Bacik <josef@toxicpanda.com> wrote:

> From: Josef Bacik <jbacik@fb.com>
> 
> This allows us to do error injection with BPF for open_ctree.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/disk-io.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index dfdab849037b..c6b4e1f07072 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -31,6 +31,7 @@
>  #include <linux/uuid.h>
>  #include <linux/semaphore.h>
>  #include <asm/unaligned.h>
> +#include <asm/kprobes.h>
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "hash.h"
> @@ -3283,6 +3284,7 @@ int open_ctree(struct super_block *sb,
>  		goto fail_block_groups;
>  	goto retry_root_backup;
>  }
> +BPF_ALLOW_ERROR_INJECTION(open_ctree);

Ok, this looks a lot better - except the random header inclusion dependency: if a 
facility is in the BPF_*() namespace then it should include <linux/bpf.h> and not 
a random asm/* header...

With that detail fixed:

  Acked-by: Ingo Molnar <mingo@kernel.org>

for the whole series.

Thanks,

	Ingo
