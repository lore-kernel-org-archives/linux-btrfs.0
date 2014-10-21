Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39005 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755664AbaJUQH3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 12:07:29 -0400
Received: from 65-183-131-85-dhcp.burlingtontelecom.net ([65.183.131.85]:60586 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Xgby4-000atF-Gq
	for linux-btrfs@vger.kernel.org; Tue, 21 Oct 2014 10:07:28 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: downgrade from kernel 3.17 to 3.10
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAMo7R_egQMGXs4nJBPkp86QkF9owpUhAh6P_Vn65wN84J7B95w@mail.gmail.com>
Date: Tue, 21 Oct 2014 12:07:27 -0400
Message-Id: <AB1090E1-4EC9-4E58-BB95-3CE871018DFB@colorremedies.com>
References: <CAMo7R_e9=wdGhEm9P+DZgXrKQ+qrKqdELzwwi-OMTCp6Mk8aTg@mail.gmail.com> <pan$e55c6$e7985780$d6580cb2$76eb6d4@cox.net> <CAMo7R_egQMGXs4nJBPkp86QkF9owpUhAh6P_Vn65wN84J7B95w@mail.gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 21, 2014, at 9:18 AM, Cristian Falcas <cristi.falcas@gmail.com> wrote:

> Thank you for your answer.
> 
> I will reformat the disk with a 3.10 kernel in the meantime, because I
> don't have any rpms for 3.16 now.

If you've formatted with features in common between 3.10 and 3.17, I don't think you need to do this. The concern is only that your existing file system enters an even more non-deterministic state than usual, and therefore not significantly tested.

The suggestion you stick to the most recent kernel you can, is sound advice though. Why all the way back to 3.10 instead of 3.14.22? Every distro should have binaries for it available. They should even have 3.16.6.

One thing I wonder, if going back to kernel 3.14 (or even 3.10), which btrfs-progs to use? Is it OK to use 3.17?


Chris Murphy