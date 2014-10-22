Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:58486 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753499AbaJVBnb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 21:43:31 -0400
Received: from 65-183-131-85-dhcp.burlingtontelecom.net ([65.183.131.85]:63957 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XgkxU-000xtO-Th
	for linux-btrfs@vger.kernel.org; Tue, 21 Oct 2014 19:43:29 -0600
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: device balance times
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5446BEC0.8070009@siedziba.pl>
Date: Tue, 21 Oct 2014 21:43:18 -0400
Message-Id: <02A17DFE-290C-4447-99E9-D39480D7A26A@colorremedies.com>
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com> <5446BEC0.8070009@siedziba.pl>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 21, 2014, at 4:14 PM, Piotr Pawłow <pp@siedziba.pl> wrote:

> On 21.10.2014 20:59, Tomasz Chmielewski wrote:
>> FYI - after a failed disk and replacing it I've run a balance; it took almost 3 weeks to complete, for 120 GBs of data:
> 
> Looks normal to me. Last time I started a balance after adding 6th device to my FS, it took 4 days to move 25GBs of data.

It's long term untenable. At some point it must be fixed. It's way, way slower than md raid.

> I think it is so slow, because it's disassembling chunks piece by piece and stuffing these pieces elsewhere, instead of moving chunks as a whole. If you have a lot of little pieces (as I do), it will take a while…

At a certain point it needs to fallback to block level copying, with a ~ 32KB block. It can't be treating things as if they're 1K files, doing file level copying that takes forever. It's just too risky that another device fails in the meantime.


Chris Murphy