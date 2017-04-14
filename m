Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:35944 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753074AbdDNQ4b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Apr 2017 12:56:31 -0400
Received: by mail-qk0-f180.google.com with SMTP id d131so71242563qkc.3
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Apr 2017 09:56:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$29c2d$faf1fff7$a4518780$dbb0b61@cox.net>
References: <CAFKQ2Bs9-=serb7F-PHDVNQ-X2AXcWPG5jBs9xKXTKkTQ59O7Q@mail.gmail.com>
 <pan$29c2d$faf1fff7$a4518780$dbb0b61@cox.net>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Fri, 14 Apr 2017 09:56:30 -0700
Message-ID: <CAN05THTcoQ6zLrDaVmoZ=pUQ3oMxU8EvYrz8TcUGOAo6a=5qHw@mail.gmail.com>
Subject: Re: Encountered kernel bug#72811. Advice on recovery?
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 13, 2017 at 8:47 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Ank Ular posted on Thu, 13 Apr 2017 14:49:41 -0400 as excerpted:
...
> OK, I'm one of the ones that's going to "go off" on you, but FWIW, I
> expect pretty much everyone else would pretty much agree.  At least you
> do have backups. =:^)
>
> I don't think you appreciate just how bad raid56 is ATM.  There are just
> too many REALLY serious bugs like the one you mention with it, and it's
> actively NEGATIVELY recommended here as a result.  It's bad enough with
> even current kernels, and the problems are well known enough to the devs,
> that there's really not a whole lot to test ATM...

Can we please hide the ability to even create any new raid56
filesystems behind a new flag :

--i-accept-total-data-loss

to make sure that folks are prepared for how risky it currently is.
That should be an easy patch to the userland utilities.
