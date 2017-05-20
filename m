Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:36272 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750760AbdETQYc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 May 2017 12:24:32 -0400
Received: by mail-qk0-f179.google.com with SMTP id u75so80923689qka.3
        for <linux-btrfs@vger.kernel.org>; Sat, 20 May 2017 09:24:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e290752e-55bd-22f2-6eca-37de0fc77e32@bouton.name>
References: <20170519133835.27843-1-nefelim4ag@gmail.com> <20170519133835.27843-3-nefelim4ag@gmail.com>
 <6a1f17d5-3cc8-f5c0-36af-39b41eebc426@bouton.name> <d42097e1-2deb-eb2a-9cae-ad9aa8725bde@bouton.name>
 <CAGqmi75+vNVsz1CjOVhrhmvBCQAK82Cs0G899Jzw3fr2s5Sifg@mail.gmail.com> <e290752e-55bd-22f2-6eca-37de0fc77e32@bouton.name>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sat, 20 May 2017 19:23:51 +0300
Message-ID: <CAGqmi74d_G4pOSKJC3TrNWyB5qmCZE9AG-ugwAB8Dd=9mA-MQQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] Btrfs: lzo compression must free at least PAGE_SIZE
To: Lionel Bouton <lionel-subscription@bouton.name>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-05-20 18:47 GMT+03:00 Lionel Bouton <lionel-subscription@bouton.name>:
> Le 19/05/2017 à 23:15, Timofey Titovets a écrit :
>> 2017-05-19 23:19 GMT+03:00 Lionel Bouton
>> <lionel-subscription@bouton.name>:
>>> I was too focused on other problems and having a fresh look at what I
>>> wrote I'm embarrassed by what I read. Used pages for a given amount
>>> of data should be (amount / PAGE_SIZE) + ((amount % PAGE_SIZE) == 0 ?
>>> 0 : 1) this seems enough of a common thing to compute that the kernel
>>> might have a macro defined for this.
>> If i understand the code correctly, the logic of comparing the size of
>> input/output by bytes is enough (IMHO)
>
> As I suspected I missed context : the name of the function makes it
> clear it is supposed to work on whole pages so you are right about the
> comparison.
>
> What I'm still unsure is if the test is at the right spot. The inner
> loop seems to work on at most
> in_len = min(len, PAGE_SIZE)
> chunks of data,
> for example on anything with len >= 4xPAGE_SIZE and PAGE_SIZE=4096 it
> seems to me there's a problem.
>
> if·(tot_in·>·8192·&&·tot_in·<·tot_out·+·PAGE_SIZE)
>
> tot_in > 8192 is true starting at the 3rd page being processedin my example
>
> If the 3 first pages don't manage to free one full page (ie the function
> only reaches at best a 2/3 compression ratio) the modified second
> condition is true and the compression is aborted. This even if
> continuing the compression would end up in freeing one page (tot_out is
> expected to rise slower than tot_in on compressible data so the
> difference could rise and reach a full PAGE_SIZE).
>
> Am I still confused by something ?
>
> Best regards,
>
> Lionel

You right, size must be checked after all data are already comressed,
so i will fix that and update patch set, thanks

-- 
Have a nice day,
Timofey.
