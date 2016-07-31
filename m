Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59810 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbcGaBsx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jul 2016 21:48:53 -0400
Subject: Re: btrfs: relocation: Fix leaking qgroups numbers on data extents
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <20160614092622.15560-1-quwenruo@cn.fujitsu.com>
 <20160729184235.GA3535@merlin.lan>
 <01f5daa5-779b-954b-0d8c-1f4bd54c10fe@gmx.com>
 <bbcce409-52ee-fcc8-daea-86a4c1221cf8@suse.de>
Cc: mfasheh@suse.de, linux-btrfs@vger.kernel.org, fdmanana@gmail.com
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <31acfc07-6db3-a04e-1999-7f8c3cb0fa39@gmx.com>
Date: Sun, 31 Jul 2016 09:47:59 +0800
MIME-Version: 1.0
In-Reply-To: <bbcce409-52ee-fcc8-daea-86a4c1221cf8@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/30/2016 11:57 PM, Goldwyn Rodrigues wrote:
>
>
> On 07/29/2016 08:06 PM, Qu Wenruo wrote:
>> Hi, Goldwyn,
>>
>> This patch is replaced by the following patchset:
>> https://patchwork.kernel.org/patch/9213915/
>> https://patchwork.kernel.org/patch/9213913/
>>
>> Would you mind testing the new patch?
>>
>
>
> Sorry, it fails. Actually, the previous patch fails on one of the more
> aggressive tests by Mark. So, I would revoke my "Tested-by: " there.
>
> Attached is Mark's test case. Make sure your /boot and /usr directories
> have enough files.
>
>
Thanks for the info.

I'll check it further.

Thanks,
Qu
