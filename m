Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:36797 "EHLO
	mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbcFGO3r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jun 2016 10:29:47 -0400
Received: by mail-it0-f41.google.com with SMTP id h62so27565712itb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jun 2016 07:29:46 -0700 (PDT)
Subject: Re: btrfs device delete /dev/sdc1 /mnt/raid1 user experience
To: Kai Hendry <hendry@iki.fi>
References: <1465191858.3381218.628872649.1C5D6003@webmail.messagingengine.com>
 <CAJCQCtSYfX3M0DVd9WA+yru8Jm=wwfkmYCUUeeswE9DnsMAG1g@mail.gmail.com>
 <1465272129.3661627.630003937.6FC96567@webmail.messagingengine.com>
 <abecd302-3ef4-ba0e-eba1-fe27bb68a539@gmail.com>
 <1465307538.3786093.630450009.4FD7B429@webmail.messagingengine.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ab742a73-8b29-2210-9d97-af712eba0251@gmail.com>
Date: Tue, 7 Jun 2016 10:29:41 -0400
MIME-Version: 1.0
In-Reply-To: <1465307538.3786093.630450009.4FD7B429@webmail.messagingengine.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-07 09:52, Kai Hendry wrote:
> On Tue, 7 Jun 2016, at 07:10 PM, Austin S. Hemmelgarn wrote:
>> Yes, although you would then need to be certain to run a balance with
>> -dconvert=raid1 -mconvert=raid1 to clean up anything that got allocated
>> before the new disk was added.
>
> I don't quite understand when I should run this command.
>
> Before I take it out? Once I take it out? One the new one is added?
On both systems once you've gotten the new devices added so that the 
filesystems are no longer degraded.
>
> And why doesn't it do this automatically? =)
Ideally, it shouldn't be needed at all, it's just needed due to a 
deficiency in the high-level allocator in BTRFS.  Once that is fixed, 
this won't be needed at all, and I think the consensus is that that 
should be fixed instead of adding in something that will need to be 
taken out again later.

