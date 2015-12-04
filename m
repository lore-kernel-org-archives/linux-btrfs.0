Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4686 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751136AbbLDAsP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Dec 2015 19:48:15 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Laurent Bonnaud <L.Bonnaud@laposte.net>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <56455073.1060406@cn.fujitsu.com> <564F48FE.4000400@laposte.net>
 <1448047478.6878.4.camel@scientia.net> <564FBF0F.4050705@gmx.com>
 <564FC3FE.9020905@lukas-pirl.de> <565122AA.90904@gmx.com>
 <56519644.8060105@laposte.net> <56526543.4090301@cn.fujitsu.com>
 <565462F7.8040601@laposte.net> <5654F6BC.8020900@gmx.com>
 <565579DB.2040105@laposte.net> <56607848.5040705@laposte.net>
CC: Lukas Pirl <btrfs@lukas-pirl.de>, <linux-btrfs@vger.kernel.org>,
        <calestyo@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5660E2BD.3050000@cn.fujitsu.com>
Date: Fri, 4 Dec 2015 08:47:57 +0800
MIME-Version: 1.0
In-Reply-To: <56607848.5040705@laposte.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Laurent Bonnaud wrote on 2015/12/03 18:13 +0100:
> On 25/11/2015 10:05, Laurent Bonnaud wrote:
>
>>>> Nice reproducer.
>>>> Is it 100% reproducible or has a chance to reproduce?
>> I tried a second time and got a similar kernel backtrace.
>
> Hi,
>
> any news since you downloaded my FS image ?
>
> I kept my corrupted FS in case you wanted more info, but since I use this disk as a backup, it deprives me from one backup.  So would you mind if I replace my corrupted FS with a new one ?
>
> Thanks for investigating this bug,
>

The chunk mismatch problem should be resolved already, as the patch is 
merged in david's devel branch.

But for the kernel abort transaction, I'm sorry there is no good clue yet.
Only generic advice like update kernel to recent rc, as it has some new 
fixes which may help your case.
And run btrfsck --init-extent-tree with latest btrfs-progs and hope some 
miracle will happen...

Thanks,
QU


