Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpweb130.aruba.it ([62.149.158.130]:40523 "EHLO
        smtpweb130.aruba.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754265AbdGSQwy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jul 2017 12:52:54 -0400
Subject: Re: [PATCH 00/15] Btrfs-progs offline scrub
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: quwenruo.btrfs@gmx.com
References: <20170715091053.19725-1-gujx@cn.fujitsu.com>
 <20170718063357.12450-1-gujx@cn.fujitsu.com>
From: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>
Message-ID: <e0cbd6df-d88b-1753-f58d-0652afdd5233@prismatelecomtesting.com>
Date: Wed, 19 Jul 2017 18:45:43 +0200
MIME-Version: 1.0
In-Reply-To: <20170718063357.12450-1-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18/07/2017 08:33, Gu Jinxiang wrote:
> For any one who wants to try it, it can be get from my repo:
> https://github.com/gujx2017/btrfs-progs/tree/offline_scrub
> 

Hi,
I'm getting this error during make:

     [CC]     csum.o
csum.c: In function ‘btrfs_read_data_csums’:
csum.c:119:3: error: ‘for’ loop initial declarations are only allowed in 
C99 mode
    for (u32 i = 0; i != final_len / csum_size; i++)
    ^
csum.c:119:3: note: use option -std=c99 or -std=gnu99 to compile your code
make: *** [csum.o] Errore 1


git clone https://github.com/gujx2017/btrfs-progs.git
git checkout offline_scrub
./autogen.sh
./configure
make

CentOS 7.3
kernel 4.12

No problem compiling official btrfs-progs v4.11.1

Regards,

-- 
Marco Crociani
