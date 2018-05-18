Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:51989 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbeERRKE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 13:10:04 -0400
Received: by mail-it0-f53.google.com with SMTP id n202-v6so13998968ita.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2018 10:10:04 -0700 (PDT)
Subject: Re: Any chance to get snapshot-aware defragmentation?
To: =?UTF-8?Q?Niccol=c3=b2_Belli?= <darkbasic@linuxsystems.it>,
        David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
References: <4428b2eb-796a-4c1b-8527-a05532436da4@linuxsystems.it>
 <20180518162051.GS6649@twin.jikos.cz>
 <99d57070-a1df-45ef-8f7e-df832bd7ad92@linuxsystems.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <de7adf73-ba0b-9154-e3d1-b4e468ad3c96@gmail.com>
Date: Fri, 18 May 2018 13:10:02 -0400
MIME-Version: 1.0
In-Reply-To: <99d57070-a1df-45ef-8f7e-df832bd7ad92@linuxsystems.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-05-18 12:36, Niccolò Belli wrote:
> On venerdì 18 maggio 2018 18:20:51 CEST, David Sterba wrote:
>> Josef started working on that in 2014 and did not finish it. The patches
>> can be still found in his tree. The problem is in excessive memory
>> consumption when there are many snapshots that need to be tracked during
>> the defragmentation, so there are measures to avoid OOM. There's
>> infrastructure ready for use (shrinkers), there are maybe some problems
>> but fundamentally is should work.
>>
>> I'd like to get the snapshot-aware working again too, we'd need to find
>> a volunteer to resume the work on the patchset.
> 
> Yeah I know of Josef's work, but 4 years had passed since then without 
> any news on this front.
> 
> What I would really like to know is why nobody resumed his work: is it 
> because it's impossible to implement snapshot-aware degram without 
> excessive ram usage or is it simply because nobody is interested?
I think it's because nobody who is interested has both the time and the 
coding skills to tackle it.

Personally though, I think the biggest issue with what was done was not 
the memory consumption, but the fact that there was no switch to turn it 
on or off.  Making defrag unconditionally snapshot aware removes one of 
the easiest ways to forcibly unshare data without otherwise altering the 
files (which, as stupid as it sounds, is actually really useful for some 
storage setups), and also forces the people who have ridiculous numbers 
of snapshots to deal with the memory usage or never defrag.

