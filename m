Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46175 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaDWSdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 14:33:31 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: =?utf-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or newer?
Date: Wed, 23 Apr 2014 20:33:26 +0200
Message-ID: <1672266.kZAXajEn0U@zafu>
In-Reply-To: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le mercredi 23 avril 2014 20:30:08 Пламен Петров a écrit :
> Can anyone boot a system using btrfs root with linux 3.14 or newer?

Yes I do.

$ grep /boot /proc/mounts
/dev/sda8 /boot btrfs rw,noatime,compress=lzo,space_cache,autodefrag 0 0
/dev/sda1 /boot/efi vfat 
rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=utf8,shortname=mixed,errors=remount-
ro 0 0

$ uname -r
3.14.1-1-ARCH

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

