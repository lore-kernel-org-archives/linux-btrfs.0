Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:43263 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751353Ab3KTKQa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 05:16:30 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:51647 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Vj4pg-003hL8-PL
	for linux-btrfs@vger.kernel.org; Wed, 20 Nov 2013 03:16:29 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Actual effect of mkfs.btrfs -m raid10 </dev/sdX> ... -d raid10 </dev/sdX> ...
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <l6hl6b$i5h$1@ger.gmane.org>
Date: Wed, 20 Nov 2013 03:16:27 -0700
Message-Id: <29AD6F50-2D7B-416C-AA69-0EC8D46E8BB8@colorremedies.com>
References: <CAEWPe=pwpxdYUDk7BzfjR8h-Jq9wtQE+gxxQChjOZzsXJO4vHQ@mail.gmail.com> <20131119090602.GV4315@carfax.org.uk> <pan$cd41e$ced598aa$e5d2ed3a$3c71af6f@cox.net> <l6hl6b$i5h$1@ger.gmane.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 19, 2013, at 11:35 PM, Martin <m_btrfs@ml1.co.uk> wrote:

> On 19/11/13 23:16, Duncan wrote:
> 
>> So we have:
>> 
>> 1) raid1 is exactly two copies of data, paired devices.
>> 
>> 2) raid0 is a stripe exactly two devices wide (reinforced by to read a 
>> stripe takes only two devices), so again paired devices.
> 
> Which is fine for some occasions and a very good start point.
> 
> However, I'm sure there is a strong wish to be able to specify n-copies
> of data/metadata spread across m devices. Or even to specify 'hot spares'.

Hot spares are worse than useless. Especially for raid10. The drive takes up space doing nothing but suck power, rather than adding space or performance. Somehow this idea comes from cheap companies who seem to think their data is so valuable they need hot spares, yet they don't have 24/7 staff on hand to do a hot swap. (As if the only problem that can occur is a dead drive.) So I think those companies can develop this otherwise unneeded feature.

n-copies raid1 is a good idea and I think it's being worked on.


Chris Murphy