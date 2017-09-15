Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-wd.italiaonline.it ([212.48.13.167]:56633 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751458AbdIOS5o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 14:57:44 -0400
Reply-To: kreijack@inwind.it
Subject: Re: BUG: BTRFS and O_DIRECT could lead to wrong checksum and wrong
 data
To: bo.li.liu@oracle.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cf8a733f-2c9d-7ffe-e865-4c13d99dfb60@libero.it>
 <20170915170122.GA16835@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <4639cd06-b201-5082-b967-e104f0f2e0d8@inwind.it>
Date: Fri, 15 Sep 2017 20:57:41 +0200
MIME-Version: 1.0
In-Reply-To: <20170915170122.GA16835@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/15/2017 07:01 PM, Liu Bo wrote:
>> Conclusion: even if the file is corrupted and normally BTRFS prevent to access it, using O_DIRECT
>> a) no error is returned to the caller
>> b) instead of the page stored on the disk, it is returned a page filled with 0x01 (according also with the function __readpage_endio_check())
>>
> We've queued a patch[1] to fix it, the behavior was introduced a long
> time ago and we guess it was for testing purpose.
> 
> With the patch, you'll get -EIO from dio read, which is consistent
> with buffered read.

I tried your patch, but it doesn't seem to address this issue. I still got -EIO with a normal file access, and a page filled by 0x01 with O_DIRECT.

If I understand your patch, this address the case where there is no any checksum, which is not this case. The checksum exists and it is valid. It is the data wrong.

BR
G.Baroncelli

> 
> [1],
> https://patchwork.kernel.org/patch/9835505/
> Btrfs: report errors when checksum is not found
> 
> Thanks,
> 
> -liubo
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
