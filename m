From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 4/4] mkfs: avoid heap-buffer-read-underrun for
 zero-length "size" arg
Date: Fri, 20 Apr 2012 14:41:28 -0400
Message-ID: <20120420184128.GD1957@localhost.localdomain>
References: <1334943408-6720-1-git-send-email-jim@meyering.net>
 <1334943408-6720-5-git-send-email-jim@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334943408-6720-5-git-send-email-jim@meyering.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 20, 2012 at 07:36:48PM +0200, Jim Meyering wrote:
> From: Jim Meyering <meyering@redhat.com>
> 
> * mkfs.c (parse_size): ./mkfs.btrfs -A '' would read and possibly
> write the byte before beginning of strdup'd heap buffer.  All other
> size-accepting options were similarly affected.
> ---
>  mkfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs.c b/mkfs.c
> index 03239fb..4aff2fd 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -63,7 +63,7 @@ static u64 parse_size(char *s)
> 
>  	s = strdup(s);
> 
> -	if (!isdigit(s[len - 1])) {
> +	if (len && !isdigit(s[len - 1])) {
>  		c = tolower(s[len - 1]);
>  		switch (c) {
>  		case 'g':

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
