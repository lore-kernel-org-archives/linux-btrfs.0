Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26679 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751091AbbGOAkt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 20:40:49 -0400
Subject: Re: [PATCH] Revert "btrfs-progs: mkfs: create only desired block
 groups for single device"
To: <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1436839981-20432-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150714114511.GG15535@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55A5AC0C.8080602@cn.fujitsu.com>
Date: Wed, 15 Jul 2015 08:40:44 +0800
MIME-Version: 1.0
In-Reply-To: <20150714114511.GG15535@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/07/14 13:45 +0200:
> On Tue, Jul 14, 2015 at 10:13:01AM +0800, Qu Wenruo wrote:
>> This reverts commit 5f8232e5c8f0b0de0ef426274911385b0e877392.
>
> Thanks.  The revert is justified for the severity of the problem, I'll
> release 4.1.2 asap.
>
>> This commit causes a regression:
>> ---
>
> BTW, do not use --- in the changelog as 'git am' will ignore the text
> between that and the diff.
>
Oh, sorry I forgot that "---" will be ignored by git.
Next time I'll use "===" to avoid such careless problem.

BTW, for the mkfs test case, it will be delayed for a while as the 
following bugs are making things quite tricky.

1) fsck ignore chunk errors and return 0.
Cause is known and easy to fix, but if fixed, most of fsck test won't pass.
As the following bug is causing problem.

2) btrfs-image restore bug, causing missing dev_extent for DUP chunk.
Investigating. that's the reason causing a lot of dev extent missing in 
mkfs test.
And thanks to the previous bug, we can pass fsck test like a miracle.

So I'm afraid the corresponding regression test case won't be in time 
with 4.1.2 hotfix release.

Thanks,
Qu
