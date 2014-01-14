Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42905 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751722AbaANRRZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 12:17:25 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:49638 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W37c8-002pvC-4o
	for linux-btrfs@vger.kernel.org; Tue, 14 Jan 2014 10:17:21 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfsck does not fix
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$8a0dd$9f46c908$89053e7c$efd0a239@cox.net>
Date: Tue, 14 Jan 2014 10:17:19 -0700
Message-Id: <C8D65D2E-6D7D-4E4A-A649-F092A624943D@colorremedies.com>
References: <52C7127F.3060902@friedels.name> <6E517D5F-B921-47E7-82E7-27865077C43D@colorremedies.com> <52C87B67.1040503@friedels.name> <F9C2788F-B057-4C3F-A490-8F8A19C37F97@colorremedies.com> <52CC65C9.3090605@friedels.name> <52D08812.3040707@friedels.name> <0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com> <52D317CF.2070007@friedels.name> <EDD506BE-1DAC-4C2C-9FF4-184180315557@colorremedies.com> <pan$e93a4$196236e0$f9702991$6860b33e@cox.net> <4A0D47A5-0FBC-488E-83E9-311FE89DBB03@colorremedies.com> <pan$8a0dd$9f46c908$89053e7c$efd0a239@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 14, 2014, at 2:30 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> I wonder if it compresses?

-c 9 is max compression although I don't know what algorithm btrfs-image uses off hand. If I use xz on it, 193MB becomes 192MB.


Chris Murphy

