Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:53633 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbbEIIn6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 May 2015 04:43:58 -0400
Received: from [192.168.10.21] ([83.64.176.131]) by mrelayeu.kundenserver.de
 (mreue003) with ESMTPSA (Nemesis) id 0MZ9Wi-1YW26A2YaS-00KzIC for
 <linux-btrfs@vger.kernel.org>; Sat, 09 May 2015 10:43:54 +0200
Message-ID: <554DC8C9.4020709@floga.de>
Date: Sat, 09 May 2015 10:43:53 +0200
From: =?UTF-8?B?RmxvcmlhbiBHYW1iw7Zjaw==?= <ml@floga.de>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs changes (issues?) on OS upgrade
References: <1798034232.614027.1431151384353.JavaMail.apache@nm33.abv.bg>
In-Reply-To: <1798034232.614027.1431151384353.JavaMail.apache@nm33.abv.bg>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Milen,

Am 09.05.2015 um 08:03 schrieb Милен Христов:
> 2. After the upgrade I see the following entries in the kernel log(attached):
>
> [   78.717743]  sdb: unknown partition table
> [   78.735588]  sdc: unknown partition table
> [   78.736279]  sdd: unknown partition table
> [   78.781962]  sde: unknown partition table

I can't really tell you what is going on with the first problem, 
although I *guess* that it should be fine and is just the result of more 
accurate disk space calculations.

Regarding the second problem, I can confirm that I have the same 
messages in my log. It results from "formatting" the whole drive with 
BTRFS and not just a partition. So the drive has now no partition table 
which the kernel can identify. This does of course not change the fact 
that you can mount those drives without problems.

You didn't see those messages before, so my guess is, that between Ubu 
14.10 and 15.04 the kernel config was changed to make it more verbose. 
Do note, that those are not error or warning messages. The kernel is 
merely informing you about the fact, that it cannot identify the type of 
the partition table. Usually you can ignore those messages.

Regards
--Flo
