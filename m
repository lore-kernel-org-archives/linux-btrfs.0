Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33349 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529AbaJUUoK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 16:44:10 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so2228145wgh.7
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 13:44:09 -0700 (PDT)
Received: from [192.168.0.12] (195-132-168-97.rev.numericable.fr. [195.132.168.97])
        by mx.google.com with ESMTPSA id p3sm10478606wjf.49.2014.10.21.13.44.07
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Oct 2014 13:44:08 -0700 (PDT)
Message-ID: <5446C597.9080904@gmail.com>
Date: Tue, 21 Oct 2014 22:44:07 +0200
From: Arnaud Kapp <kapp.arno@gmail.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: device balance times
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com> <5446BEC0.8070009@siedziba.pl>
In-Reply-To: <5446BEC0.8070009@siedziba.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I would like to ask if the balance time is related to the number of 
snapshot or if this is related only to data (or both).

I currently have about 4TB of data and around 5k snapshots. I'm thinking 
of going raid1 instead of single. From the numbers I see this seems 
totally impossible as it would take *way* too long.

Would destroying snapshots (those are hourly snapshots to prevent stupid 
error to happens, like `rm my_important_file`) help?

Should I reconsider moving to raid1 because of the time it would take?

Sorry if I'm somehow hijacking this thread, but it seemed related :)

Thanks,

On 10/21/2014 10:14 PM, Piotr Pawłow wrote:
> On 21.10.2014 20:59, Tomasz Chmielewski wrote:
>> FYI - after a failed disk and replacing it I've run a balance; it took
>> almost 3 weeks to complete, for 120 GBs of data:
>
> Looks normal to me. Last time I started a balance after adding 6th
> device to my FS, it took 4 days to move 25GBs of data. Some chunks took
> 20 hours to move. I currently have 156 snapshots on this FS (nightly
> rsync backups).
>
> I think it is so slow, because it's disassembling chunks piece by piece
> and stuffing these pieces elsewhere, instead of moving chunks as a
> whole. If you have a lot of little pieces (as I do), it will take a
> while...
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
