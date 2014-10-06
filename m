Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33395 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750991AbaJFENW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Oct 2014 00:13:22 -0400
Message-ID: <543216E3.9020702@cn.fujitsu.com>
Date: Mon, 6 Oct 2014 12:13:23 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs check segfaults after flipping 2 Bytes
References: <542C6443.1010809@niklasfi.de> <5431FEA1.20803@cn.fujitsu.com> <pan$37fbc$985496aa$c0a58ffc$edacda92@cox.net>
In-Reply-To: <pan$37fbc$985496aa$c0a58ffc$edacda92@cox.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: btrfs check segfaults after flipping 2 Bytes
From: Duncan <1i5t5.duncan@cox.net>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年10月06日 12:10
> Qu Wenruo posted on Mon, 06 Oct 2014 10:29:53 +0800 as excerpted:
>
>> 2 problems here.
>>
>> [1] csum mismatch As already mentioned by Ducan and Brendan, the csum
>> does not match.
>>
>> What makes thing much worse, since small file's extent is inlined, the
>> data is stored in metadata tree blocks,
>> and the file system is almost empty so the inline extent lies in the
>> *root* leaf of fs_tree.
>> These two unfortunate facts makes the whole fs_tree corrupted(only one
>> leaf, and its cusm dismatch),
>> which cause btrfs-progs segfault.
> So I nailed it. =:^)
>
>> The good news is that, the bug in btrfs-progs is already fixed by Wang's
>> patch:
>> https://patchwork.kernel.org/patch/4254631/
>> So at least, btrfs-progs will not segfault anymore.
>>
>> [2] two occurences?
>> So you definitely changed something you should not touch... maybe
>> another tree root?
> 1) Single device btrfs, therefore...
> 2) DUP metadata by default.
Oh, I forgot this, default DUP for metadata...

Thanks
Qu.
>
> 3) Small file, therefore...
> 4) Inlined in (DUP) metadata, therefore...
>
> 5) Two occurrences, each a copy of the (metadata-inlined) file in its own
> instance of the (duped) metadata block.
>
> I nailed it again. =:^)
>
> But the connection between the mentioned tree root patch and this
> particular bug had escaped me, so that's useful new information to me
> too, resolving the problem that I spotted but had no clue whether it was
> even fixable.  Thanks.  =:^)
>

