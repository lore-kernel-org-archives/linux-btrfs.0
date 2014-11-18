Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.97.166]:50921 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaKRHqm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 02:46:42 -0500
Date: Tue, 18 Nov 2014 12:36:46 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
Message-ID: <20141118123646.01239614@natsu>
In-Reply-To: <546AF572.2020101@swiftspirit.co.za>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
	<546AF572.2020101@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 18 Nov 2014 09:29:54 +0200
Brendan Hide <brendan@swiftspirit.co.za> wrote:

> Hey, guys
> 
> See further below extracted output from a daily scrub showing csum 
> errors on sdb, part of a raid1 btrfs. Looking back, it has been getting 
> errors like this for a few days now.
> 
> The disk is patently unreliable but smartctl's output implies there are 
> no issues. Is this somehow standard faire for S.M.A.R.T. output?

Not necessarily the disk's fault, could be a SATA controller issue. How are
your disks connected, which controller brand and chip? Add lspci output, at
least if something other than the ordinary "to the motherboard chipset's
built-in ports".

-- 
With respect,
Roman
