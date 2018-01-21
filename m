Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:43084 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750869AbeAUXYs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Jan 2018 18:24:48 -0500
Received: by mail-ot0-f175.google.com with SMTP id p36so5996535otd.10
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Jan 2018 15:24:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSkPTLJ0d94_HrNmr_g+1spOBXjS8EY1RkXnXf15wUKFw@mail.gmail.com>
References: <7ebd40d4-3eea-9ad7-492f-b5d22cf935b0@gmail.com>
 <CAJCQCtSRj1v-qksod3FetjVCutSL1MbLWdg1KSt1RsndJkTU=A@mail.gmail.com>
 <05babf08-00de-ae0f-06f3-546719674aa1@gmail.com> <CAJCQCtSkPTLJ0d94_HrNmr_g+1spOBXjS8EY1RkXnXf15wUKFw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 21 Jan 2018 16:24:47 -0700
Message-ID: <CAJCQCtQ8n-MzjtHrbxYXiP03ypRf48NnqsfrqBn+0evC=HM_Ug@mail.gmail.com>
Subject: Re: Can't mount (even in ro) after power outage - corrupt leaf,
 open_ctree failed
To: msk conf <msk.conf@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 21, 2018 at 4:13 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Sun, Jan 21, 2018 at 3:31 PM, msk conf <msk.conf@gmail.com> wrote:
>> Hello,
>>
>> thank you for the reply.
>>
>>> What do you get for btrfs fi df /array
>>
>>
>> Can't do that because filesystem is not mountable. I will get stats for '/'
>> filesystem instead (because '/array' is an empty directory - mountpoint on /
>
> Try
> $ sudo btrfs-debug-tree -t chunk /dev/mapper/first | grep 'METADATA\|SYSTEM'


You need to adapt that /dev/ node for your case, I just copy pasted
that from my setup. Anyway, that will look at the chunk tree and show
the profile for these chunk types.


-- 
Chris Murphy
