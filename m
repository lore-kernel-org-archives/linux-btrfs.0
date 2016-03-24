Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199AbcCXLNe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 07:13:34 -0400
Date: Thu, 24 Mar 2016 19:13:31 +0800
From: Eryu Guan <eguan@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstest: btrfs: update 048.out inline with ui changes
Message-ID: <20160324111331.GT11419@eguan.usersys.redhat.com>
References: <1458814272-5783-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458814272-5783-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 24, 2016 at 06:11:12PM +0800, Anand Jain wrote:
> To be inline with progs changes
>   28831d54895443e5fc795392f23ce3a8b122cb71
>   btrfs-progs: cmd property: switch to common error message wrapper
> update 048.out
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  tests/btrfs/048.out | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/btrfs/048.out b/tests/btrfs/048.out
> index 0b20d0b5976c..1d3ccef8e870 100644
> --- a/tests/btrfs/048.out
> +++ b/tests/btrfs/048.out
> @@ -9,7 +9,7 @@ label=foobar
>  ***
>  label=
>  ***
> -ERROR: object is not compatible with property
> +ERROR: object is not compatible with property: label

This fails test with old btrfs-progs. I think a filter can be added to
btrfs/048 to filter out the ": label" part, so that test passes with
both old and new btrfs-progs.

Thanks,
Eryu
