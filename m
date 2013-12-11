Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f173.google.com ([209.85.128.173]:35665 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3LKARm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 19:17:42 -0500
Received: by mail-ve0-f173.google.com with SMTP id oz11so5378402veb.4
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Dec 2013 16:17:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAK5rZE6DVC5kYAU68oCjjzGPS4B=nRhOzATGM-5=m1_bW4GG6g@mail.gmail.com>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com>
	<01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com>
	<CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com>
	<F3B190DB-922A-412F-853D-71260549EF7F@colorremedies.com>
	<CAK5rZE6DVC5kYAU68oCjjzGPS4B=nRhOzATGM-5=m1_bW4GG6g@mail.gmail.com>
Date: Wed, 11 Dec 2013 02:17:41 +0200
Message-ID: <CAK5rZE6nTwimG=na36eG_S_+AeK_HX0DPD4ycGrCtbyvKSy5Kg@mail.gmail.com>
Subject: Fwd: Feature Req: "mkfs.btrfs -d dup" option on single device
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: lists@colorremedies.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---------- Forwarded message ----------
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Wed, 11 Dec 2013 02:14:25 +0200
Subject: Re: Feature Req: "mkfs.btrfs -d dup" option on single device
To: Chris Murphy <lists@colorremedies.com>

> Current btrfs-progs is v3.12. 0.19 is a bit old. But yes, looks like the
> wiki also needs updating.

> Anyway I just tried it on an 8GB stick and it works, but -M (mixed
> data+metadata) is required, which documentation also says incurs a
> performance hit, although I'm uncertain of the significance.

btrfs-tools 0.19+20130705 is the most recent one on Debian's
leading edge Sid/Unstable.

Given the state of the docs probably very few or no people ever used
'-d dup'. As being the lead developer, is it possible for you to
provide some insights for the reliability of this option?

Can '-M' requirement be an indication of code which has not been
ironed out, or is it simply a constraint of the internal machinery?

How well does the main idea of "Guaranteed Data Integrity
for extra reliability" and the option "-d dup" in its current state match?

Regards,
Imran
