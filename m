Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49525 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaAFIXp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jan 2014 03:23:45 -0500
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id D8C703EE0BB
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Jan 2014 17:23:43 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id CD1DB45DE52
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Jan 2014 17:23:43 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id B0A4145DD77
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Jan 2014 17:23:43 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id A3F7D1DB803F
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Jan 2014 17:23:43 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 586981DB8032
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Jan 2014 17:23:43 +0900 (JST)
Message-ID: <52CA67F2.9010108@jp.fujitsu.com>
Date: Mon, 06 Jan 2014 17:23:14 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] xfstests: fix wrong return check for case 022
References: <1388995737-3480-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1388995737-3480-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/01/06 17:08, Wang Shilong wrote:
> Here we expect 0 as return value, fix it.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Cc: Josef Bacik <jbacik@fb.com>
> ---
>   tests/btrfs/022 | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>   mode change 100644 => 100755 tests/btrfs/022
> 
> diff --git a/tests/btrfs/022 b/tests/btrfs/022
> old mode 100644
> new mode 100755
> index 5b18643..142aaf9
> --- a/tests/btrfs/022
> +++ b/tests/btrfs/022
> @@ -106,7 +106,7 @@ _limit_test()
>   	[ $? -ne 0 ] || _fail "quota should have limited us"
>   	dd if=/dev/urandom of=$SCRATCH_MNT/a/file bs=4M count=1 >> \
>   		$seqres.full 2>&1
> -	[ $? -eq 0 ] || _fail "should have been allowed to write"
> +	[ $? -ne 0 ] || _fail "should have been allowed to write"

from "man bash",
       An OR list has the form
              command1 || command2
       command2 is executed if and only if command1 returns a non-zero exit
       status.

So, original code is OK, I think.

Thanks,
Tsutomu

>   }
>   
>   _scratch_mkfs > /dev/null 2>&1
> 


