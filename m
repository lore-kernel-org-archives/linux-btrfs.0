Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53160 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754033AbaEIQTp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 12:19:45 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:59777 helo=[192.168.1.120])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WinWT-0001Ey-0X
	for linux-btrfs@vger.kernel.org; Fri, 09 May 2014 10:19:45 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: URGENT: my laptop's boot ssd btrfs crashed, what do you need off it?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAKhhfD5DTPfKvWcRDERxWa_pjfhCkZxW3WBtznYC94EFy7A0mQ@mail.gmail.com>
Date: Fri, 9 May 2014 10:19:46 -0600
Message-Id: <423AB9BE-EDBF-478B-8CED-C1A9A0FAE736@colorremedies.com>
References: <20140507233959.GB11401@merlins.org> <536AD20E.70004@fb.com> <20140508004344.GE11401@merlins.org> <20140508013440.GH11401@merlins.org> <CAKgsxVR=6GTesbtqG_SAyKnpw9pxz1TZ0oOi_MB8Ej3j4-vMiw@mail.gmail.com> <20140508220242.GO11401@merlins.org> <CAKhhfD5DTPfKvWcRDERxWa_pjfhCkZxW3WBtznYC94EFy7A0mQ@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 9, 2014, at 4:35 AM, Marc MERLIN <marc@merlins.org> wrote:

> 
> Howdy,
> 
> I won't have the time to rebuild my laptop tonight, so I'll wait one more
> day to see if anyone would like data from that fs to see why it crashed and
> why btrfs recovery doesn't even seem able to open it.

There's some underlying reason why it went read only, but we don't have those messages. The message we do have says the kernel is already tainted, so something (possibly entirely unrelated) happened earlier.


> Also I'm not sure if I should risk 3.15rc to rebuild the filesystem and I'd
> love not to have to say during my talk that even almost latest btrfs
> corrupts itself without reason and working recovery methods :-/

Just because the reason isn't yet known or understood yet doesn't mean it's happened without reason. And we also don't know whether it corrupted itself, or had help earlier on. Neither is good, but depending on the cause of the corruption, recovery may not even be realistic.

I'd probably consider 3.13.11 if I simply had work that needs to get done rather than testing. If the problem happens there too then you've stumbled on something that isn't likely a regression.

If you've done any suspend/hibernate at all, I'd stop doing that until you're in a position to do a lot more rigorous testing. I say that because suspend and hibernate have become so completely unreliable for so many people I know doing testing, including myself, that it's worth avoiding. I've had lots of corruptions, not just Btrfs, related to suspend testing in particular (hibernate doesn't work either but it hasn't corrupted the file system). And there's a bunch of new work happening on suspend in 3.15 so things are probably about to change yet again.


Chris Murphy