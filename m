Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:4867 "EHLO
	srv2.trombetti.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbbACSxN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Jan 2015 13:53:13 -0500
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: SASL)
	by srv2.trombetti.net (Postfix) with ESMTPSA id BD824313B0
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Jan 2015 13:59:18 -0500 (EST)
Message-ID: <54A83A95.2070108@shiftmail.org>
Date: Sat, 03 Jan 2015 19:53:09 +0100
From: Bob Marley <bobmarley@shiftmail.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: I need to P. are we almost there yet?
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>	<54A7D3D1.10508@shiftmail.org> <pan$872b8$2e173aaa$59613c61$c4e30dfd@cox.net>
In-Reply-To: <pan$872b8$2e173aaa$59613c61$c4e30dfd@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/01/2015 14:11, Duncan wrote:
> Bob Marley posted on Sat, 03 Jan 2015 12:34:41 +0100 as excerpted:
>
>> On 29/12/2014 19:56, sys.syphus wrote:
>>> specifically (P)arity. very specifically n+2. when will raid5 & raid6
>>> be at least as safe to run as raid1 currently is? I don't like the idea
>>> of being 2 bad drives away from total catastrophe.
>>>
>>> (and yes i backup, it just wouldn't be fun to go down that route.)
>> What about using btrfs on top of MD raid?
> The problem with that is data integrity.  mdraid doesn't have it.  btrfs
> does.
>
> If you present a single mdraid device to btrfs and run single mode on it,
> and one copy on the mdraid is corrupt, mdraid may well simply present it
> as it does no integrity checking.  btrfs will catch and reject that, but
> because it sees a single device, it'll think the entire thing is corrupt.

Which is really not bad, considering the chance that something gets corrupt.
Already it is an exceedingly rare event. Detection without correction 
can be more than enough. Since always things have worked in the computer 
science field without even the detection feature.
Most likely even your bank account and mine are held in databases which 
are located in filesystems or blockdevices which do not even have the 
corruption detection feature.
And, last but not least, as of now a btrfs bug is more likely than hard 
disks' silent data corruption.

