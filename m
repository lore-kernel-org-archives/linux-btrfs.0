Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59869 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaHJR00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 13:26:26 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Peter Waller <peter@scraperwiki.com>
Cc: Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with mkdir and rename
Date: Sun, 10 Aug 2014 19:26:25 +0200
Message-ID: <2485127.sKlMmAdHLi@merkaba>
In-Reply-To: <CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com> <17833067.mzxAL4oqZq@quad> <CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 4. August 2014, 11:09:23 schrieb Peter Waller:
> On 4 August 2014 10:39, Chris Samuel <chris@csamuel.org> wrote:
> > On Mon, 4 Aug 2014 09:14:19 AM Peter Waller wrote:
> >> All of this is *very* surprising.
> > 
> > Hmm, it shouldn't be, the ENOSPC issues are well known and have been
> > discussed here for years.
> 
> I accept that. It's all very well if you read the BTRFS list and/or
> are a BTRFS developer. But if you're trying to work it out in the heat
> of battle, as we have sysadmins who would have to, there is a
> combination of things here that makes it unreasonable and harmful for
> production.

Well, maybe, just maybe… BTRFS is not yet ready for production use.

I installed it on a server recently, my own VM. And I am expect that I may 
need to fix up things there. And I did it with a *huge* free space margin. And 
still running Debian backport kernel 3.14. Won´t change it to 3.16 until I 
have seen that it runs nicely on my laptop again.

Test it on non critical servers – yes. Use it on critical production servers? 
My answer is a no for this. Despite partial support in SLES 11 SP 2 and 
support (partial?) for it in Oracle Unbreakable Linux.

BTRFS is just not yet there from my current experiences with it.

One thing that may get you covered up usually: Make it five times as large as 
the data you put on it and try to monitor for situation you better rebalance 
in advance.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
