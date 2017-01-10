Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33016 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935492AbdAJQF0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 11:05:26 -0500
Received: by mail-io0-f195.google.com with SMTP id 101so6511538iom.0
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jan 2017 08:05:26 -0800 (PST)
Subject: Re: mkfs.btrfs/balance small-btrfs chunk size RFC
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <pan$cb31b$a126bd1f$577e9db8$38b890f5@cox.net>
 <db8aff8c-44a5-f488-56de-4a9ec87e44e0@gmail.com>
 <20170110152905.GJ19585@carfax.org.uk>
 <c934f74c-6dac-b66f-13cf-eb9bf0a79aac@gmail.com>
 <20170110154753.GK19585@carfax.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <46721c7c-2be2-28e8-c387-4d88b6d1a09d@gmail.com>
Date: Tue, 10 Jan 2017 11:05:17 -0500
MIME-Version: 1.0
In-Reply-To: <20170110154753.GK19585@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-01-10 10:47, Hugo Mills wrote:
> On Tue, Jan 10, 2017 at 10:42:51AM -0500, Austin S. Hemmelgarn wrote:
>> Most of the issue in this case is with the size of the initial
>> chunk. That said, I've got quite a few reasonably sized filesystems
>> (I think the largest is 200GB) with moderate usage (max 90GB of
>> data), and none of them are using more than the first 16kB block in
>> the System chunk. While I'm not necessarily a typical user, I'd be
>> willing to bet based on this that in general, most people who aren't
>> storing very large amounts of data or taking huge numbers of
>> snapshots aren't going to need a system chunk much bigger than 1MB.
>
>    Again, the system chunk has *nothing* to do with snapshots.
Apologies, I somehow completely missed the part of your first reply 
where you commented on that...
>
>    Agreed with everything else, though.
>
>    Hugo.
>

