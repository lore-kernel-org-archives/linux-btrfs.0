Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53941 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753600AbaENXNX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 19:13:23 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: 3.15rc5 deadlock
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140514205519.GB12849@merlins.org>
Date: Wed, 14 May 2014 17:13:20 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <EB973584-8C25-4D12-9EA6-03584C38A9D7@colorremedies.com>
References: <20140514114027.GA32301@merlins.org> <5373616E.9070409@fb.com> <20140514205519.GB12849@merlins.org>
To: Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 14, 2014, at 2:55 PM, Marc MERLIN <marc@merlins.org> wrote:

> INFO: task btrfs:13329 blocked for more than 120 seconds.

Pretty much anytime blocked for more than 120 seconds is reported, devs ask for sysrq-w. Typically that translates into three steps:

echo 1 > /proc/sys/kernel/sysrq
echo w > /proc/sysrq-trigger
dmesg

https://www.kernel.org/doc/Documentation/sysrq.txt

Chris Murphy

