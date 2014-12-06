Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:59765 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbaLFBr6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Dec 2014 20:47:58 -0500
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 21EC6406C2
	for <linux-btrfs@vger.kernel.org>; Sat,  6 Dec 2014 12:39:18 +1100 (AEDT)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 01601-08 for <linux-btrfs@vger.kernel.org>;
 Sat,  6 Dec 2014 12:39:18 +1100 (AEDT)
Received: from quad.localnet (2001-44b8-41dd-d500-a027-be3d-93d8-862e.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:a027:be3d:93d8:862e])
	by csamuel.org (Postfix) with ESMTPSA id B6009406BF
	for <linux-btrfs@vger.kernel.org>; Sat,  6 Dec 2014 12:39:17 +1100 (AEDT)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: General Question: ctime, mtime, and xattrs
Date: Sat, 06 Dec 2014 12:39:14 +1100
Message-ID: <1670463.A2AUh24FHt@quad>
In-Reply-To: <54823FBA.9000707@pobox.com>
References: <54822CEE.5070603@pobox.com> <CAE5mzvgrdYSNWSWLrnmHMz2fSgPSJV_ocYr_ZSBGPwLWBshH-g@mail.gmail.com> <54823FBA.9000707@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 5 Dec 2014 03:28:58 PM Robert White wrote:

> I've been thinking "ctime" is/was (still) "create time". It seems that 
> somewhere in the last couple decades it became "change time"; Or that I 
> picked up that incorrect "create time" idea back in the UNIX Sys V R 3 
> days and just never had cause to think about it again...

Sadly there's never been a creation time in Linux that you can get with a 
standard system call, there was an attempt 4-5 years ago to get xstat merged 
that would include creation time from filesystems that support it (like ext4) 
but it never went anywhere (for a variety of reasons).

LWN article on the patch set:

 https://lwn.net/Articles/394298/

Linus knocking it back:

 https://lkml.org/lkml/2010/7/22/249

FreeBSD has:

 st_birthtim  Time when the inode was created.

No idea when that was added!

All the best,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


