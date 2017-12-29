Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55192 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750709AbdL2Xxy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Dec 2017 18:53:54 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0083DACC6
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Dec 2017 23:53:53 +0000 (UTC)
Subject: Re: WARNING: CPU: 1 PID: 3016 at fs/btrfs/ctree.h:1564
 btrfs_update_device+0x189/0x190 [btrfs]
To: linux-btrfs@vger.kernel.org
References: <20171229163312.b3k7rfagcycz5mvf@galadriel.home.lxtec.de>
 <0a34347a-ae74-dbab-98bd-08d822347c9b@applied-asynchrony.com>
 <0b81a3bf-958a-7c82-eea0-a04c916703b1@suse.com>
 <20171229181738.gdsdgcu2yicritu4@galadriel.home.lxtec.de>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <828bbb38-f803-f542-c959-4297b5c10c90@suse.com>
Date: Sat, 30 Dec 2017 01:53:52 +0200
MIME-Version: 1.0
In-Reply-To: <20171229181738.gdsdgcu2yicritu4@galadriel.home.lxtec.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.12.2017 20:17, Elimar Riesebieter wrote:
> Thanks,
> 
> * Nikolay Borisov <nborisov@suse.com> [2017-12-29 19:23 +0200]:
> 
> [...]
> 
>> So OP:
>>
>> Update your btrfs-progs package to latest 4.14 and run btrfs rescue :
>>
>> btrfs rescue fix-device-size <device>
> 
> I installed btrfs-progs 4.14. Can't run 
> 'btrfs rescue fix-device-size /dev/sd(a|b)3'. The devices are mounted
> including my root... 
> 
> How to accomplish?

Then you have to resize your fs to a multiple of 4k, either up or down.
> 
> Thanks in advance
> 
> Elimar
> 
