Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:35076 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965465AbcCONzc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 09:55:32 -0400
Received: by mail-qg0-f45.google.com with SMTP id y89so14610361qge.2
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2016 06:55:31 -0700 (PDT)
Subject: Re: New file system with same issue
To: Marc Haber <mh+linux-btrfs@zugschlus.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160313115809.GQ2334@torres.zugschlus.de>
 <20160314120703.GD2334@torres.zugschlus.de> <56E6B312.30903@googlemail.com>
 <20160314201306.GH2334@torres.zugschlus.de> <56E7E96E.6080301@googlemail.com>
 <20160315134602.GQ2334@torres.zugschlus.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56E813FE.2070206@gmail.com>
Date: Tue, 15 Mar 2016 09:54:06 -0400
MIME-Version: 1.0
In-Reply-To: <20160315134602.GQ2334@torres.zugschlus.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-15 09:46, Marc Haber wrote:
> On Tue, Mar 15, 2016 at 11:52:30AM +0100, Holger Hoffstätte wrote:
>> On 03/14/16 21:13, Marc Haber wrote:
>>> Do I need to wait for clear_cache to finish, like until I see disk
>>> usage dropping?
>>
>> The cache isn't that big, so you won't see a huge drop. Just use the
>> disk normally for a few minutes, after some time the cache will be
>> written out again.
>
> Is it necessary to actually cause activity on the file system or is it
> ok to just let it sit there for an hour or so?
It should be OK to just let it sit there for ten or fifteen minutes. I'm 
pretty certain that the free space cache gets rebuilt relatively 
quickly, and I'm almost 100% certain that the old one gets dropped 
within seconds of the FS being mounted with -o clear_cache.  I've 
rebuilt the cache on the 64G root filesystem on my laptop a couple of 
times before, and it consistently appears to take about 2-3 minutes to 
do so at most (based on disk usage from the kernel itself).

