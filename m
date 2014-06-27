Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:33098 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaF0XkG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 19:40:06 -0400
Received: from xev.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 503EF20207
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Jun 2014 09:40:03 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs@vger.kernel.org
Reply-To: russell@coker.com.au
Subject: Re: [Question] Btrfs on iSCSI device
Date: Sat, 28 Jun 2014 09:40:02 +1000
Message-ID: <2173101.6G0fsERxkf@xev>
In-Reply-To: <53AD9D1A.4050703@libero.it>
References: <CAMXuLLrhMv82LPveRemDU_v_Kru2US6sKVn377gS3t9p-VFrag@mail.gmail.com> <53AD9D1A.4050703@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 27 Jun 2014 18:34:34 Goffredo Baroncelli wrote:
> I don't think that it is possible to mount the _same device_ at the _same
> time_ on two different machines. And this doesn't depend by the filesystem.

If you use a clustered filesystem then you can safely mount it on multiple 
machines.

If you use a non-clustered filesystem it can still mount and even appear to 
work for a while.  It's surprising how many writes you can make to a dual-
mounted filesystem that's not designed for such things before you get a 
totally broken filesystem.

On Fri, 27 Jun 2014 13:15:16 Austin S Hemmelgarn wrote:
> The reason it appears to work when using iSCSI and not with directly
> connected parallel SCSI or SAS is that iSCSI doesn't provide low level
> hardware access.

I've tried this with dual-attached FC and had no problems mounting.  In what 
way is directly connected SCSI different from FC?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

