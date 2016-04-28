Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52604 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbcD1FPH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 01:15:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aveI4-0000VN-EG
	for linux-btrfs@vger.kernel.org; Thu, 28 Apr 2016 07:15:04 +0200
Received: from p50909051.dip0.t-ipconnect.de ([80.144.144.81])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Apr 2016 07:15:04 +0200
Received: from matthias by p50909051.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Apr 2016 07:15:04 +0200
To: linux-btrfs@vger.kernel.org
From: Matthias Bodenbinder <matthias@bodenbinder.de>
Subject: Re: Question: raid1 behaviour on failure
Date: Thu, 28 Apr 2016 07:12:34 +0200
Message-ID: <nfs642$ua8$1@ger.gmane.org>
References: <nf1q0j$ug4$1@ger.gmane.org> <57148B2E.6010904@cn.fujitsu.com>
 <nf73cv$7vh$1@ger.gmane.org> <571871FC.2010101@jp.fujitsu.com>
 <CAPmG0jZd7AaH+u52_gqBmke-3S=yH_i9Pmk1R=mOFmdnsj6BgQ@mail.gmail.com>
 <nfb2hr$6i0$1@ger.gmane.org>
 <CAPmG0jY5RRS_8YcECyCts6BEeJKT+74Uxr-2kitouruyBDwgfQ@mail.gmail.com>
 <571F9A92.8060602@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <571F9A92.8060602@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 26.04.2016 um 18:42 schrieb Holger Hoffstätte:
> On 04/26/16 18:19, Henk Slager wrote:
>> It looks like a JMS567 + SATA port multipliers behaind it are used in
>> this drivebay. The command   lsusb -v  could show that. So your HW
>> setup is like JBOD, not RAID.
> 
> I hate to quote the "harmful" trope, but..
> 
> SATA Port Multipliers Considered Harmful
> https://www.usenix.org/system/files/fastpw13-paper7_0.pdf
> 
> aka: how to make any RAID setup useless in 1 easy step.

Interesting article but it has no date to it. Could be outdated or brand new.

Matthias



