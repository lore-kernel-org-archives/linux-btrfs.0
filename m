Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:44740 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754079AbaGMRNN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Jul 2014 13:13:13 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs partition remounted read-only
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53B6DDAD.20504@gmail.com>
Date: Sun, 13 Jul 2014 11:13:13 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <8C7CBE0A-D27D-4486-9A77-E7587418DF7A@colorremedies.com>
References: <53B6DDAD.20504@gmail.com>
To: Konstantin Svist <fry.kun@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 4, 2014, at 11:00 AM, Konstantin Svist <fry.kun@gmail.com> wrote:

> I have an overnight cron job with
> 
> /sbin/fstrim -v /
> /bin/bedup dedup --defrag

Probably not related, but these look backwards, why not reverse them?


Chris Murphy
