Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42940 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753187AbaF0Pws convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 11:52:48 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:57653 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1X0YSF-001Hx3-TK
	for linux-btrfs@vger.kernel.org; Fri, 27 Jun 2014 09:52:48 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Blocked tasks on 3.15.1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAGfcS_khFRS3nMOtAD7srzHg6Q73LF1iogEzTy4YH1KW=qEu0g@mail.gmail.com>
Date: Fri, 27 Jun 2014 09:52:46 -0600
Message-Id: <4623589E-3298-4980-A257-665CFA9FB61B@colorremedies.com>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com> <pan$81d96$8a4effae$94572f09$472a11ff@cox.net> <CAGfcS_khFRS3nMOtAD7srzHg6Q73LF1iogEzTy4YH1KW=qEu0g@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 27, 2014, at 9:14 AM, Rich Freeman <r-btrfs@thefreemanclan.net> wrote:

> On Fri, Jun 27, 2014 at 9:06 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Hopefully that problem's fixed on 3.16-rc2+, but as of yet there's not
>> enough 3.16-rc2+ reports out there from folks experiencing issues with
>> 3.15 blocked tasks to rightfully say.
> 
> Any chance that it was backported to 3.15.2?  I'd rather not move to
> mainline just for btrfs.

The backports don't happen that quickly. I'm uncertain about specifics but I think many such fixes need to be demonstrated in mainline before they get backported to stable.


> 
> I got another block this morning and failed to capture a log before my
> terminals gave out.  I switched back to 3.15.0 for the moment, and
> we'll see if that fares any better. 

Yeah I'd start going backwards. The idea of going forwards is to hopefully get you unstuck or extract data where otherwise you can't, it's not really a recommendation for production usage. It's also often useful if you can reproduce the block with a current rc kernel and issue sysrq+w and post that. Then do your regression with an older kernel.

Chris Murphy