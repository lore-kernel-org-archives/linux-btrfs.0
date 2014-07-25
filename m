Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:57028 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaGYDGf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 23:06:35 -0400
Received: by mail-vc0-f176.google.com with SMTP id id10so6428532vcb.7
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 20:06:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$aa09d$75e2870b$4abbbcef$7f21a37d@cox.net>
References: <1502954.OtX3SzjMKZ@merkaba>
	<1809953.ithLVmijbn@merkaba>
	<53D11F2B.1070008@fb.com>
	<1557956.045aK4K0qS@merkaba>
	<pan$aa09d$75e2870b$4abbbcef$7f21a37d@cox.net>
Date: Thu, 24 Jul 2014 23:06:34 -0400
Message-ID: <CAPDOMVhXL2nS8BDbwfhZpBehE2Tmb7wo3iK45KKqK38n9YzF2A@mail.gmail.com>
Subject: Re: BTRFS hang with 3.16-rc5 (and also with 3.16-rc4)
From: Nick Krause <xerofoify@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 24, 2014 at 10:32 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Martin Steigerwald posted on Thu, 24 Jul 2014 20:49:37 +0200 as excerpted:
>
>> It may take some time tough cause during compiling the kernel BTRFS hung
>> again, which caused loss of KDE Baloo desktop search file index and
>> parts of a mail I wrote in KMail.
>
> Heh.  While I do run a kde(-lite) desktop, at least I don't have those
> problems to deal with.  As a gentooer I have the option to build kde
> without the semantic-desktop junk and I've taken that option, so no baloo
> or the like here.  And after the akonadified kmail lost one too many
> mails and I was going to need to reset the data store to retrieve them
> once again, I asked myself why I was putting up with it, after all, email
> is a decades old technology that should NOT be rocket-science any longer,
> and soon enough I was NOT putting up with it any longer, as I'd switched
> to claws-mail.  Actually, killing with fire kdepim and anything akonadi
> related was what allowed me to kill semantic-desktop as well instead of
> just run-time disabling it, since akonadi is part of the steaming pile.
>
> And claws-mail has this nice option I didn't even know could be done on
> pop3 mail servers, too.  It downloads the mail for local reading, but
> keeps it on the server for a week (configurable) before final pop3 server-
> side deletion, just in case you do crash after download and lose the
> local copy.  I've not actually had to take advantage of that feature yet,
> but it's sure nice to have, just in case. =:^)
>
> Interesting this came up here just now, too, as there's a current xmodulo
> post about baloo and milou in kde4 and the carryover to kde-frameworks5
> and plasma5, too, with an ongoing discussion.
>
> http://xmodulo.com/2014/07/kde-semantic-desktop-nepomuk-baloo.html
>
> So fortunately, while I am a development version tester for of both kde
> and btrfs, the akonadi and semantic-desktop steaming-pile-of-.... is not
> something I have to worry about the stability of (or more precisely the
> lack thereof), while also testing a not yet fully stable btrfs at the
> same time.  Hopefully that'll continue to be the case in the claimed more
> modular kde-frameworks-5 era, because there's more than one way to ensure
> that I don't have to deal with that pile, and just as I suddenly found
> some other option for mail after using kmail since the kde2 era when it
> semantic-desktop-integrated without option, so my kde/plasma desktop,
> also since the kde2 era, can find itself going the same route locally,
> should it insist on going the same route globally.
>
> Tho just as I did the akonadified kmail, I'll likely keep an open enough
> mind to try it.  <shrug>  Maybe it'll actually work this time, without
> eating up gigs of indexing space that has to be reset frequently due to
> something going wrong, to do it.  Time will tell...
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hey Duncan and others ,
I have read this and this seems to need some working on.
If you want my help please ask , I am new to the kernel
so I may ask a dumb question or two but if that's fine with
you I have no problem helping out here. I would like
a log of printk statements leading to the hand if that's
not too much work in order for me to trace this back.
Cheers Nick
