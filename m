Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:44303 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932960Ab3CGPJa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 10:09:30 -0500
Message-ID: <5138ADA6.5070101@petaramesh.org>
Date: Thu, 07 Mar 2013 16:09:26 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
CC: Eric Sandeen <sandeen@redhat.com>, Anand.Jain@oracle.com
Subject: Re: mkfs.btrfs broken
References: <513883DD.8080203@petaramesh.org> <5138980C.8080000@redhat.com>
In-Reply-To: <5138980C.8080000@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 07/03/2013 14:37, Eric Sandeen a écrit :
> What error messages does it emit, anything helpful? 

root@partedmagic:~# file -s /dev/sda5
/dev/sda5: data

root@partedmagic:~# mkfs.btrfs /dev/sda5

WARNING! - Btrfs v0.20-rc1 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

error checking /dev/sda5 mount status

root@partedmagic:~# echo $?
1

> The option is quite new, and still exists upstream. But it only forces
> overwrite of an existing filesystem, it has never affected the mount
> status check AFAIK. 

I remember that, in the past, I was several time able to override this
very error by using a -f switch...


> There are also steps you could take to investigate some more yourself:
> Did earlier versions of the livecd work for you? If so, when did it break?

It was broke first time I tried to use it more than a year ago ; I don't
clearly remember if it has been fixed at some point in time... I'm
positively sure that I saw the exact same error on other live distros
(possibly Ubuntu but not sure...)

> Can you capture an strace of the failing mkfs.btrfs? -Eric 

I don't know how to do this, I'm no developper myself...

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

