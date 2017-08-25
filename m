Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56425 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753492AbdHYA1d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 20:27:33 -0400
Subject: Re: [PATCH] btrfs-progs: fix cross-compile build
To: dsterba@suse.cz, Eric Sandeen <sandeen@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Hallo32@gmx.net, David Sterba <dsterba@suse.com>
References: <8f01ac45-1b6e-be1d-b6e3-48fe6cdc4833@redhat.com>
 <9a81d05e-68ab-45a1-a4dc-386b89f4c733@gmx.com>
 <20170824170131.GG2866@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8f0e8cc1-98cd-e858-f98a-77d4efd8e060@gmx.com>
Date: Fri, 25 Aug 2017 08:27:11 +0800
MIME-Version: 1.0
In-Reply-To: <20170824170131.GG2866@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月25日 01:01, David Sterba wrote:
> On Wed, Aug 16, 2017 at 08:17:00AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2017年08月16日 02:11, Eric Sandeen wrote:
>>> The mktables binary needs to be build with the host
>>> compiler at built time, not the target compiler, because
>>> it runs at build time to generate the raid tables.
>>>
>>> Copy auto-fu from xfsprogs and modify Makefile to
>>> accomodate this.
>>>
>>> Reported-by: Hallo32 <Hallo32@gmx.net>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>
>> Looks better than my previous patch.
>> With @BUILD_CLFAGS support and better BUILD_CC/CLFAGS detection for
>> native build environment.
> 
> The contents of tables.c has practially not changed since its
> introduction in 2000s. I see no sense in regenerating it each time
> during build and I don't want to introduce host CC build just for
> this one file, standard practice or not.
> 

I understand the worry about adding host CC.
But just shown by the patch, the impact is minimal.

At least for me and already mentioned before, text file managed by git 
should be reviewable.
No matter if the file get modified in 20 years or not.
(BTW, I don't think there is much problem regenerating the RAID6 table. 
It's way faster than auto-conf/auto-header things)

And I think that's the same reason other projects doesn't manage their 
generated CRC tables using git.

Thanks,
Qu
