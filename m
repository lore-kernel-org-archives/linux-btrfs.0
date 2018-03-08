Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:37845 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751984AbeCHNNu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Mar 2018 08:13:50 -0500
Received: by mail-io0-f175.google.com with SMTP id d71so7006209iog.4
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Mar 2018 05:13:50 -0800 (PST)
Subject: Re: Per subvolume "RAID" level?!
To: waxhead@dirtcellar.net, linux-btrfs@vger.kernel.org
References: <cd82d247-5c95-18cd-a290-a911ff69613c@dirtcellar.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ee57e896-4d99-2805-4429-f80025614362@gmail.com>
Date: Thu, 8 Mar 2018 08:13:45 -0500
MIME-Version: 1.0
In-Reply-To: <cd82d247-5c95-18cd-a290-a911ff69613c@dirtcellar.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-03-08 05:36, waxhead wrote:
> Just out of curiosity, are there any work going on for enabling 
> different "RAID" levels per subvolume?!
Not that I know of, but it would be great to have (I could get rid of 
some of the various small isolated volumes I have solely to have a 
different storage profile for part of the system (it makes essentially 
zero sense to use raid1 for /var/cache)), assuming that cross-profile 
reflinks are properly disallowed (or have an option to be disallowed).
> 
> And out of even more curiosity how is this planned to be handled with 
> btrfs balance?! When per subvolume "RAID" levels are good to go, how 
> would you then run the balance filters to convert / leave alone certain 
> parts of the filesystem?!
I would assume a new balance filter would be added to select only chunks 
used by a given subvolume.
