Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44972 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760017AbaGYKHX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 06:07:23 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS hang with 3.16-rc5 (and also with 3.16-rc4)
Date: Fri, 25 Jul 2014 12:07:20 +0200
Message-ID: <17377348.Wo7egBKq1U@merkaba>
In-Reply-To: <pan$aa09d$75e2870b$4abbbcef$7f21a37d@cox.net>
References: <1502954.OtX3SzjMKZ@merkaba> <1557956.045aK4K0qS@merkaba> <pan$aa09d$75e2870b$4abbbcef$7f21a37d@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 25. Juli 2014, 02:32:17 schrieb Duncan:
> Martin Steigerwald posted on Thu, 24 Jul 2014 20:49:37 +0200 as excerpted:
> > It may take some time tough cause during compiling the kernel BTRFS hung
> > again, which caused loss of KDE Baloo desktop search file index and
> > parts of a mail I wrote in KMail.
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

Heh, I don´t want to make it a discussion about KDE, but I like to make a few 
points about it:

1) It was kmail save letter feature which saved me from *typing* all of the 
mail again. It still had a previous version open.

2) I didn´t see dataloss in KMail for months.

3) Since the recents developments (running stuff partly from Git) I am quite 
satisfied, IMAP performance / handling improved a lot. Even usable with our 
Exchange server now, and barely noticable with my own Dovecot IMAP setup.


It was a tough ride. It still haves rough edges. But it got a lot better to a 
point I am using it on all my systems again. I failed back to other mail 
clients at work for a moment cause IMAP access was barely usable.

There is still one data loss bug with filtering mails through CRM114 mailfilter 
spamfilter I didn´t dare to retry with most recent versions. But it may have 
been fixed already.

> Interesting this came up here just now, too, as there's a current xmodulo
> post about baloo and milou in kde4 and the carryover to kde-frameworks5
> and plasma5, too, with an ongoing discussion.
> 
> http://xmodulo.com/2014/07/kde-semantic-desktop-nepomuk-baloo.html

Baloo is a ton of a improvement. Only two thing I have with it at the moment 
is:

1) File indexing database is fragile in case of sudden write interruption… but 
here with BTRFS compressed extents corruption it may not even be at fault.

2) Sometimes krunner crashes while entering a search topic.

Other than that I have grown to love the marvellous mail address auto 
completion from all indexed mails, the almost instant full text mail search 
and the almost instant fulltext file search.

I suggest we continues this privately or on a KDE related list like kdepim-
users as its not really BTRFS related.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
