Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9950 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752800AbcHAP2J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Aug 2016 11:28:09 -0400
Subject: Re: qcow2 becomes 37P in size while qemu crashes
To: Chris Murphy <lists@colorremedies.com>
References: <CAJCQCtQOV4gsh-Kaz6n=d9KBYCyOh9eb65-G8KBd8B_HJ_tNBg@mail.gmail.com>
 <CAJCQCtQYicoze=jBf9ptQABLZSxgd67MYUbCs2igB2PipugxaA@mail.gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <dac1d283-feb1-f496-0637-8ba57398d055@fb.com>
Date: Mon, 1 Aug 2016 11:26:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQYicoze=jBf9ptQABLZSxgd67MYUbCs2igB2PipugxaA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/23/2016 04:05 PM, Chris Murphy wrote:
> Using btrfs-debug-tree, I'm finding something a bit odd about some of
> the items in this 39P file.
>
> Seems normal
>
>     item 71 key (994163 EXTENT_DATA 43689967616) itemoff 12467 itemsize 53
>         extent data disk byte 617349906432 nr 80805888
>         extent data offset 0 nr 80805888 ram 80805888
>         extent compression(none)
>
> Seems not normal
>
>     item 58 key (994163 EXTENT_DATA 38345535488) itemoff 13156 itemsize 53
>         extent data disk byte 0 nr 0
>         extent data offset 394752000 nr 61440 ram 34626881742770176
>         extent compression(none)
>
> There are quite a large number of items that take the 2nd form, and in
> each case the ram value is the same as above.
>
>

Can't really blame a bit flip for that one.  Looks like our hole 
truncation math has gone crazy there.  I'll see what I can find, but 
please yell if you can reproduce.

Thanks!

-chris
