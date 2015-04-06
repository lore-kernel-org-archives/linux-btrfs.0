Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:59968 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbbDFIjF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Apr 2015 04:39:05 -0400
From: Russell Coker <russell@coker.com.au>
To: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs hangs 3.19-10
Date: Mon, 6 Apr 2015 08:39:01 +0000
Cc: linux-btrfs@vger.kernel.org
References: <CAGqmi74e_U5-UVUy+MHbxc2f-38pRyjK1Zo0Up-V9ndFpv-bXA@mail.gmail.com> <20150405100417.GE13864@carfax.org.uk> <pan$d8274$4104f220$c763dc8e$c4e4259e@cox.net>
In-Reply-To: <pan$d8274$4104f220$c763dc8e$c4e4259e@cox.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201504060839.01726.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 6 Apr 2015 03:21:18 AM Duncan wrote:
> So... for 3.2 compatibility, extref must not be enabled (tho it's now the 
> default and AFAIK there's no way to actually disable it, only enable, so 
> an old btrfs-tools would have to be used that doesn't enable it by 
> default), AND the nodesize must be set to page size, 4096 bytes for x86.

So basically we have to have an old version of mkfs.btrfs to make a filesystem 
that can be mounted on kernel 3.2.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
