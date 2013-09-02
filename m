Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62977 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab3IBBPJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 Sep 2013 21:15:09 -0400
Message-ID: <5223E621.8060604@cn.fujitsu.com>
Date: Mon, 02 Sep 2013 09:13:05 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs: separate out tests into their own directory V2
References: <5222db6d.y1rlQi1VIlwCf9La%wangshilong1991@gmail.com>
In-Reply-To: <5222db6d.y1rlQi1VIlwCf9La%wangshilong1991@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, please ignore this thread...

Thanks,
wang
On 09/01/2013 02:15 PM, Wang Shilong wrote:
> Hello, Using checkpatch.pl, i get the following warnings(errors):
> WARNING: kfree(NULL) is safe this check is probably not required
> #132: FILE: fs/btrfs/free-space-cache.c:3035:
> +	if (map)
> +		kfree(map);
>
> WARNING: line over 80 characters
> #882: FILE: fs/btrfs/tests/free-space-tests.c:211:
> +	ret = test_add_free_space_entry(cache, 4 * 1024 * 1024, 1 * 1024 * 1024, 1);
>
> WARNING: line over 80 characters
> #927: FILE: fs/btrfs/tests/free-space-tests.c:256:
> +	ret = test_add_free_space_entry(cache, 1 * 1024 * 1024, 4 * 1024 * 1024, 1);
>
> WARNING: line over 80 characters
> #947: FILE: fs/btrfs/tests/free-space-tests.c:276:
> +	ret = test_add_free_space_entry(cache, 4 * 1024 * 1024, 4 * 1024 * 1024, 1);
>
> WARNING: line over 80 characters
> #953: FILE: fs/btrfs/tests/free-space-tests.c:282:
> +	ret = test_add_free_space_entry(cache, 2 * 1024 * 1024, 2 * 1024 * 1024, 0);
>
> WARNING: line over 80 characters
> #1016: FILE: fs/btrfs/tests/free-space-tests.c:345:
> +	ret = test_add_free_space_entry(cache, 1 * 1024 * 1024, 2 * 1024 * 1024, 1);
>
> WARNING: line over 80 characters
> #1022: FILE: fs/btrfs/tests/free-space-tests.c:351:
> +	ret = test_add_free_space_entry(cache, 3 * 1024 * 1024, 1 * 1024 * 1024, 0);
>
> WARNING: line over 80 characters
> #1030: FILE: fs/btrfs/tests/free-space-tests.c:359:
> +		test_msg("Error removing bitmap and extent overlapping %d\n", ret);
>
> total: 0 errors, 8 warnings, 997 lines checked
>
> patch has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
>
> Thanks, Wang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

