From: Danny Kukawka <danny.kukawka@bisect.de>
Subject: Re: [PATCH] btrfs/check-integrity.c: included disk-io.h twice
Date: Thu, 16 Feb 2012 16:28:35 +0100
Message-ID: <201202161628.35806.danny.kukawka@bisect.de>
References: <1329400529-31793-1-git-send-email-danny.kukawka@bisect.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1329400529-31793-1-git-send-email-danny.kukawka@bisect.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Ignore this one, it's already in linux-next.

Danny

On Donnerstag, 16. Februar 2012, Danny Kukawka wrote:
> fs/btrfs/check-integrity.c included disk-io.h twice, remove the
> duplicate.
>
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  fs/btrfs/check-integrity.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index b669a7d..064b29b 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -89,7 +89,6 @@
>  #include "disk-io.h"
>  #include "transaction.h"
>  #include "extent_io.h"
> -#include "disk-io.h"
>  #include "volumes.h"
>  #include "print-tree.h"
>  #include "locking.h"
