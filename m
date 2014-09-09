Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4613 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754679AbaIID7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Sep 2014 23:59:52 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s893N1Dh026323
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Sep 2014 11:23:23 +0800
Message-ID: <540E727D.3000806@cn.fujitsu.com>
Date: Tue, 9 Sep 2014 11:22:37 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: doc: fix invalid reference to setattr(8)
References: <540E613C.5010401@jp.fujitsu.com>
In-Reply-To: <540E613C.5010401@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: [PATCH] btrfs-progs: doc: fix invalid reference to setattr(8)
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
To: linux-btrfs@vger.kernel.org <linux-btrfs@vger.kernel.org>
Date: 2014年09月09日 10:09
> From: Naohiro Aota <naota@elisp.net>
>
> man 8 btrfs-property refers to `setattr(8)` which does not actually exist.
> It should refer to `chattr (1)` instead.
>
> Signed-off-by: Naohiro Aota <naota@elisp.net>
> ---
>   Documentation/btrfs-property.txt | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/btrfs-property.txt b/Documentation/btrfs-property.txt
> index 6b23e2e..9ed568c 100644
> --- a/Documentation/btrfs-property.txt
> +++ b/Documentation/btrfs-property.txt
> @@ -64,4 +64,4 @@ SEE ALSO
>   --------
>   `mkfs.btrfs`(8),
>   `lsattr`(1),
> -`setattr`(8)
> +`chattr`(1)
Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

My fault, it should be chattr, not setattr.

Thanks,
Qu
