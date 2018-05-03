Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:55220 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751133AbeECTQU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 May 2018 15:16:20 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 00/14 RFC] Btrfs: Add journal for raid5/6 writes
To: Chris Mason <clm@fb.com>, "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Roman Mamedov <rm@romanrm.net>, Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
 <20170801222547.35d1bd03@natsu>
 <50312ea2-a0bf-09f7-8bc0-804c3a087ae4@gmail.com>
 <5800c104-5b03-8d48-bb49-b1710be05cd0@fb.com>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <0f1198b1-bad0-f9d3-dda8-79a67b329e16@libero.it>
Date: Thu, 3 May 2018 21:16:14 +0200
MIME-Version: 1.0
In-Reply-To: <5800c104-5b03-8d48-bb49-b1710be05cd0@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/02/2017 08:47 PM, Chris Mason wrote:
>> I agree, MD pretty much needs a separate device simply because they can't allocate arbitrary space on the other array members.  BTRFS can do that though, and I would actually think that that would be _easier_ to implement than having a separate device.
>>
>> That said, I do think that it would need to be a separate chunk type, because things could get really complicated if the metadata is itself using a parity raid profile.
> 
> Thanks for running with this Liu, I'm reading through all the patches. I do agree that it's better to put the logging into a dedicated chunk type, that way we can have it default to either double or triple mirroring.

Sorry for reply a bit late :-), however it should be sufficient to start the writes from the stripe boundary. For a filesystem this is complicate to grant, however for a journal it would be more simple to do;

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
