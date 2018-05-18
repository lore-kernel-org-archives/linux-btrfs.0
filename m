Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:40727 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbeERSdz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 14:33:55 -0400
Received: by mail-it0-f43.google.com with SMTP id j186-v6so14277524ita.5
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2018 11:33:55 -0700 (PDT)
Subject: Re: Any chance to get snapshot-aware defragmentation?
To: =?UTF-8?Q?Niccol=c3=b2_Belli?= <darkbasic@linuxsystems.it>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
References: <4428b2eb-796a-4c1b-8527-a05532436da4@linuxsystems.it>
 <20180518162051.GS6649@twin.jikos.cz>
 <99d57070-a1df-45ef-8f7e-df832bd7ad92@linuxsystems.it>
 <de7adf73-ba0b-9154-e3d1-b4e468ad3c96@gmail.com>
 <161bea23-f1ea-4f01-b3ea-2c5e706102a7@linuxsystems.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <07cf6f9b-7d67-93b9-2a6f-6d031ccf5468@gmail.com>
Date: Fri, 18 May 2018 14:33:53 -0400
MIME-Version: 1.0
In-Reply-To: <161bea23-f1ea-4f01-b3ea-2c5e706102a7@linuxsystems.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-05-18 13:18, Niccolò Belli wrote:
> On venerdì 18 maggio 2018 19:10:02 CEST, Austin S. Hemmelgarn wrote:
>> and also forces the people who have ridiculous numbers of snapshots to 
>> deal with the memory usage or never defrag
> 
> Whoever has at least one snapshot is never going to defrag anyway, 
> unless he is willing to double the used space.
> 
With a bit of work, it's possible to handle things sanely.  You can 
deduplicate data from snapshots, even if they are read-only (you need to 
pass the `-A` option to duperemove and run it as root), so it's 
perfectly reasonable to only defrag the main subvolume, and then 
deduplicate the snapshots against that (so that they end up all being 
reflinks to the main subvolume).  Of course, this won't work if you're 
short on space, but if you're dealing with snapshots, you should have 
enough space that this will work (because even without defrag, it's 
fully possible for something to cause the snapshots to suddenly take up 
a lot more space).
