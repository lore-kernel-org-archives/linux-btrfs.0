From: Chris Mason <chris.mason@oracle.com>
Subject: Re: postgresql activity causes crash, 2.6.36.1
Date: Thu, 11 Nov 2010 17:07:45 -0500
Message-ID: <1289513219-sup-5394@think>
References: <225116.26295.qm@web51906.mail.re2.yahoo.com> <1289224688-sup-3338@think> <303125.91065.qm@web51903.mail.re2.yahoo.com> <1289248602-sup-5744@think> <39229.10625.qm@web51905.mail.re2.yahoo.com> <1289260107-sup-5774@think> <434310.21951.qm@web51908.mail.re2.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Brian Neu <proclivity76@yahoo.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <434310.21951.qm@web51908.mail.re2.yahoo.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Brian Neu's message of 2010-11-11 17:05:13 -0500:
> ----- Original Message ----
> 
> > From: Chris Mason <chris.mason@oracle.com>
> 
> > Great, this is a known bug in the O_DIRECT code.  I'll fix it  up
> > tomorrow morning.
> 
> 
> At the risk of sounding like the non-contributing, annoying moocher that I am, I 
> thought I'd check on the status of this bug.

Not at all, sorry for the delay I got caught up in hunting for the
transparent hugepages bug (which wasn't in transparent hugepages in the
end).

I'm working on the O_DIRECT stuff tonight.

-chris
