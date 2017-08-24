Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:46271 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbdHXFOp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 01:14:45 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 6F4F7AC00A1
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 14:14:41 +0900 (JST)
Received: from g01jpexchkw35.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 8A2DC328807
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 14:14:40 +0900 (JST)
Subject: Re: [PATCH 1/3] btrfs-progs: fix option handling for some commands
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
References: <c24c91e1-1e0e-c398-bf84-59fecb76637e@jp.fujitsu.com>
Message-ID: <6b3563a4-4e6f-dcbf-c751-64afb950fbe9@jp.fujitsu.com>
Date: Thu, 24 Aug 2017 14:14:36 +0900
MIME-Version: 1.0
In-Reply-To: <c24c91e1-1e0e-c398-bf84-59fecb76637e@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, this patch's encoding is wrong.
Please ignore this and I will resend the patch.

On 2017/08/24 13:03, Misono, Tomohiro wrote:
> I found some btrfs commands options are not working because of 
> inappropriate getopt_long() setting.
> 
> This fixes "btrfs check -Q/-E"
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>   cmds-check.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index c5faa2b..465fd17 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -12745,7 +12745,7 @@ int cmd_check(int argc, char **argv)
>                          { NULL, 0, NULL, 0}
>                  };
> 
> -               c = getopt_long(argc, argv, "as:br:p", long_options, NULL);
> +               c = getopt_long(argc, argv, "as:br:pQE:", long_options, 
> NULL);
>                  if (c < 0)
>                          break;
>                  switch(c) {

