Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35012 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755294AbcHYX4U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 19:56:20 -0400
Received: by mail-oi0-f65.google.com with SMTP id e80so5742270oig.2
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Aug 2016 16:56:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57BF15AF.40406@5t9.de>
References: <1471023419.16857.9.camel@gmail.com> <CAJCQCtSwHCkW_nUNp4-R=S+ExZMk97i2qr6MwSuRU540c6xtfg@mail.gmail.com>
 <1471028417.16857.12.camel@gmail.com> <CAJCQCtTrEqR=UNpHp7ApbdBkwRRT6U5tiSHcs2y4N-P_G5u=Fw@mail.gmail.com>
 <CAJCQCtS51syrzxvpZXGzS=Ge=rW1iEfZDj6VrVmON39ww-Hmdg@mail.gmail.com>
 <CAKdnfRJeOXHmrumDkfxLTf-nU=KwZ0f7ybET-3o7kwwJDOZ2aw@mail.gmail.com>
 <CAJCQCtTrGTjOMaNNV7JKBybgbyn=_pYP=KvE1zc4AuPs=mo2=A@mail.gmail.com> <57BF15AF.40406@5t9.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 25 Aug 2016 17:56:18 -0600
Message-ID: <CAJCQCtT=X4bU42RUQfY3ogjvpd65YZKQ7_R+PEj8vO-e91n4FQ@mail.gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Lutz Vieweg <lvml@5t9.de>
Cc: Chris Murphy <lists@colorremedies.com>, Ronan Chagas <ronisbr@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 25, 2016 at 9:58 AM, Lutz Vieweg <lvml@5t9.de> wrote:
> On 08/16/2016 01:24 AM, Chris Murphy wrote:
>>
>> On Mon, Aug 15, 2016 at 5:12 PM, Ronan Chagas <ronisbr@gmail.com> wrote:
>>>
>>> It happened again. The computer was completely unusable. The only useful
>>> message I saw was this one:
>>>
>>> http://img.ctrlv.in/img/16/08/16/57b24b0bb2243.jpg
>>
>>
>> Looks similar to this:
>> https://lkml.org/lkml/2016/3/28/230
>
>
> Looks also similar to the subject of the lenghty thread titled
> "6TB partition, Data only 2TB - aka When you haven't hit the "usual"
> problem"
> that started with:
>>
>> http://www.spinics.net/lists/linux-btrfs/msg50599.html


I'm thinking it might be a conflict with the OP doing builds, implies
heavy writes, maybe especially heavy metadata based on the large
increase in metadata allocation; along with the default on opensuse
using snapper to make read only snapshots. That it can't be triggered
on demand makes sense, if the build doesn't overlap with snapper
making a snapshot of /home.

http://www.spinics.net/lists/linux-btrfs/msg52670.html

Anyway it's a known problem, I don't think it's fixed still. There's a
lot of enospc work in 4.8 so eventually it'll make sense to give it a
shot with that kernel.

-- 
Chris Murphy
