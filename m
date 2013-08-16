Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647Ab3HPRzc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 13:55:32 -0400
Message-ID: <520E678F.3010307@redhat.com>
Date: Fri, 16 Aug 2013 12:55:27 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: btrfs/009 never shrinked or removed $seqres.full
References: <1376675094-21522-1-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1376675094-21522-1-git-send-email-sbehrens@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/16/13 12:44 PM, Stefan Behrens wrote:
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/btrfs/009 | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tests/btrfs/009 b/tests/btrfs/009
> index d46744c..08aa508 100755
> --- a/tests/btrfs/009
> +++ b/tests/btrfs/009
> @@ -47,6 +47,8 @@ _supported_fs btrfs
>  _supported_os Linux
>  _require_scratch
>  
> +rm -f $seqres.full
> +
>  _scratch_mkfs > /dev/null 2>&1
>  _scratch_mount
>  
> 

