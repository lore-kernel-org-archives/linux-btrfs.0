Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f182.google.com ([209.85.128.182]:38010 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3LKPbi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 10:31:38 -0500
Received: by mail-ve0-f182.google.com with SMTP id jy13so6156063veb.13
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 07:31:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <l89rin$edg$1@ger.gmane.org>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com>
	<01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com>
	<CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com>
	<F3B190DB-922A-412F-853D-71260549EF7F@colorremedies.com>
	<CAK5rZE6DVC5kYAU68oCjjzGPS4B=nRhOzATGM-5=m1_bW4GG6g@mail.gmail.com>
	<B4C47427-3A7F-4ED8-85AA-FA8E17C39EF9@colorremedies.com>
	<CAK5rZE6G0WDf6rxjS7o9Cggq-CehASG1ge4bLnJm=SmHA40new@mail.gmail.com>
	<l89rin$edg$1@ger.gmane.org>
Date: Wed, 11 Dec 2013 17:31:37 +0200
Message-ID: <CAK5rZE765BJay=v+vgPfeSORU60Bj3KzU9-BrYQAvMpZgbE8kg@mail.gmail.com>
Subject: Re: Feature Req: "mkfs.btrfs -d dup" option on single device
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> What's more (in relation to our long term data integrity aim)
>> order of magnitude for their unpowered data retension period is
>> 1 YEAR. (Read it as 6months to 2-3 years.

> Does btrfs need to date-stamp each block/chunk to ensure that data is
> rewritten before suffering flash memory bitrot?
> Is not the firmware in SSDs aware to rewrite any too-long unchanged data?

No. It is supposed to handled by firmware. That's why they should be
powered. It is not visible to the file system.
You can do a google search with terms "ssd data retension".

There is no concrete info about it. But figures range from:
- 10 years retention for new devices to
- 3-6 months for devices at their 'rated' usage.

Seems there is consensus about 1 year.  And it seems
SSD vendors are close to the datacenters.

Its todays tech. In time we'll see if it will get better or worse.

In the long run, we may have no choice but to put all our data
in the hands of belowed cloud lords. Hence the NSA. :)

Note that Sony has shutdown its optical disc unit.

Regards,
Imran
