Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39764 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751705AbaAISwJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 13:52:09 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:50584 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W1Ki7-003g5r-Ri
	for linux-btrfs@vger.kernel.org; Thu, 09 Jan 2014 11:52:08 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How does btrfs handle bad blocks in raid1?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52CEE901.1090207@gmail.com>
Date: Thu, 9 Jan 2014 11:52:08 -0700
Message-Id: <DD76DCF3-93B9-4EAF-9732-C703D7C50A74@colorremedies.com>
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com> <20140109104247.GH15634@carfax.org.uk> <pan$ab233$2067aff9$a13049e6$e769dc55@cox.net> <28EF9764-B846-4AB4-AA88-9A37F106B6C6@colorremedies.com> <52CEE901.1090207@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 9, 2014, at 11:22 AM, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:

> On 2014-01-09 13:08, Chris Murphy wrote:
>> 
>> On Jan 9, 2014, at 5:41 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>>> Having checksumming is good, and a second 
>>> copy in case one fails the checksum is nice, but what if they BOTH do?
>>> I'd love to have the choice of (at least) three-way-mirroring, as for me 
>>> that seems the best practical hassle/cost vs. risk balance I could get, 
>>> but it's not yet possible. =:^(
>> 
>> I'm on the fence on n-way. 
>> 
>> HDDs get bigger at a faster rate than their performance improves, so rebuild times keep getting higher. For cases where the data is really important, backup-restore doesn't provide the necessary uptime, and minimum single drive performance is needed, it can make sense to want three copies.
>> 
>> But what's the probability of both drives in a mirrored raid set dying, compared to something else in the storage stack dying? I think at 3 copies, you've got other risks that the 3rd copy doesn't manage, like a power supply, controller card, or logic board dying.
>> 
> The risk isn't as much both drives dying at the same time as one dying
> during a rebuild of the array, which is more and more likely as drives
> get bigger and bigger.

Understood. I'm considering a 2nd drive dying during rebuild (from a 1st drive dying) as essentially simultaneous failures. And in the case of raid10, the likelihood of a 2nd drive failure being the lonesome drive in a mirrored set is statistically very unlikely. The next drive to fail is going to be some other drive in the array, which still has a mirror.

I'm not saying there's no value in n-way. I'm just saying adding more redundancy only solves on particular vector for failure that's still probably less likely than losing a power supply or a controller or even user induced data loss that ends up affecting all three copies anyway.

And yes, it's easier to just add drives and make 3 copies, than it is to setup a cluster. But that's the trade off when using such high density drives that the rebuild times cause consideration of adding even more high density drives to solve the problem. 




Chris Murphy