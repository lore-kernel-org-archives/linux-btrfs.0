Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51262 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab2E2MKG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 08:10:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SZLFU-0001Vk-0Q
	for linux-btrfs@vger.kernel.org; Tue, 29 May 2012 14:10:04 +0200
Received: from 188-223-3-27.zone14.bethere.co.uk ([188.223.3.27])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 14:10:04 +0200
Received: from stephane.chazelas by 188-223-3-27.zone14.bethere.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 14:10:04 +0200
To: linux-btrfs@vger.kernel.org
From: Stephane Chazelas <stephane.chazelas@gmail.com>
Subject: Re: Make existing snapshots read-only?
Date: Tue, 29 May 2012 12:56:13 +0100
Message-ID: <20120529115613.GB7397@chaz.gmail.com>
References: <20120528183700.GA9588@untroubled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120528183700.GA9588@untroubled.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2012-05-28 12:37:00 -0600, Bruce Guenter:
> 
> Is there any way to mark existing snapshots as read-only? Making new
> ones read-only is easy enough, but what about existing ones?
[...]

you can always do

btrfs sub snap -r vol vol-ro
btrfs sub del vol
mv vol-ro vol

-- 
Stephane

