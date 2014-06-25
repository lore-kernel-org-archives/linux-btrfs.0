Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47274 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751087AbaFYSzh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 14:55:37 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49853 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WzsM5-002QPo-1K
	for linux-btrfs@vger.kernel.org; Wed, 25 Jun 2014 12:55:37 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs data dup on single device?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140625074713.GE31096@carfax.org.uk>
Date: Wed, 25 Jun 2014 12:55:36 -0600
Message-Id: <E167B73E-CE42-459E-9171-C9CF1D001D79@colorremedies.com>
References: <CACQTm-go5jGan9kP-dVq7Oi4b+AGWuFkb0Nudc2i9V1SG-oc3Q@mail.gmail.com> <20140625074713.GE31096@carfax.org.uk>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 25, 2014, at 1:47 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
>   The question is, why? If you have enough disk media errors to make
> it worth using multiple copies, then your storage device is basically
> broken and needs replacing, and it can't really be relied on for very
> much longer.

Yeah basically -d dup tells me the user believes "I do not trust the media that much". Specifically they believe the media surface variability is what they are suspicious of, not the read/write head, actuator, or spindle, or motor. And a.) I don't know how they can possibly have reliable information to arrive at this kind of suspicion; b.) why bother with such crap hardware?

Chris Murphy

