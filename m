Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:59218 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754618Ab3ADVlx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Jan 2013 16:41:53 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Option LABEL
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <COCn3oPuCXB@helmut.hullen.de>
Date: Fri, 4 Jan 2013 14:41:51 -0700
Message-Id: <C4D4D740-FF4F-410F-94CD-151F07184D20@colorremedies.com>
References: <COCn3oPuCXB@helmut.hullen.de>
To: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 4, 2013, at 1:59 PM, Helmut Hullen <Hullen@t-online.de> wrote:
> 
> Additional:
> 
> Working as "root":
> 
>        blkid
> 
> hangs (at least sometimes).

Maybe use the latest debug kernel for your distro and see if you can reproduce the hang, and what you get in dmesg with the debug kernel.

What version of util-linux-ng?


Chris Murphy

