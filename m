Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:29241 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751084Ab3LKAeC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 19:34:02 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Feature Req: "mkfs.btrfs -d dup" option on single device
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAK5rZE6DVC5kYAU68oCjjzGPS4B=nRhOzATGM-5=m1_bW4GG6g@mail.gmail.com>
Date: Tue, 10 Dec 2013 17:33:59 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <B4C47427-3A7F-4ED8-85AA-FA8E17C39EF9@colorremedies.com>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com> <01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com> <CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com> <F3B190DB-922A-412F-853D-71260549EF7F@colorremedies.com> <CAK5rZE6DVC5kYAU68oCjjzGPS4B=nRhOzATGM-5=m1_bW4GG6g@mail.gmail.com>
To: Imran Geriskovan <imran.geriskovan@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 10, 2013, at 5:14 PM, Imran Geriskovan <imran.geriskovan@gmail.com> wrote:

>> Current btrfs-progs is v3.12. 0.19 is a bit old. But yes, looks like the
>> wiki also needs updating.
> 
>> Anyway I just tried it on an 8GB stick and it works, but -M (mixed
>> data+metadata) is required, which documentation also says incurs a
>> performance hit, although I'm uncertain of the significance.
> 
> btrfs-tools 0.19+20130705 is the most recent one on Debian's
> leading edge Sid/Unstable.
> 
> Given the state of the docs probably very few or no people ever used
> '-d dup'. As being the lead developer, is it possible for you to
> provide some insights for the reliability of this option?

I'm not a developer, I'm just an ape who wears pants. Chris Mason is the lead developer. All I can say about it is that it's been working for me OK so far.

> Can '-M' requirement be an indication of code which has not been
> ironed out, or is it simply a constraint of the internal machinery?

I think it's just how chunks are allocated it becomes space inefficient to have two separate metadata and data chunks, hence the requirement to mix them if -d dup is used. But I'm not really sure.

> How well does the main idea of "Guaranteed Data Integrity
> for extra reliability" and the option "-d dup" in its current state match?

Well given that Btrfs is still flagged as experimental, most notably when creating any Btrfs file system, I'd say that doesn't apply here. If the case you're trying to mitigate is some kind of corruption that can only be repaired if you have at least one other copy of data, then -d dup is useful. But obviously this ignores the statistically greater chance of a more significant hardware failure, as this is still single device. Not only could the entire single device fail, but it's possible that erase blocks individually fail. And since the FTL decides where pages are stored, the duplicate data/metadata copies could be stored in the same erase block. So there is a failure vector other than full failure where some data can still be lost on a single device even with duplicate, or triplicate copies.


Chris Murphy