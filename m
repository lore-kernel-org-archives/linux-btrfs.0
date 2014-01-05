Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:60951 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaAENgz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jan 2014 08:36:55 -0500
Message-ID: <52C95FEC.7090106@friedels.name>
Date: Sun, 05 Jan 2014 14:36:44 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        "linux-btrfs@vger.kernel.org >> linux-btrfs"
	<linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck does not fix
References: <52C7127F.3060902@friedels.name> <6E517D5F-B921-47E7-82E7-27865077C43D@colorremedies.com> <52C87B67.1040503@friedels.name>
In-Reply-To: <52C87B67.1040503@friedels.name>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,


>> What messages in dmesg so you get when you use recovery?
>
> I'll find out, tomorrow (I can't access the disk just now).

Here it is:
[90098.989872] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f 
devid 2 transid 162460 /dev/sdc1

That's all. The same in the syslog.

Do you have further suggestions to fix the file-system?

Regards,
Hendrik
