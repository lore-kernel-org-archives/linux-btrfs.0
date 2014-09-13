Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53042 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbaIMOlE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Sep 2014 10:41:04 -0400
Message-ID: <5414577C.2030409@gmx.de>
Date: Sat, 13 Sep 2014 16:41:00 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: BUG_ON spams /var/log/messages with the same msg full
References: <5400ECBC.5090301@gmx.de> <20140901134124.GA18252@localhost.localdomain>
In-Reply-To: <20140901134124.GA18252@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/01/2014 03:41 PM, Liu Bo wrote:
> I believe that this warning of btrfs_evict_inode also comes from a result of
> lseek, and Chris said that he's prepared a fix for that, so it's queued in the
> next version.
> 
> thanks,
> -liubo

So rather fixed in -rc6 because v3.17-rc4-337-gfc486b0 still suffers from this issue ?

-- 
Toralf
pgp key: 0076 E94E

