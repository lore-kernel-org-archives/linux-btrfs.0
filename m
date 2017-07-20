Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:56022 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932705AbdGTDjR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jul 2017 23:39:17 -0400
Subject: Re: [PATCH 00/15] Btrfs-progs offline scrub
To: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>,
        Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20170715091053.19725-1-gujx@cn.fujitsu.com>
 <20170718063357.12450-1-gujx@cn.fujitsu.com>
 <e0cbd6df-d88b-1753-f58d-0652afdd5233@prismatelecomtesting.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7ff53bf4-4755-2e76-8ea5-eb9c38969985@gmx.com>
Date: Thu, 20 Jul 2017 11:39:00 +0800
MIME-Version: 1.0
In-Reply-To: <e0cbd6df-d88b-1753-f58d-0652afdd5233@prismatelecomtesting.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年07月20日 00:45, Marco Lorenzo Crociani wrote:
> On 18/07/2017 08:33, Gu Jinxiang wrote:
>> For any one who wants to try it, it can be get from my repo:
>> https://github.com/gujx2017/btrfs-progs/tree/offline_scrub
>>
> 
> Hi,
> I'm getting this error during make:
> 
>      [CC]     csum.o
> csum.c: In function ‘btrfs_read_data_csums’:
> csum.c:119:3: error: ‘for’ loop initial declarations are only allowed in 
> C99 mode
>     for (u32 i = 0; i != final_len / csum_size; i++)
>     ^

Oh, this is indeed a problem.
Introduced in the version which bitmap for csum is introduced.

Should be fixed to use c90 standard (at least gnu90).

> csum.c:119:3: note: use option -std=c99 or -std=gnu99 to compile your code
> make: *** [csum.o] Errore 1
> 
> 
> git clone https://github.com/gujx2017/btrfs-progs.git
> git checkout offline_scrub
> ./autogen.sh
> ./configure
> make
> 
> CentOS 7.3
> kernel 4.12

Seems to be related to gcc version.
Newer gcc use higher std which doesn't have such problem, while gcc 4.8 
is still using lower standard and will print output such warning.

I'll try to enhance the Makefile to use gnu90 standard to avoid such 
problem.

Thanks,
Qu



> 
> No problem compiling official btrfs-progs v4.11.1
> 
> Regards,
> 
