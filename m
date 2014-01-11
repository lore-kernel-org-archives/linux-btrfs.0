Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from icts.hu ([195.70.57.6]:38236 "EHLO icts.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbaAKSzV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jan 2014 13:55:21 -0500
Received: from [192.168.152.152] (1F2E4838.catv.pool.telekom.hu [31.46.72.56])
	(using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by icts.hu (Postfix) with ESMTPSA id 8D58B70953A
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Jan 2014 19:48:55 +0100 (CET)
Message-ID: <52D19217.3060106@dblaci.hu>
Date: Sat, 11 Jan 2014 19:48:55 +0100
From: =?ISO-8859-1?Q?Szalma_L=E1szl=F3?= <dblaci@dblaci.hu>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS over LVM remounts read-only
References: <CAE8gLh=drhPtUXSbT7zHDSh7pipxuZpVhfuRQ7QOFV+HP4wHPQ@mail.gmail.com>	<20140111150454.GV15634@carfax.org.uk> <CAE8gLhnd8mjRZoJCCj8ns4W6OJJXFGUiO8Ni78aYbyY2MA_Luw@mail.gmail.com>
In-Reply-To: <CAE8gLhnd8mjRZoJCCj8ns4W6OJJXFGUiO8Ni78aYbyY2MA_Luw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-01-11 18:10 keltezéssel, MegaBrutal írta:
> How can I shrink the FS to the correct size right now, ensuring that I 
> really shrink it to the exact LV size?

btrfs fi re 10G /dev/mapper/vg-lv
lvresize -L 10G vg/lv

Grub can boot a root on lv (with appropriate initrd), but the grub 
itself has to be on a standard bios bootable partition (as far as I know)


DBLaci
