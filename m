Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:52051 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbaADVVw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Jan 2014 16:21:52 -0500
Message-ID: <52C87B67.1040503@friedels.name>
Date: Sat, 04 Jan 2014 22:21:43 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck does not fix
References: <52C7127F.3060902@friedels.name> <6E517D5F-B921-47E7-82E7-27865077C43D@colorremedies.com>
In-Reply-To: <6E517D5F-B921-47E7-82E7-27865077C43D@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,


 >> I ran btrfsck on my volume with the repair option. When I re-run it, 
 >>I get the same errors as before.
>
> Did you try mounting with -o recovery first?
> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ

No, I did not.
In fact, I had visited the FAQ before, and my understanding was, that -o 
recovery was used/needed when mounting is impossible. This is not the 
case. In fact, the disk does work without obvious problems.

> What messages in dmesg so you get when you use recovery?

I'll find out, tomorrow (I can't access the disk just now).

Greetings,
Hendrik


-- 
Hendrik Friedel
Auf dem Brink 12
28844 Weyhe
Mobil 0178 1874363
