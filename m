Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:49500 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3JXIsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 04:48:05 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id CF9BC9A06CD
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Oct 2013 02:48:03 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Sean Clarke <sean.clarke@sec-consulting.co.uk>,
        <linux-btrfs@vger.kernel.org>
References: <CAHCKNJj2=qfWEpWWUOBit5cJakwd+oFr1U-xj8MS-w9oQo6YQg@mail.gmail.com>
In-Reply-To: <CAHCKNJj2=qfWEpWWUOBit5cJakwd+oFr1U-xj8MS-w9oQo6YQg@mail.gmail.com>
Message-ID: <20131024084756.14051.61595@localhost.localdomain>
Subject: Re: 3.11 and 3.12rc continual hard lock ups
Date: Thu, 24 Oct 2013 04:47:56 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Sean Clarke (2013-10-23 15:26:15)
> Hi,
>    I have an Intel Core i7 based fileserver with 18TB BTRFS in a 6x
> 3TB RAID 1+0 configuration. The system was working fine running Ubuntu
> 13.04 (kernel 3.11.0-12-generic). The system was upgraded to Ubuntu
> 13.10 (kernel 3.11) and began to lock up daily, sometimes every couple
> of hours. Previously it never crashed and was only taken down for
> maintenance so a bug was files on launchpad
> (https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1237794).

Does your kernel  config include the softlockup detector?  If you could
please do sysrq-w and sysrq-t while it is locked, it'll help us track it
down.

It will be much easier if you have a serial console or network console,
and you've increased your kernel logging level to the highest value
(dmesg -n7)

-chris
