Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:57081 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755821Ab3AETIS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Jan 2013 14:08:18 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Option LABEL
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <COGoZAXPCXB@helmut.hullen.de>
Date: Sat, 5 Jan 2013 12:08:20 -0700
Message-Id: <D8C30239-D4A3-4DBF-97A9-840CC1C068A2@colorremedies.com>
References: <COGoZAXPCXB@helmut.hullen.de>
To: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 5, 2013, at 5:44 AM, Helmut Hullen <Hullen@t-online.de> wrote:

> 
>   blkid from util-linux 2.21.2 (libblkid 2.21.0, 25-May-2012
>   findfs from the same "util-linux" packet
>   kernel 3.6.11
> 
> Is that new enough?

I don't know. I'm running 3.6.11 and util-linux 2.22.1. The changelog for 2.22.x's have many blkid entries, but only one btrfs entry. It may be a general bug with blkid that isn't directly attributable to btrfs though.


Chris Murphy