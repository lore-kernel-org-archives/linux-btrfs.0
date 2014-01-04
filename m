Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:56803 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbaADVWy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Jan 2014 16:22:54 -0500
Message-ID: <52C87BAD.4060606@jrs-s.net>
Date: Sat, 04 Jan 2014 16:22:53 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
References: <52C73987.7000106@jrs-s.net> <52C73D1A.8060805@gmail.com>	<52C7402A.7050605@jrs-s.net> <52C741F5.7030106@gmail.com>	<52C74415.3020407@jrs-s.net>	<7B4E55D1-BA9B-4560-8442-429EDD01C92A@colorremedies.com> <pan$4ef1f$8e2a9876$c1faa462$63914453@cox.net>
In-Reply-To: <pan$4ef1f$8e2a9876$c1faa462$63914453@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/04/2014 01:10 AM, Duncan wrote:
> The example given in the OP was of a 4-device raid10, already the 
> minimum number to work undegraded, with one device dropped out, to 
> below the minimum required number to mount undegraded, so of /course/ 
> it wouldn't mount without that option.

The issue was not realizing that a degraded fault-tolerant array would 
refuse to mount without being passed an -o degraded option. Yes, it's on 
the wiki - but it's on the wiki under *replacing* a device, not in the 
FAQ, not in the head of the "multiple devices" section, etc; and no 
coherent message is thrown either on the console or in the kernel log 
when you do attempt to mount a degraded array without the correct argument.

IMO that's a bug. =)
