Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:29013 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750968Ab3LKQP6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 11:15:58 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Feature Req: "mkfs.btrfs -d dup" option on single device
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131211080902.GI9738@carfax.org.uk>
Date: Wed, 11 Dec 2013 09:15:54 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <D5C5F771-D9FF-4EFB-BEBA-7EC9F123922A@colorremedies.com>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com> <01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com> <CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com> <F3B190DB-922A-412F-853D-71260549EF7F@colorremedies.com> <CAK5rZE6DVC5kYAU68oCjjzGPS4B=nRhOzATGM-5=m1_bW4GG6g@mail.gmail.com> <B4C47427-3A7F-4ED8-85AA-FA8E17C39EF9@colorremedies.com> <CAK5rZE6G0WDf6rxjS7o9Cggq-CehASG1ge4bLnJm=SmHA40new@mail.gmail.com> <6FD125A9-7975-4C34-88C7-95B11A39D054@colorremedies.com> <20131211080902.GI9738@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 11, 2013, at 1:09 AM, Hugo Mills <hugo@carfax.org.uk> wrote:

>   That documentation needs tweaking. You need --mixed/-M for larger
> filesystems than that. It's hard to say exactly where the optimal
> boundary is, but somewhere around 16 GiB seems to be the dividing
> point (8 GiB is in the "mostly going to cause you problems without it"
> area). 16 GiB is what we have on the wiki, I think.

Yes, man mkfs.btrfs also doesn't list dup as a possible option for -d.


Chris Murphy
