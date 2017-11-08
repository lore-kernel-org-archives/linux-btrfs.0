Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:53052 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbdKHRRa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Nov 2017 12:17:30 -0500
Received: by mail-ot0-f181.google.com with SMTP id 18so2908530oty.9
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Nov 2017 09:17:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e590a036-f5ba-d8d5-7b7f-c14e15b0b5ee@gmail.com>
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
 <9871a669-141b-ac64-9da6-9050bcad7640@cn.fujitsu.com> <f6428a81-6fc8-1a73-0151-d13dd550c277@rqc.ru>
 <bb12a331-1fec-448a-cbf8-881b434766e7@cn.fujitsu.com> <CAJyZh6RxKuMukM-vCd=_u_8y38MJO_oUG1nYFpaxBroeK8xpAQ@mail.gmail.com>
 <CAH=dxU4OV6tQ0hCy_0Ug7eqkOM7HTUWTKjAr4qg+uO2gVxk2Jw@mail.gmail.com>
 <CAJCQCtS9BPZn-hnS+wP7Eu3oHQP_tS8EEM4j4FQDwRmzcFH+_A@mail.gmail.com>
 <CAH=dxU4MOWGZ0JSZ-ZV004p5EnH_aOnZ7XEo2rSOmbXJZJmwBA@mail.gmail.com>
 <CAJCQCtTOefBfRpfb0h1H6SQxzGd9j-7ZSM07iA37xhy3+Lm=fw@mail.gmail.com>
 <CAH=dxU61J94HCnr+UUokBsxqNMjKQBdz8xE2WNbWAHOtKP4w0w@mail.gmail.com>
 <2164b4b2-1447-3670-73ae-465404754b87@gmail.com> <CAJCQCtQk4tZ7hVD-1T+TiFKQ9uX5eyBJvwkJoZ+Sxpo=gq3tHQ@mail.gmail.com>
 <e590a036-f5ba-d8d5-7b7f-c14e15b0b5ee@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 8 Nov 2017 10:17:28 -0700
Message-ID: <CAJCQCtRq783s=KgF6XPySva=OvhgLDfmsP_VFCtygmhe2Pr-tg@mail.gmail.com>
Subject: Re: Problem with file system
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 8, 2017 at 5:13 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

>> It definitely does fix ups during normal operations. During reads, if
>> there's a UNC or there's corruption detected, Btrfs gets the good
>> copy, and does a (I think it's an overwrite, not COW) fixup. Fixups
>> don't just happen with scrubbing. Even raid56 supports these kinds of
>> passive fixups back to disk.
>
> I could have sworn it didn't rewrite the data on-disk during normal usage.
> I mean, I know for certain that it will return the correct data to userspace
> if at all possible, but I was under the impression it will just log the
> error during normal operation.

No, everything except raid56 has had it since a long time, I can't
even think how far back, maybe even before 3.0. Whereas raid56 got it
in 4.12.



-- 
Chris Murphy
