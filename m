Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:46450 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751148AbcK2ST2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 13:19:28 -0500
Reply-To: kreijack@inwind.it
Subject: Re: RFC: raid with a variable stripe size
References: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it>
 <657fcefe-4e6c-ced3-a3c9-2dc1f77e1404@cn.fujitsu.com>
 <CAJCQCtR==9wadS=9swcUhHJ77tGksvHMvNd3ZJrpt3+-U779tA@mail.gmail.com>
 <cf02a446-f83d-0d4b-2b60-70a99e18ab39@cn.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Zygo Blaxell <zblaxell@furryterror.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <33049d04-a0b3-8a71-7ab1-6993a63ca07d@inwind.it>
Date: Tue, 29 Nov 2016 19:19:25 +0100
MIME-Version: 1.0
In-Reply-To: <cf02a446-f83d-0d4b-2b60-70a99e18ab39@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-29 07:03, Qu Wenruo wrote:
[...]
>> Btrfs is subject to the write hole problem on disk, but any read or
>> scrub that needs to reconstruct from parity that is corrupt results in
>> a checksum error and EIO. So corruption is not passed up to user
>> space. Recent versions of md/mdadm support a write journal to avoid
>> the write hole problem on disk in case of a crash.
> 
> That's interesting.
> 
> So I think it's less worthy to support RAID56 in btrfs, especially considering the stability.
> 
> My widest dream is, btrfs calls device mapper to build a micro RAID1/5/6/10 device for each chunk.
> Which should save us tons of codes and bugs.
> 
> And for better recovery, enhance device mapper to provide interface to judge which block is correct.
> 
> Although that's just dream anyway.


IIRC in the past this was discussed, although I am not able to find any reference...


BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
