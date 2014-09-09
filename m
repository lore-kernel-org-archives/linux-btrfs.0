Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:59378 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaIISSH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Sep 2014 14:18:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>
Subject: Re: ENOSPC on mostly empty file system
Date: Tue, 09 Sep 2014 20:18:04 +0200
Message-ID: <4255785.FLXNWijYCD@wuerfel>
In-Reply-To: <3150960.nnNb4J6vhp@wuerfel>
References: <3150960.nnNb4J6vhp@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 09 September 2014 16:29:05 Arnd Bergmann wrote:
> 
> I also played around with it some more. After removing a few small
> files, I could create new files with up to 20-60MB again before hitting
> ENOSPC. I then did a 'make clean' in all the object directories I had
> and after that could fill the file system up to 100% by creating a
> 62GB file using the same command (dd if=/dev/zero of=x).

Ok, one more data point: I was accidentally building randconfig kernels
in the same partition all the time, meaning I had lots of traffic with
small files using the same names all over all the time. After I got
the file system back to a usable state today, building some more randconfig
kernels broke it in the same way.

	Arnd
