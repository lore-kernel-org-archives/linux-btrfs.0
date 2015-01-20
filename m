Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62013 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751974AbbATAYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 19:24:22 -0500
Message-ID: <54BDA033.7020203@cn.fujitsu.com>
Date: Tue, 20 Jan 2015 08:24:19 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: tests, use non-interactive sudo helper
References: <1421691107-4106-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1421691107-4106-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: [PATCH] btrfs-progs: tests, use non-interactive sudo helper
From: David Sterba <dsterba@suse.cz>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年01月20日 02:11
> Sudo may not be configured to run without user prompt, in that case the
> tests would be stuck.
>
> Reported-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>   tests/common | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tests/common b/tests/common
> index 84a4b9d335e2..d7d2e9bef050 100644
> --- a/tests/common
> +++ b/tests/common
> @@ -58,7 +58,7 @@ export have_root_helper
>   setup_root_helper()
>   {
>   	if [ $UID != 0 ]; then
> -		sudo=sudo
> +		sudo="sudo --non-interactive"
>   	fi
>   	have_root_helper=1
>   }
Looks good for me.

This seems much better than the original interactive one.

Thanks,
Qu
