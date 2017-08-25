Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43956 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754234AbdHYBGl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 21:06:41 -0400
Subject: Re: [PATCH] btrfs-progs: fix cross-compile build
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Hallo32@gmx.net, David Sterba <dsterba@suse.com>
References: <8f01ac45-1b6e-be1d-b6e3-48fe6cdc4833@redhat.com>
 <9a81d05e-68ab-45a1-a4dc-386b89f4c733@gmx.com>
 <20170824170131.GG2866@twin.jikos.cz>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <91b91658-eabc-8323-2289-5986437e5ffa@redhat.com>
Date: Thu, 24 Aug 2017 20:06:40 -0500
MIME-Version: 1.0
In-Reply-To: <20170824170131.GG2866@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/24/17 12:01 PM, David Sterba wrote:
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
> during build

Make does know enough to generate it only as needed, of course.

> and I don't want to introduce host CC build just for
> this one file, standard practice or not.

*shrug* it seems like the obviously correct fix to me, but I won't
fight over it.

-Eric
