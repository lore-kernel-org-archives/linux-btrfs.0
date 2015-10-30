Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.palepurple.co.uk ([89.16.183.188]:54739 "EHLO
	mail.palepurple.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbbJ3UNl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Oct 2015 16:13:41 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.palepurple.co.uk (Postfix) with ESMTP id 9A1FE9091
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2015 20:06:16 +0000 (GMT)
Received: from mail.palepurple.co.uk ([127.0.0.1])
	by localhost (mail.palepurple.co.uk [127.0.0.50]) (amavisd-new, port 10024)
	with ESMTP id my_uL8gSeNHB for <linux-btrfs@vger.kernel.org>;
	Fri, 30 Oct 2015 20:06:05 +0000 (GMT)
Received: from [192.168.0.5] (97e41767.skybroadband.com [151.228.23.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: david@codepoets.co.uk)
	by mail.palepurple.co.uk (Postfix) with ESMTPSA id 7707F9031
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2015 20:06:05 +0000 (GMT)
Subject: Re: Periodic kernel freezes
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <63869607-1857-48D3-9D95-62BDBB308060@oseberg.io>
From: David Goodwin <david@codepoets.co.uk>
Message-ID: <5633CDB3.2060905@codepoets.co.uk>
Date: Fri, 30 Oct 2015 20:06:11 +0000
MIME-Version: 1.0
In-Reply-To: <63869607-1857-48D3-9D95-62BDBB308060@oseberg.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 30/10/2015 16:25, Alex Adriaanse wrote:
> I have an EC2 instance on AWS that tends to freeze several times per
> week. When it freezes it stops responding to network traffic, disk
> I/O stops, and CPU goes to 100%. The system comes back fine after a
> reboot. I was finally able to get a kernel backtrace from when this
> happened today, which I have attached to this email.
>
> The VM in question runs Debian Jessie, and has 3 BTRFS filesystems,
> including the root filesystem. Details are included below.
>
> Any ideas?
>

Hi Alex -

I kept experiencing problems with the Jessie 3.16.x kernel on EC2 (and 
elsewhere) with BTRFS.

Out of 8 nodes, one managed an uptime of 90 days, while the average was 
about 21 days.

Crashes were seemingly random, and it was difficult to get stack traces.

For the stack traces I did get, it wasn't always obvious that the 
problem lay with BTRFS.

Reboots normally needed to be forceful.

I'd suggest upgrading to a backports kernel (I compiled various 4.1.x 
kernels, but there's now 4.2.x in jessie-backports).

You might also want to turn off compression...

David.
