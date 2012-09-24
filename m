Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57388 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab2IXNkB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 09:40:01 -0400
Received: by qcro28 with SMTP id o28so4298363qcr.19
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Sep 2012 06:40:00 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 24 Sep 2012 21:40:00 +0800
Message-ID: <CAPgLHd8z-dQPB=vGe2wH+5mw0sUkr4-RrihtWx2bnzTc5y3Vjw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix return value check in btrfs_ioctl_send()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: chris.mason@fusionio.com, yongjun_wei@trendmicro.com.cn,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/24/2012 08:42 PM, David Sterba wrote:
> On Fri, Sep 21, 2012 at 12:42:02PM +0800, Wei Yongjun wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> In case of error, the function btrfs_read_fs_root_no_name() returns
>> ERR_PTR() and never returns NULL pointer. The NULL test in the return
>> value check should be replaced with IS_ERR(), and remove useless
>> NULL test.
> Good catch.  Also please update the other remaining case in
> disk-io.c:open_ctree()
>
> 2587         fs_info->fs_root = btrfs_read_fs_root_no_name(fs_info, &location);
> 2588         if (!fs_info->fs_root)
> 2589                 goto fail_qgroup;
> 2590         if (IS_ERR(fs_info->fs_root)) {
> 2591                 err = PTR_ERR(fs_info->fs_root);
> 2592                 goto fail_qgroup;
> 2593         }
>
>

will do in the patch v2.

>> dpatch engine is used to auto generated this patch.
>> (https://github.com/weiyj/dpatch)
> I've played with it, looks nice, although it's full of hardcoded paths.

Yes, it is current hardcoded path, because I used the linux.git and
linux-next.git, and dpatch will update the git tree every day.

After login, you can change the git url in the web.

> I'd like to run it directly from the git repo. Can you please fix that?
> No patch from me, because I hadcoded my paths :)

Do you mean does not need auto update git repo, only scan the
change under your git repo?

>
> It would be great if we can run a set of .cocci scripts that would
> verify code invariants (limited to cocci capabilities, but eg. the
> IS_ERR is a good example) and add new ones eventually over time.

By default, It does not include cocci scripts, only include dup include,
useless 'linux/version.h' check engine, and is disabled.

I am now testing some cocci scripts, and will add them to the github,
so, everyone can import those cocci scripts to dpatch, also they can
add the cocci scripts create by themself.
^_^

Thanks very much for you advise.

Regards,
Yongjun Wei



