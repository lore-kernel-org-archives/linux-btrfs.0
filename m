Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36793 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbdBMMom (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 07:44:42 -0500
Received: by mail-it0-f68.google.com with SMTP id f200so13271521itf.3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 04:44:42 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id c124sm4986574ioc.39.2017.02.13.04.44.39
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Feb 2017 04:44:39 -0800 (PST)
Subject: Re: BTRFS for OLTP Databases
To: linux-btrfs@vger.kernel.org
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk>
 <CA+RUij02VMTa-L59AD9B3G+g_dS3HO7-Ttsz-qWgJtMyf58sPQ@mail.gmail.com>
 <20170207213614.5fd40981@jupiter.sol.kaishome.de>
 <7c1a67ce-a62c-36e1-d228-9a1e15e4d16c@gmail.com>
 <b0de25a7-989e-d16a-2ce6-2b6c1edde08b@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <98087974-62dc-bb97-ef98-9c681f544e1b@gmail.com>
Date: Mon, 13 Feb 2017 07:44:37 -0500
MIME-Version: 1.0
In-Reply-To: <b0de25a7-989e-d16a-2ce6-2b6c1edde08b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-09 22:58, Andrei Borzenkov wrote:
> 07.02.2017 23:47, Austin S. Hemmelgarn пишет:
> ...
>> Sadly, freezefs (the generic interface based off of xfs_freeze) only
>> works for block device snapshots.  Filesystem level snapshots need the
>> application software to sync all it's data and then stop writing until
>> the snapshot is complete.
>>
>
> I expect databases to be using directio, otherwise we have problems even
> without using snapshots. Is it still an issue with directio?
It is less of an issue, but it's still an issue because you can still 
call for snapshot creation in the middle of an application I/O request. 
In other words, the application wouldn't need to worry about syncing 
data, but it would need to worry about making sure it's not actually 
writing anything when the snapshot happens.

