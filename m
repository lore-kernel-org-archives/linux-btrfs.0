Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:38799 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750991Ab3IYE72 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Sep 2013 00:59:28 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:53081 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VOgnu-002DB6-D3
	for linux-btrfs@vger.kernel.org; Tue, 24 Sep 2013 22:34:22 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: balance induced csum errors, systemd-journal
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <F715552F-A1A0-49BE-B714-C5DF6B7D8AB6@colorremedies.com>
Date: Tue, 24 Sep 2013 22:34:20 -0600
Message-Id: <795CFB34-4216-4ACA-A56D-5F673B2FD45E@colorremedies.com>
References: <4CA64610-C709-4805-A9DC-AA8EB0720BBF@colorremedies.com> <1810D553-8DB4-4FAA-A305-CF3BE9A85B6F@colorremedies.com> <F715552F-A1A0-49BE-B714-C5DF6B7D8AB6@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK so I think I'm narrowing this down to just the systemd journal, and it's not checksums that are corrupted, it's the journal itself.

[   19.354354] systemd-journald[210]: /var/log/journal/8e4cbfea404512ae70096c6202c9a3bf/system.journal: Journal file corrupted, rotating.

If I set systemd journald.conf Storage=volatile so that it stores journals only in memory, the problem is not reproducible.

However, even after deleting all corrupt journal files, and a subsequent scrub reporting no errors, on each reboot (and mount of the filesystem) I get:

[    3.646448] btrfs: bdev /dev/sda6 errs: wr 0, rd 0, flush 0, corrupt 17, gen 0

So somehow the corrupt counter isn't being reset?

And how would I go about setting /var/log/journal contents to inherit nodatacow? Possible?


Chris Murphy