Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i6.italiaonline.it ([212.48.14.170]:42456 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755310AbdHYOEW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 10:04:22 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH] btrfs-progs: fix cross-compile build
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Eric Sandeen <sandeen@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Hallo32@gmx.net, David Sterba <dsterba@suse.com>
References: <8f01ac45-1b6e-be1d-b6e3-48fe6cdc4833@redhat.com>
 <9a81d05e-68ab-45a1-a4dc-386b89f4c733@gmx.com>
 <20170824170131.GG2866@twin.jikos.cz>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <4e56c249-6133-5406-e1a8-a21ea1986a76@libero.it>
Date: Fri, 25 Aug 2017 16:03:15 +0200
MIME-Version: 1.0
In-Reply-To: <20170824170131.GG2866@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/24/2017 07:01 PM, David Sterba wrote:
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

I think that is a problem to have both the table generated and the mktable.c generator int git. Only one it is sufficient. Having both generate only confusion.

As my first option, I am to have only mktable in the git with BUILD_CC/CFLAGS. 
As second choice, we could remove mktable and put a comment that the tables are the kernel ones.

BTW, I suggest to put a comment in table.c to change mktable in case of update of the table. Otherwise is not obvious.

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
