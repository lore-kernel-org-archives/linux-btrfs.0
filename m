Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp121.ord1c.emailsrvr.com ([108.166.43.121]:37479 "EHLO
        smtp121.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751971AbdJaF5o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 01:57:44 -0400
Subject: Re: Problem with file system
To: Chris Murphy <lists@colorremedies.com>, Dave <davestechshop@gmail.com>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>,
        Fred Van Andel <vanandel@gmail.com>
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
 <9871a669-141b-ac64-9da6-9050bcad7640@cn.fujitsu.com>
 <f6428a81-6fc8-1a73-0151-d13dd550c277@rqc.ru>
 <bb12a331-1fec-448a-cbf8-881b434766e7@cn.fujitsu.com>
 <CAJyZh6RxKuMukM-vCd=_u_8y38MJO_oUG1nYFpaxBroeK8xpAQ@mail.gmail.com>
 <CAH=dxU4OV6tQ0hCy_0Ug7eqkOM7HTUWTKjAr4qg+uO2gVxk2Jw@mail.gmail.com>
 <CAJCQCtS9BPZn-hnS+wP7Eu3oHQP_tS8EEM4j4FQDwRmzcFH+_A@mail.gmail.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <10fb0b92-bc93-a217-0608-5284ac1a05cd@rqc.ru>
Date: Tue, 31 Oct 2017 08:57:42 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS9BPZn-hnS+wP7Eu3oHQP_tS8EEM4j4FQDwRmzcFH+_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 31/10/17 00:37, Chris Murphy wrote:
> But off hand it sounds like hardware was sabotaging the expected write
> ordering. How to test a given hardware setup for that, I think, is
> really overdue. It affects literally every file system, and Linux
> storage technology.
>
> It kinda sounds like to me something other than supers is being
> overwritten too soon, and that's why it's possible for none of the
> backup roots to find a valid root tree, because all four possible root
> trees either haven't actually been written yet (still) or they've been
> overwritten, even though the super is updated. But again, it's
> speculation, we don't actually know why your system was no longer
> mountable.
Just a detached view: I know hardware should respect ordering/barriers 
and such, but how hard is it really to avoid overwriting at least one 
complete metadata tree for half an hour (even better, yet another one 
for a day)? Just metadata, not data extents.

--

With Best Regards,
Marat Khalili
