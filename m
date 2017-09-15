Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-wd.italiaonline.it ([212.48.13.167]:39273 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751157AbdIOF6v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 01:58:51 -0400
Reply-To: kreijack@inwind.it
Subject: Re: BUG: BTRFS and O_DIRECT could lead to wrong checksum and wrong
 data
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cf8a733f-2c9d-7ffe-e865-4c13d99dfb60@libero.it>
 <3fc175a8-a61b-6060-5c78-abbbe2e61037@gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <22378b5d-c679-f85f-af1b-0a4b3c8d5f14@inwind.it>
Date: Fri, 15 Sep 2017 07:50:40 +0200
MIME-Version: 1.0
In-Reply-To: <3fc175a8-a61b-6060-5c78-abbbe2e61037@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/15/2017 05:55 AM, Andrei Borzenkov wrote:
> 15.09.2017 01:00, Goffredo Baroncelli пишет:
>>
>> 2) The second bug, is a more severe bug. If during a writing of a buffer with O_DIRECT, the buffer is updated at the same time by a second process, the checksum may be incorrect.
>>
> 
> Is it btrfs specific ? If buffer is updated before it was actually
> consumed by kernel, this likely means data corruption on any filesystem.

I don't see any corruption in other FS. The fact that application push to filesystem garbage, doesn't allow the filesystem to be corrupted. 
In this case the filesystem became corrupted, because another application which try to read the data (without O_DIRECT) may got -EIO.

I repeat, the problem is a data race when the data is in the FS camp, and the kernel does wrong checksum.


IMHO, BTRFS should disallow O_DIRECT (which is the same thing that does ZFS on linux); I think that it could be allowed only for  nodatasum files.

> I.e. there should be clear indication from kernel that buffer can be
> reused by application, in your example - when pwrite returns. So when
> data corruption happens - during pwrite or after? 
> If data is corrupted
> during pwrite, it is arguably application fault - it should disallow
> concurrent access.





> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
