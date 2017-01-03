Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:32960 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759946AbdACXNz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jan 2017 18:13:55 -0500
Received: by mail-yw0-f171.google.com with SMTP id r204so301607317ywb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jan 2017 15:12:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69d0539f-6cb4-644f-2e7e-16bb1575052e@mendix.com>
References: <CAEtw4r0-wgdQj4nO9HxCFvzXpRVhU=nqcKxRmDUsFVBuVrfong@mail.gmail.com>
 <0d0a4169-8c09-56c5-a052-0c894c46081c@gmail.com> <CAEtw4r2hU74Qfa_6X=y5hNQSq-yN9y=9wpAF7CjRgVP2p=ns-w@mail.gmail.com>
 <69d0539f-6cb4-644f-2e7e-16bb1575052e@mendix.com>
From: Peter Becker <floyd.net@gmail.com>
Date: Wed, 4 Jan 2017 00:12:35 +0100
Message-ID: <CAEtw4r1-WwLiK2trAWNJMwFRP2shOS+hemSNWMbKWAd-FBQrKw@mail.gmail.com>
Subject: Re: [markfasheh/duperemove] Why blocksize is limit to 1MB?
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Good hint, this would be an option and i will try this.

Regardless of this the curiosity has packed me and I will try to
figure out where the problem with the low transfer rate is.

2017-01-04 0:07 GMT+01:00 Hans van Kranenburg <hans.van.kranenburg@mendix.com>:
> On 01/03/2017 08:24 PM, Peter Becker wrote:
>> All invocations are justified, but not relevant in (offline) backup
>> and archive scenarios.
>>
>> For example you have multiple version of append-only log-files or
>> append-only db-files (each more then 100GB in size), like this:
>>
>>> Snapshot_01_01_2017
>> -> file1.log .. 201 GB
>>
>>> Snapshot_02_01_2017
>> -> file1.log .. 205 GB
>>
>>> Snapshot_03_01_2017
>> -> file1.log .. 221 GB
>>
>> The first 201 GB would be every time the same.
>> Files a copied at night from windows, linux or bsd systems and
>> snapshoted after copy.
>
> XY problem?
>
> Why not use rsync --inplace in combination with btrfs snapshots? Even if
> the remote does not support rsync and you need to pull the full file
> first, you could again use rsync locally.
>
> --
> Hans van Kranenburg
