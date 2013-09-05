Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62976 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1763372Ab3IEIZc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Sep 2013 04:25:32 -0400
Message-ID: <52283F78.2040406@cn.fujitsu.com>
Date: Thu, 05 Sep 2013 16:23:20 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Ilya Dryomov <idryomov@gmail.com>,
        Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, sandeen@redhat.com
Subject: Re: [PATCH 18/20] Btrfs-progs: fix magic return value in cmds-balance.c
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com> <1378308157-4621-19-git-send-email-wangshilong1991@gmail.com> <CAOi1vP-m3drMT7Ljj7MZmHK+qOCfVfaSD4OYC3RQ8mobOUup8A@mail.gmail.com> <5228364B.2020904@cn.fujitsu.com> <52283EFB.30808@giantdisaster.de>
In-Reply-To: <52283EFB.30808@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/05/2013 04:21 PM, Stefan Behrens wrote:
> On Thu, 05 Sep 2013 15:44:11 +0800, Wang Shilong wrote:
> [..]
>>>> @@ -297,9 +305,10 @@ static int do_balance(const char *path, struct
>>>> btrfs_ioctl_balance_args *args,
>>>>           DIR *dirstream = NULL;
>>>>
>>>>           fd = open_file_or_dir(path, &dirstream);
>>>> +       e = errno;
>>>>           if (fd < 0) {
>>>>                   fprintf(stderr, "ERROR: can't access to '%s'\n", path);
>>>> -               return 12;
>>>> +               return e;
> Since I didn't understand whether you rejected or acknowledged Ilya's
My answer: acknowledged.

Will send a V2 later, just wait more comments.

Thanks,
Wang
> comments, if you don't do so, please change the above line to "return
> -e" like it is everywhere else: errno is returned as a negative value, 0
> means no error, a positive value means the function failed but the
> return value cannot be interpreted as an errno.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

