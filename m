Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52876 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752262AbdHPVi6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 17:38:58 -0400
Subject: Re: [PATCH] btrfs-progs: fix cross-compile build
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Hallo32@gmx.net, David Sterba <dsterba@suse.com>
References: <8f01ac45-1b6e-be1d-b6e3-48fe6cdc4833@redhat.com>
 <9a81d05e-68ab-45a1-a4dc-386b89f4c733@gmx.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <b6875bb8-1968-6164-cb67-773be3957fba@redhat.com>
Date: Wed, 16 Aug 2017 16:38:56 -0500
MIME-Version: 1.0
In-Reply-To: <9a81d05e-68ab-45a1-a4dc-386b89f4c733@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/15/17 7:17 PM, Qu Wenruo wrote:
> 
> 
> On 2017年08月16日 02:11, Eric Sandeen wrote:
>> The mktables binary needs to be build with the host
>> compiler at built time, not the target compiler, because
>> it runs at build time to generate the raid tables.
>>
>> Copy auto-fu from xfsprogs and modify Makefile to
>> accomodate this.
>>
>> Reported-by: Hallo32 <Hallo32@gmx.net>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Looks better than my previous patch.
> With @BUILD_CLFAGS support and better BUILD_CC/CLFAGS detection for native build environment.
> 
> Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

Thanks - and sorry for missing your earlier patch, I didn't mean to
ignore it.  :)  I just missed it.

-Eric
