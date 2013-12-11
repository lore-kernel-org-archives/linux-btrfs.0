Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36853 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab3LKOHm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 09:07:42 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VqkRx-0004qN-BK
	for linux-btrfs@vger.kernel.org; Wed, 11 Dec 2013 15:07:41 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 15:07:41 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 15:07:41 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Feature Req: "mkfs.btrfs -d dup" option on single device
Date: Wed, 11 Dec 2013 14:07:30 +0000
Message-ID: <l89rin$edg$1@ger.gmane.org>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com> <01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com> <CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com> <F3B190DB-922A-412F-853D-71260549EF7F@colorremedies.com> <CAK5rZE6DVC5kYAU68oCjjzGPS4B=nRhOzATGM-5=m1_bW4GG6g@mail.gmail.com> <B4C47427-3A7F-4ED8-85AA-FA8E17C39EF9@colorremedies.com> <CAK5rZE6G0WDf6rxjS7o9Cggq-CehASG1ge4bLnJm=SmHA40new@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <CAK5rZE6G0WDf6rxjS7o9Cggq-CehASG1ge4bLnJm=SmHA40new@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/12/13 03:19, Imran Geriskovan wrote:

SSDs:

> What's more (in relation to our long term data integrity aim)
> order of magnitude for their unpowered data retension period is
> 1 YEAR. (Read it as 6months to 2-3 years. While powered they
> refresh/shuffle the blocks) This makes SSDs
> unsuitable for mid-to-long tem consumer storage. Hence they are
> out of this discussion. (By the way, the only way for reliable
> duplication on SSDs, is using physically seperate devices.)

Interesting...

Have you any links/quotes/studies/specs for that please?


Does btrfs need to date-stamp each block/chunk to ensure that data is
rewritten before suffering flash memory bitrot?

Is not the firmware in SSDs aware to rewrite any too-long unchanged data?


Regards,
Martin

