Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59635 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab3EIMpD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 May 2013 08:45:03 -0400
Received: from mailout-de.gmx.net ([10.1.76.27]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MIBlI-1UYlWK11TC-003sCR for
 <linux-btrfs@vger.kernel.org>; Thu, 09 May 2013 14:45:02 +0200
Message-ID: <518B9A4C.8070409@gmx.de>
Date: Thu, 09 May 2013 14:45:00 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: syslog message repeated 3x
References: <518B6BC1.8020504@gmx.de> <BF628B33-2657-4A04-B9D6-18BA462F819D@gmail.com>
In-Reply-To: <BF628B33-2657-4A04-B9D6-18BA462F819D@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/09/2013 01:47 PM, Wang Shilong wrote:
> Anyway, i use the latest btrfs-progs.

well, under Gentoo I used sys-fs/btrfs-progs-9999 which points always to the latest git version :
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

My host kernel is stable 3.9.1

The mount command still gives :

2013-05-09T14:43:35.604+02:00 n22 kernel: device fsid 20a30a6b-a82f-429f-b426-00f1739e4d3d devid 1 transid 8 /dev/loop1
2013-05-09T14:43:35.604+02:00 n22 kernel: device fsid 20a30a6b-a82f-429f-b426-00f1739e4d3d devid 1 transid 8 /dev/loop1
2013-05-09T14:43:35.608+02:00 n22 kernel: btrfs: disk space caching is enabled
2013-05-09T14:43:35.660+02:00 n22 kernel: device fsid 20a30a6b-a82f-429f-b426-00f1739e4d3d devid 1 transid 8 /dev/loop1

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
