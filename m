Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:54157 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751407AbaAFATQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 19:19:16 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:52544 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1VzxuW-001g2Q-Je
	for linux-btrfs@vger.kernel.org; Sun, 05 Jan 2014 17:19:16 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs-transaction blocked for more than 120 seconds
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <82B00B7C-0767-44E2-95A5-309D80D789F1@colorremedies.com>
Date: Sun, 5 Jan 2014 17:19:15 -0700
Message-Id: <29603847-5C15-4135-B117-E8C2C5696708@colorremedies.com>
References: <52C2AE7C.5020601@gmx.at> <64E70864-9830-4145-9EDF-F53A79977999@colorremedies.com> <52C9CBEF.2000309@gmx.at> <52C9DE66.8080706@swiftspirit.co.za> <82B00B7C-0767-44E2-95A5-309D80D789F1@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 5, 2014, at 5:15 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Jan 5, 2014, at 3:36 PM, Brendan Hide <brendan@swiftspirit.co.za> wrote:
> 
>> WD Greens (Reds too, for that matter) have poor non-sequential performance. An educated guess I'd say there's a 15% chance this is a major factor to the problem and, perhaps, a 60% chance it is merely a "small contributor" to the problem. Greens are aimed at consumers wanting high capacity and a low pricepoint. The result is poor performance. See footnote * re my experience.
>> 
>> My general recommendation (use cases vary of course) is to install a tiny SSD (60GB, for example) just for the OS. It is typically cheaper than the larger drives and will be *much* faster. WD Greens and Reds have good *sequential* throughput but comparatively abysmal random throughput even in comparison to regular non-SSD consumer drives.
> 
> 
> Another thing with md raid and parallel flie systems that's been an issue is cqf.

Oops, CFQ!

Chris Murphy

