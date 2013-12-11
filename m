Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49253 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751767Ab3LKXc1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 18:32:27 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: SSD data retention, was: "mkfs.btrfs -d dup" option on single device
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <l89rin$edg$1@ger.gmane.org>
Date: Wed, 11 Dec 2013 16:32:23 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <6F5C1A84-52D2-42A9-B7F9-F64F63B98664@colorremedies.com>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com> <01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com> <CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com> <F3B190DB-922A-412F-853D-71260549EF7F@colorremedies.com> <CAK5rZE6DVC5kYAU68oCjjzGPS4B=nRhOzATGM-5=m1_bW4GG6g@mail.gmail.com> <B4C47427-3A7F-4ED8-85AA-FA8E17C39EF9@colorremedies.com> <CAK5rZE6G0WDf6rxjS7o9Cggq-CehASG1ge4bLnJm=SmHA40new@mail.gmail.com> <l89rin$edg$1@ger.gmane.org>
To: Martin <m_btrfs@ml1.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 11, 2013, at 7:07 AM, Martin <m_btrfs@ml1.co.uk> wrote:

> On 11/12/13 03:19, Imran Geriskovan wrote:
> 
> SSDs:
> 
>> What's more (in relation to our long term data integrity aim)
>> order of magnitude for their unpowered data retension period is
>> 1 YEAR. (Read it as 6months to 2-3 years. While powered they
>> refresh/shuffle the blocks) This makes SSDs
>> unsuitable for mid-to-long tem consumer storage. Hence they are
>> out of this discussion. (By the way, the only way for reliable
>> duplication on SSDs, is using physically seperate devices.)
> 
> Interesting...
> 
> Have you any links/quotes/studies/specs for that please?


This is an eye opener:
http://techreport.com/review/25681/the-ssd-endurance-experiment-testing-data-retention-at-300tb

Check page 2's section "Data Retention", which glosses over unpowered data retention. But there's a test on a 200GB hashed file on one of the SSDs that fails checksum. Fails a 2nd time, but with a different checksum. And again with yet a different checksum. Then powered off for five days. And the checksum passes. Isn't that adorable?

What the article doesn't say, that's rather important, is whether the drive reported a read error to the SATA driver. If not, then ECC didn't do it's job, differently, three times. If there was a read error, then that's still not good but distinctly better than the former.

So the issue with unpowered data retention is that the time varies a ton based on wear. The more blocks have been written to or erased, the lower their retention time without power. I think 2-3 years right now is really optimistic seeing as 


> Does btrfs need to date-stamp each block/chunk to ensure that data is
> rewritten before suffering flash memory bitrot?
> 
> Is not the firmware in SSDs aware to rewrite any too-long unchanged data?

My understanding, which may be wrong, is that the drive only needs power. The data doesn't need to be re-written.


Chris Murphy