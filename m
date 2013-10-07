Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab3JGVpD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 17:45:03 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r97Lj2ku031248
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Oct 2013 17:45:02 -0400
Message-ID: <52532B5D.70302@redhat.com>
Date: Mon, 07 Oct 2013 16:45:01 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 09/12] btrfs-progs: don't deref pipefd[-1]
References: <1381182185-10896-1-git-send-email-zab@redhat.com> <1381182185-10896-10-git-send-email-zab@redhat.com>
In-Reply-To: <1381182185-10896-10-git-send-email-zab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/7/13 4:43 PM, Zach Brown wrote:
> commit 4782e8ebdb583dfa3615f7b38dee729d34f62ec1 accidentally replaced
> [0] with [-1].  Put it back.  This was found by static analysis.
> 
> Signed-off-by: Zach Brown <zab@redhat.com>

eeehhhyeah.  Thanks for being charitable. ;)

Really, I have no idea how that happened.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  send-test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/send-test.c b/send-test.c
> index 3775f5f..a37b7fd 100644
> --- a/send-test.c
> +++ b/send-test.c
> @@ -354,7 +354,7 @@ static void *process_thread(void *arg_)
>  	int ret;
>  
>  	while (1) {
> -		ret = btrfs_read_and_process_send_stream(pipefd[-1],
> +		ret = btrfs_read_and_process_send_stream(pipefd[0],
>  							 &send_ops_print, arg_, 0);
>  		if (ret)
>  			break;
> 

