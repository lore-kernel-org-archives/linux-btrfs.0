Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:36591 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751065AbdCQTfP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Mar 2017 15:35:15 -0400
Received: by mail-qt0-f173.google.com with SMTP id r45so70832483qte.3
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Mar 2017 12:35:10 -0700 (PDT)
Subject: Re: BTRFS Metadata Corruption Prevents Scrub and btrfs check
To: John Marrett <johnf@zioncluster.ca>,
        Peter Grandi <pg@btrfs.list.sabi.co.uk>
References: <CAAafysHAZ_1-4rTqsY4cw0rkBgq3f_F29nM+=XsDEhNvR8CkJQ@mail.gmail.com>
 <22731.59878.724789.333618@tree.ty.sabi.co.uk>
 <CAAafysFBYkAe9pgmnky4-Rxd0r1Xau3rb2ueT0Yu+rjDT9+Atw@mail.gmail.com>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e1e39916-e223-9ad6-cc3b-454b3560a8fb@gmail.com>
Date: Fri, 17 Mar 2017 15:35:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAAafysFBYkAe9pgmnky4-Rxd0r1Xau3rb2ueT0Yu+rjDT9+Atw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-03-17 15:25, John Marrett wrote:
> Peter,
>
>> Bad news. That means that probably the disk is damaged and
>> further issues may happen.
>
> This system has a long history, I have had a dual drive failure in the
> past, I managed to recover from that with ddrescue. I've subsequently
> copied the contents of the drives to new disks and expanded them. This
> corruption probably stems from issues in the past and not from issues
> with the current drives.
One quick tip on this particular note, when you replace a drive (or copy 
to new larger drives), run:
btrfs device stats -z
To reset the error counters.  This way, you can be sure that the 
counters count errors for the filesystem as it currently exists without 
leftover counts from any previous drive configuration.

Ideally, the tools would reset them when replacing a device on only that 
device, but even if they did, that wouldn't help with simply copying the 
filesystem to a new disk.

The other aspect to this is scrubbing regularly and monitoring both the 
output of scrub and the error counters, so you know _when_ an error 
happened, not just that it happened at some point in the past. 
Personally, I would suggest checking the error counters at least daily, 
possibly more frequently (it's not an expensive operation, and the 
sooner you know about issues the better) and scrubbing at least monthly 
(I scrub daily on most of my systems, but I don't store a large enough 
amount of data for that to have a significant impact on performance).
