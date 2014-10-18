Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57049 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751608AbaJRPRx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Oct 2014 11:17:53 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: 3.17.1 blocked task
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <B7F2379062E32745A8651FBDB20F64593B0C9CF2@Server.waterlogic.com.au>
Date: Sat, 18 Oct 2014 11:17:52 -0400
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <9CE5AD9A-CCE1-455F-955E-BA2969354C04@colorremedies.com>
References: <B7F2379062E32745A8651FBDB20F64593B0C9CF2@Server.waterlogic.com.au>
To: Paul Jones <paul@pauljones.id.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 18, 2014, at 8:00 AM, Paul Jones <paul@pauljones.id.au> wrote:

> Hi All,
> 
> Just found this stack trace in dmesg while running a scrub on one of my file systems. I haven’t seen this reported yet so I thought I should report it ☺

Suggest reproducing and issuing sysrq+w which will show the blocked tasks (in dmesg).

Chris Murphy

