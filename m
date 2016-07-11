Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28459 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758559AbcGKKwG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 06:52:06 -0400
Date: Mon, 11 Jul 2016 06:51:27 -0400
From: Chris Mason <clm@fb.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
CC: Gabriel C <nix.or.die@gmail.com>, <linux-btrfs@vger.kernel.org>,
        <quwenruo@cn.fujitsu.com>
Subject: Re: A lot warnings in dmesg while running thunderbird
Message-ID: <20160711105122.GA30104@clm-mbp.masoncoding.com>
References: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com>
 <47ff1ea1-d4a9-55d9-f65d-60e94be93146@gmail.com>
 <73545420-2ce5-c4d3-d59a-98d2114bafd2@fb.com>
 <35812568.Zn4Yz0rfXf@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <35812568.Zn4Yz0rfXf@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 11, 2016 at 11:28:01AM +0530, Chandan Rajendra wrote:
>On Friday, July 08, 2016 12:02:35 PM Chris Mason wrote:
>>
>> Can you please run the attached test program:
>>
>> gcc -o short-write short-write.c -lpthread
>> ./short-write some-new-file-on-btrfs
>>
>> I want to see if you're triggering the same problem we've tried to fix,
>> or something else.
>>
>
>Hi Chris,
>
>I am able to reproduce the issue with the 'short-write' program. But before
>the call trace associated with btrfs_destroy_inode(), I see the following call
>trace ...
>
>------------[ cut here ]------------
>WARNING: CPU: 2 PID: 2311 at /home/chandan/repos/linux/fs/btrfs/extent-tree.c:4303 btrfs_free_reserved_data_space_noquota+0xe8/0x100
>Modules linked in:

[ ... ]

>
>I will continue to debug and find out the root cause.

Thanks Chandan, I'm able to reproduce the same thing more easily by changing
short-write to have:

#define ROUNDS 4096

and by getting rid of the sync_file_range call.

Still nailing down where the accounting is going wrong, so any help is
appreciated.

-chris

