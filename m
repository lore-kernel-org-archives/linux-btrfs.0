Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:51790 "EHLO
        smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752362AbdKDMAn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 4 Nov 2017 08:00:43 -0400
Date: Sat, 04 Nov 2017 15:00:33 +0300
In-Reply-To: <20171104044634.thg7mnchm4hvzdic@angband.pl>
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com> <9871a669-141b-ac64-9da6-9050bcad7640@cn.fujitsu.com> <f6428a81-6fc8-1a73-0151-d13dd550c277@rqc.ru> <bb12a331-1fec-448a-cbf8-881b434766e7@cn.fujitsu.com> <CAJyZh6RxKuMukM-vCd=_u_8y38MJO_oUG1nYFpaxBroeK8xpAQ@mail.gmail.com> <CAH=dxU4OV6tQ0hCy_0Ug7eqkOM7HTUWTKjAr4qg+uO2gVxk2Jw@mail.gmail.com> <CAJCQCtS9BPZn-hnS+wP7Eu3oHQP_tS8EEM4j4FQDwRmzcFH+_A@mail.gmail.com> <10fb0b92-bc93-a217-0608-5284ac1a05cd@rqc.ru> <b32358ec-781e-aff6-439b-3fc6fe02a25c@gmail.com> <CAJCQCtTT7_pfx5yn--We-kq0XWd38H_Lw1Prbmo5ytkTZWapYQ@mail.gmail.com> <20171104044634.thg7mnchm4hvzdic@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: Problem with file system
To: Adam Borowski <kilobyte@angband.pl>,
        Chris Murphy <lists@colorremedies.com>
CC: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>,
        Fred Van Andel <vanandel@gmail.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <8C6E9A02-E1C2-4BD3-92CC-D4F8B0D3E14B@rqc.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>How is this an issue?  Discard is issued only once we're positive 
>there's no 
>reference to the freed blocks anywhere.  At that point, they're also 
>open 
>for reuse, thus they can be arbitrarily scribbled upon.

Point was, how about keeping this reference for some time period?

>Unless your hardware is seriously broken (such as lying about barriers, 
>which is nearly-guaranteed data loss on btrfs anyway), there's no way 
>the 
>filesystem will ever reference such blocks.

Buggy hardware happen. So do buggy filesystems ;) Besides, most filesystems let user recover most data after losing just one sector, would be pity if BTRFS with all its COW coolness didn't. 

>Why would you special-case metadata?  Metadata that points to 
>overwritten or 
>discarded blocks is of no use either.

It takes significant time to overwrite noticeable portion of data on disk, but loss of metadata makes it gone in a moment. Moreover, user is usually prepared to lose some recently changed data in crash, but not the one that it didn't even touch.
-- 

With Best Regards,
Marat Khalili
