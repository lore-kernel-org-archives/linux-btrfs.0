Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33524 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755002AbcK2MVW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 07:21:22 -0500
Received: by mail-io0-f193.google.com with SMTP id j92so29081933ioi.0
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 04:20:50 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id b196sm21529247ioe.16.2016.11.29.04.20.47
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Nov 2016 04:20:47 -0800 (PST)
Subject: Re: mount option nodatacow for VMs on SSD?
To: linux-btrfs@vger.kernel.org
References: <20161125082840.GA32711@rus.uni-stuttgart.de>
 <20161126112710.6aca8bac@jupiter.sol.kaishome.de>
 <20161128003829.GD15348@rus.uni-stuttgart.de>
 <20161128092015.70b75dd8@jupiter.sol.kaishome.de>
 <ca646391-bd9f-49b2-bca4-8faee04fd82a@linuxsystems.it>
 <pan$8ecb6$a69408d3$b47213c2$9bfeddf6@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <72906a86-ec80-3c37-d364-14ba0433a213@gmail.com>
Date: Tue, 29 Nov 2016 07:20:43 -0500
MIME-Version: 1.0
In-Reply-To: <pan$8ecb6$a69408d3$b47213c2$9bfeddf6@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-29 00:06, Duncan wrote:
> Niccolò Belli posted on Mon, 28 Nov 2016 12:11:49 +0100 as excerpted:
>
>> On lunedì 28 novembre 2016 09:20:15 CET, Kai Krakow wrote:
>>> You can, however, use chattr to make the subvolume root directory (that
>>> one where it is mounted) nodatacow (chattr +C) _before_ placing any
>>> files or directories in there. That way, newly created files and
>>> directories will inherit the flag. Take note that this flag can only
>>> applied to directories and empty (zero-sized) files.
>>
>> Do I keep checksumming for this directory such a way?
>
> No.  Keeping checksums current on NOCOW files is racy, and compression
> would be complex as well because rewritten data may compress more or less
> well than the original so the on-filesystem size could change, so both
> features are disabled in the presence of NOCOW, regardless of how it is
> set.
>
> Put another way, btrfs assumes COW by default and many of its features
> depend on COW -- that's why these features don't tend to be implemented
> on conventional rewrite-in-place filesystems in the first place.  Both
> checksumming and compression are among these COW-dependent features.
>
We really should get this put up somewhere very visible on the wiki. 
It's pretty blatantly obvious to anyone with a CS degree, but most users 
don't have a CS degree, and I can't count the number of e-mails I've 
sent explaining why checksums plus NOCOW are a recipe for disaster.
