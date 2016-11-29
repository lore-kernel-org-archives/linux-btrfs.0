Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:49355 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751485AbcK2SKG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 13:10:06 -0500
Reply-To: kreijack@inwind.it
Subject: Re: RFC: raid with a variable stripe size
References: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it>
 <657fcefe-4e6c-ced3-a3c9-2dc1f77e1404@cn.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Zygo Blaxell <zblaxell@furryterror.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <1879b5b7-47a9-4f4f-e875-1f94bd6283fa@inwind.it>
Date: Tue, 29 Nov 2016 19:10:01 +0100
MIME-Version: 1.0
In-Reply-To: <657fcefe-4e6c-ced3-a3c9-2dc1f77e1404@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-29 01:48, Qu Wenruo wrote:
> For example, if sectorsize is 64K, and we make stripe len to 32K, and use 3 disc RAID5, we can avoid such write hole problem.
> Withouth modification to extent/chunk allocator.
> 
> And I'd prefer to make stripe len mkfs time parameter, not possible to modify after mkfs. To make things easy.

This is like the Zygo idea: make the sector_size = (ndisk-1) * strpe_len... If this could be possible to implement per BG basis you answered the Zygo question. Of course when the number of the disk increases the disk space wasting increases too. But for small RAID5/6 (4/5 disk) it could be an acceptable trade-off.

Anyway on the basis that SSD is the future of storage, I think that our thoughts about how avoid a RMW cycle don't make sense. The SSD firmware remaps sectors, so what we think as "simple write" may hide a RMW because the erase sector are bigger than the disk sector (4k ?).

> 
> Thanks,
> Qu


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
