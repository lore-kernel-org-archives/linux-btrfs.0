Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:58528 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752883AbaJQPBx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 11:01:53 -0400
Received: from cablepool1-225.stoweaccess.com ([199.188.178.225]:53713 helo=[192.168.2.7])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Xf92N-002l79-KW
	for linux-btrfs@vger.kernel.org; Fri, 17 Oct 2014 09:01:52 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: unexplainable corruptions 3.17.0
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20141016091726.GA582640@mother.pipebreaker.pl>
Date: Fri, 17 Oct 2014 11:01:51 -0400
Message-Id: <2103F075-0D7A-4BF7-AC3B-1A1C7A101E27@colorremedies.com>
References: <20141016091726.GA582640@mother.pipebreaker.pl>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 16, 2014, at 5:17 AM, Tomasz Torcz <tomek@pipebreaker.pl> wrote:
> 
>  Broken files are in /var/log/journal directory. This directory
> is set NOCOW with chattr, all the files within too.
> 
> Example of broken file:
> system@0005057fe87730cf-6d3d85ed59bd70ae.journal~

What do you get for 'journalctl --verify' ? I'm curious if any journal files are considered corrupt by journalctl, and if there's parity between journalctl and dd_rescue when it comes to good/bad journals.

> 
> When read with dd_rescue, there are many I/O errors
> reported, the summary looks like that (x = error):
>> -..-..xxxxxxxxx---x.-..-..-...-..-..-...-< 100%
> 
>  Reads with cat, hexdump fails with:
> read(4, 0x1001000, 65536)               = -1 EIO (Input/output error)

Yeah weird, I'd expect in any case that there'd be a kernel message, whether it's a Btrfs or hardware problem.

Chris Murphy

