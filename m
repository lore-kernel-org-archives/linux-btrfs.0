Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ed1-f45.google.com ([209.85.208.45]:34628 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbeHKJ1T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Aug 2018 05:27:19 -0400
Received: by mail-ed1-f45.google.com with SMTP id h1-v6so5814806eds.1
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 23:54:08 -0700 (PDT)
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
To: Tomasz Pala <gotar@polanet.pl>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
 <20180809174811.GA27001@polanet.pl>
 <ecd793f3-55b3-84d4-80cf-3382a580037f@gmx.com>
 <20180810071748.GA5473@polanet.pl>
 <33914565-224f-71b6-f319-7c66e3a69d4d@gmx.com>
 <20180810093317.GA558@polanet.pl>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <143f2b3e-8b86-cf4a-0d1c-4f544af1eb2f@gmail.com>
Date: Sat, 11 Aug 2018 09:54:05 +0300
MIME-Version: 1.0
In-Reply-To: <20180810093317.GA558@polanet.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

10.08.2018 12:33, Tomasz Pala пишет:
> 
>> For 4 disk with 1T free space each, if you're using RAID5 for data, then
>> you can write 3T data.
>> But if you're also using RAID10 for metadata, and you're using default
>> inline, we can use small files to fill the free space, resulting 2T
>> available space.
>>
>> So in this case how would you calculate the free space? 3T or 2T or
>> anything between them?
> 
> The answear is pretty simple: 3T. Rationale:
> - this is the space I do can put in a single data stream,
> - people are aware that there is metadata overhead with any object;
>   after all, metadata are also data,
> - while filling the fs with small files the free space available would
>   self-adjust after every single file put, so after uploading 1T of such
>   files the df should report 1.5T free. There would be nothing weird(er
>   that now) that 1T of data has actually eaten 1.5T of storage.
> 
> No crystal ball calculations, just KISS; since one _can_ put 3T file
> (non sparse, uncompressible, bulk written) on a filesystem, the free space is 3T.
> 

As far as I can tell, that is exactly what "df" reports now. "btrfs fi
us" will tell you both max (reported by "df") and worst case min.
