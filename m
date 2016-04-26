Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:52228 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbcDZQnA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 12:43:00 -0400
Subject: Re: Question: raid1 behaviour on failure
To: Henk Slager <eye1tm@gmail.com>,
        Matthias Bodenbinder <matthias@bodenbinder.de>
References: <nf1q0j$ug4$1@ger.gmane.org> <57148B2E.6010904@cn.fujitsu.com>
 <nf73cv$7vh$1@ger.gmane.org> <571871FC.2010101@jp.fujitsu.com>
 <CAPmG0jZd7AaH+u52_gqBmke-3S=yH_i9Pmk1R=mOFmdnsj6BgQ@mail.gmail.com>
 <nfb2hr$6i0$1@ger.gmane.org>
 <CAPmG0jY5RRS_8YcECyCts6BEeJKT+74Uxr-2kitouruyBDwgfQ@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <571F9A92.8060602@googlemail.com>
Date: Tue, 26 Apr 2016 18:42:58 +0200
MIME-Version: 1.0
In-Reply-To: <CAPmG0jY5RRS_8YcECyCts6BEeJKT+74Uxr-2kitouruyBDwgfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/26/16 18:19, Henk Slager wrote:
> It looks like a JMS567 + SATA port multipliers behaind it are used in
> this drivebay. The command   lsusb -v  could show that. So your HW
> setup is like JBOD, not RAID.

I hate to quote the "harmful" trope, but..

SATA Port Multipliers Considered Harmful
https://www.usenix.org/system/files/fastpw13-paper7_0.pdf

aka: how to make any RAID setup useless in 1 easy step.

-h

