Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:56113 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850Ab3AEVVq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Jan 2013 16:21:46 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Option LABEL
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <COGp+CyPCXB@helmut.hullen.de>
Date: Sat, 5 Jan 2013 14:21:41 -0700
Message-Id: <6B0D5D9E-3ECC-4E3C-B0F8-00338255AA64@colorremedies.com>
References: <COGp+CyPCXB@helmut.hullen.de>
To: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 5, 2013, at 2:03 PM, Helmut Hullen <Hullen@t-online.de> wrote:

> Hallo, Chris,
> 
> Du meintest am 05.01.13:
> 
> 
>>> Seems to be a problem which is invoked by "btrfs-show".
> 
>> Old command. I'm not sure if it's kept up to date. You should use
>> 'btrfs filesystem show' or 'btrfs fi show' for short.
> 
> Yes - i've learned my lesson ...
> But then: the best solution for other people might be deleting "btrfs- 
> show" from the packet.

Best solution would be for the deprecated commands to be removed from btrfs-progs or -tools or wherever they're coming from. At this point, if that kills things that depend on them, so much the better. They too need to be updated to use the correct and maintained commands.

Chris Murphy