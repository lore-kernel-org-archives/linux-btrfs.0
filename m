Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m53-178.qiye.163.com ([123.58.178.53]:38350 "EHLO
	m53-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2LTOq6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Dec 2012 09:46:58 -0500
Received: from mail-la0-f44.google.com (mail-la0-f44.google.com [209.85.215.44])
	by m53-178.qiye.163.com (HMail) with ESMTPA id 049C3122810D
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Dec 2012 22:46:54 +0800 (CST)
Received: by mail-la0-f44.google.com with SMTP id d3so3143714lah.3
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Dec 2012 06:46:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMRmmp+gqw11a32GV=X1VGKvJWGRO0PXk-13fMyEmWyKgCkngg@mail.gmail.com>
References: <CAMRmmp+=YT_-KdGHRWo5GrofiSnkZB_xVpN1Z8Jp4xgo0fVS3A@mail.gmail.com>
 <20121219152925.GC4033@localhost.localdomain> <CAMRmmp+gqw11a32GV=X1VGKvJWGRO0PXk-13fMyEmWyKgCkngg@mail.gmail.com>
From: Rock Lee <zimilo@code-trick.com>
Date: Thu, 20 Dec 2012 22:46:12 +0800
Message-ID: <CAMRmmpKMxjjRShPY=VTJ+29eVY_hu-PTVAFsmhKpx1wRBi0akQ@mail.gmail.com>
Subject: Re: HIT WARN_ON WARNING: at fs/btrfs/extent-tree.c:6339
 btrfs_alloc_free_block+0x126/0x330 [btrfs]()
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is there anyone who are tracking this issue?

2012/12/19 Rock Lee <zimilo@code-trick.com>:
> Hi,
>
>  I just try to write the testcase a few hours before. So there will be
> some problems.
>
>  Maybe you can ignore the unimplemented and the ugly parts.
>
>  Welcome any feedback. :)
>
>  I have uploaded the test source file to Github. Please open this link:
>
>     https://github.com/Zimilo/btrfs-testing-suites/blob/master/fallocate/fallocate.c
>
>  Latest kernel commit is 752451f01c4567b506bf4343082682dbb8fb30dd in
> linus git tree.
>
>  Testing on a 20GB loop device.
>
>  When running the second case, try to do the sync command manually at
> the some time several times. Always could be reproduced.
>
>  You will get hit the WARN_ON, dmesg will report them.
>
>
>  Except this problem, there's another bug,   btrfs_fallocate doesn't
> guarantee subsequent write to that range not to fail because of disk
> space.
>
>
>
> 2012/12/19 Josef Bacik <jbacik@fusionio.com>:
>> On Wed, Dec 19, 2012 at 08:12:01AM -0700, Rock Lee wrote:
>>> Hi all,
>>>
>>>     Did someone have met this problem before. When doing the tests, I hit
>>>
>>> the WARN_ON. Is this log make sense or someone had fixed the problem.
>>>
>>>  If needed, I can supply the detail log and the testcase source file.
>>>
>>>  Version: the latest codes at linus git tree.
>>>
>>
>> If you can give me your testcase I will love you forever.  Thanks,
>>
>> Josef

