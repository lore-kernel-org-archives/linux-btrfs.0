Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23695 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbaA1JFo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 04:05:44 -0500
Message-ID: <52E77531.9060600@oracle.com>
Date: Tue, 28 Jan 2014 17:15:29 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Monitoring for disk failures
References: <52E64665.5020109@elastichosts.com> <pan$2540$a024a2e$1649dd5d$60e61fd@cox.net>
In-Reply-To: <pan$2540$a024a2e$1649dd5d$60e61fd@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> Without actually trying it here... I believe by default that'd update
> only when there was an I/O error.
>
> Did you try btrfs filesystem show --all-devices?  That scans differently.

  That will show missing with its own probes but kernel does not
  know that disk is missing.

> If that doesn't work try btrfs device scan first as that updates the in-
> kernel list, then filesystem show.

  Nope. Scan does not remove the old (missing disk) entries,
  I am writing patch(es)..

> Alternatively, monitor the kernel log
> for output as the scanned devices show up there.

  Thats the best choice as of now OR btrfs fi show -d will
  show missing

Thanks, Anand
