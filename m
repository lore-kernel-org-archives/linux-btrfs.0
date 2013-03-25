Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52423 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141Ab3CYEls (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Mar 2013 00:41:48 -0400
Received: by mail-pd0-f181.google.com with SMTP id q10so2328581pdj.26
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Mar 2013 21:41:47 -0700 (PDT)
Message-ID: <514FD3FA.701@gmail.com>
Date: Mon, 25 Mar 2013 12:35:06 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: Dave Chinner <dchinner@redhat.com>, xfstests <xfs@oss.sgi.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests 276: use _require_no_large_scratch_dev instead
 of the removed _require_nobigloopfs
References: <514AA503.4060101@gmail.com>
In-Reply-To: <514AA503.4060101@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013年03月21日 14:13, Wang Sheng-Hui wrote:
> _require_nobigloopfs has been removed.
> We should use _require_no_large_scratch_dev in the test script.
>
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>   276 |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/276 b/276
> index 40b30cf..87363ca 100755
> --- a/276
> +++ b/276
> @@ -58,8 +58,7 @@ _need_to_be_root
>   _supported_fs btrfs
>   _supported_os Linux
>   _require_scratch
> -
> -_require_nobigloopfs
> +_require_no_large_scratch_dev
>   _require_btrfs inspect-internal
>   _require_command "/usr/sbin/filefrag"
>

Does anyone notice this?
I use the upstream xfstests and failed this case for the already-removed function.
I think someone patched in but mixed the old function.
I've send out this patch for days, but seems no one cares about it.

If I'm wrong, please let me know.

Thanks,


