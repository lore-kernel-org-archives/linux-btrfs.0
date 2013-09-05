Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:41794 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763202Ab3IEIVW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Sep 2013 04:21:22 -0400
Message-ID: <52283EFB.30808@giantdisaster.de>
Date: Thu, 05 Sep 2013 10:21:15 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: Ilya Dryomov <idryomov@gmail.com>,
        Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, sandeen@redhat.com
Subject: Re: [PATCH 18/20] Btrfs-progs: fix magic return value in cmds-balance.c
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com> <1378308157-4621-19-git-send-email-wangshilong1991@gmail.com> <CAOi1vP-m3drMT7Ljj7MZmHK+qOCfVfaSD4OYC3RQ8mobOUup8A@mail.gmail.com> <5228364B.2020904@cn.fujitsu.com>
In-Reply-To: <5228364B.2020904@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 05 Sep 2013 15:44:11 +0800, Wang Shilong wrote:
[..]
>>> @@ -297,9 +305,10 @@ static int do_balance(const char *path, struct
>>> btrfs_ioctl_balance_args *args,
>>>          DIR *dirstream = NULL;
>>>
>>>          fd = open_file_or_dir(path, &dirstream);
>>> +       e = errno;
>>>          if (fd < 0) {
>>>                  fprintf(stderr, "ERROR: can't access to '%s'\n", path);
>>> -               return 12;
>>> +               return e;

Since I didn't understand whether you rejected or acknowledged Ilya's
comments, if you don't do so, please change the above line to "return
-e" like it is everywhere else: errno is returned as a negative value, 0
means no error, a positive value means the function failed but the
return value cannot be interpreted as an errno.
