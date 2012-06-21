Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:49530 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759660Ab2FUNiw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jun 2012 09:38:52 -0400
Message-ID: <4FE323DB.1070507@zytor.com>
Date: Thu, 21 Jun 2012 06:38:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Goffredo Baroncelli <kreijack@libero.it>, cwillu <cwillu@cwillu.com>,
        helmut@hullen.de, linux-btrfs@vger.kernel.org
Subject: Re: R: Re: Subvolumes and /proc/self/mountinfo
References: <32353828.234981340193742067.JavaMail.defaultUser@defaultHost> <4FE1EE52.20002@zytor.com> <4FE1FB9B.1090203@libero.it> <4FE20B3D.5060704@zytor.com> <4FE21134.9090501@libero.it> <4FE2455E.2090007@zytor.com> <4FE2B576.3030301@libero.it>
In-Reply-To: <4FE2B576.3030301@libero.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/20/2012 10:47 PM, Goffredo Baroncelli wrote:
> 
> This leads to have a separately /boot filesystem. In this case I agree
> with you: make sense that the kernel is near the bootloader files.
> 
> But if /boot has to be in a separate filesystem, which is the point to
> support btrfs at all ? Does make sense to support only a subset of btrfs
> features ?
> 

Yes, and that's another good reason for /boot: btrfs supports that kind
of policy (e.g. "no compression or encryption in this subtree.")

>>
>>> Now we have the possibility to move the kernel near the modules, and
>>> this could lead some interesting possibility: think about different
>>> linux installations, with an own kernel version and an own modules
>>> version; what are the reasons to put together under /boot different
>>> kernel which potential conflicting names ? de facto standard ?
>>> historical reasons ? Nothing wrong here; but also the idea to moving the
>>> kernel under /lib/modules is not so wrong.
>>
>> No, it is completely, totally and very very seriously wrong.
> 
> When a bootloader (and the bioses) will be able to address the whole
> diskS, this will change.. Not now
> 

People have said that for 15 years.  The reality is that firmware will
always be behind the curve, and *that's ok*, we just need to deal with it.

	-hpa

