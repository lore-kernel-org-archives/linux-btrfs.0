Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:34015 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753901Ab3HaR1X convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Aug 2013 13:27:23 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: snapshot space available
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <61a5f306-c063-4428-9842-b10de392599f@email.android.com>
Date: Sat, 31 Aug 2013 11:27:15 -0600
Cc: Clemens Eisserer <linuxhippy@gmail.com>, linux-btrfs@vger.kernel.org
Message-Id: <81115090-5E86-434C-B189-29F315B7A708@colorremedies.com>
References: <201308262335.25871.russell@coker.com.au> <CAFvQSYSgAPZkYUPF-pqSTGAQpHWAG7NDjBiJhwdxhsEqxSR+nA@mail.gmail.com> <5FA1D778-230D-4EB5-B7C9-537ABFFC9EAA@colorremedies.com> <708D6B3A-EF66-4978-A856-7D01B2687083@colorremedies.com> <61a5f306-c063-4428-9842-b10de392599f@email.android.com>
To: Russell Coker <russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 31, 2013, at 3:04 AM, Russell Coker <russell@coker.com.au> wrote:

> How would I determine when this situation is approaching?  On all important systems I have cron jobs and nagios checks to determine via df when thw file system is about to run out of space. How do I do the same for this condition? 

I don't think it's possible to infer this condition from a single command.

However, if you look at only 'btrfs fi show', a small difference between size and used could be used as a trigger for a partial balance operation to avoid the condition. 

What's a small difference? I'd say at least 2GB, or the size of the maximum expected file size + 2GB. That way a single write operation doesn't end up causing all free space to be allocated for data, leaving no more free space to be allocated for metadata.

Chris Murphy