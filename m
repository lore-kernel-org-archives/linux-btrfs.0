Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55838 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1424157AbcBRBhr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Feb 2016 20:37:47 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Dan Carpenter'" <dan.carpenter@oracle.com>
CC: <linux-btrfs@vger.kernel.org>, "'David Sterba'" <dsterba@suse.cz>
References: <20160217190152.GA10246@mwanda>
In-Reply-To: <20160217190152.GA10246@mwanda>
Subject: RE: btrfs: reada: simplify dev->reada_in_flight processing
Date: Thu, 18 Feb 2016 09:37:41 +0800
Message-ID: <007601d169ec$f5d23f10$e176bd30$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Dan Carpenter

> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Thursday, February 18, 2016 3:02 AM
> To: zhaolei@cn.fujitsu.com
> Cc: linux-btrfs@vger.kernel.org
> Subject: re: btrfs: reada: simplify dev->reada_in_flight processing
> 
> Hello Zhao Lei,
> 
> The patch 7aff519c04d2: "btrfs: reada: simplify dev->reada_in_flight
> processing" from Jan 12, 2016, leads to the following static checker
> warning:
> 
> 	fs/btrfs/reada.c:697 reada_start_machine_dev()
> 	warn: inconsistent indenting
> 
> fs/btrfs/reada.c
>    688                  spin_unlock(&fs_info->reada_lock);
>    689                  return 0;
>    690          }
>    691          dev->reada_next = re->logical +
> fs_info->tree_root->nodesize;
>    692          re->refcnt++;
>    693
>    694          spin_unlock(&fs_info->reada_lock);
>    695
>    696          spin_lock(&re->lock);
>    697                  if (re->scheduled || list_empty(&re->extctl)) {
> 
> This is indented too much.
> 
Thanks for report.

This problem is introduced in patch titled:
btrfs: reada: Move is_need_to_readahead contition earlier

I'll fix it.

CC: David Sterba <dsterba@suse.cz>
I'll fix this indent problem in following branch:
https://github.com/zhaoleidd/btrfs.git integration-4.5

Could you pick them again?

Thanks
Zhaolei

>    698                          spin_unlock(&re->lock);
>    699                          reada_extent_put(fs_info, re);
>    700                          return 0;
>    701                  }
>    702                  re->scheduled = 1;
>    703          spin_unlock(&re->lock);
>    704
> 
> regards,
> dan carpenter




