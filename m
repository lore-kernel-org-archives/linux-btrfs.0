Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:34520 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbbJ2Cj5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Oct 2015 22:39:57 -0400
From: Russell Coker <russell@coker.com.au>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: How to replicate a Xen VM using BTRFS as the root filesystem.
Date: Thu, 29 Oct 2015 13:39:52 +1100
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
References: <5630BA78.1090804@gmail.com>
In-Reply-To: <5630BA78.1090804@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201510291339.52680.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 28 Oct 2015 11:07:20 PM Austin S Hemmelgarn wrote:
> Using this methodology, I can have a new Gentoo PV domain running in 
> about half an hour, whereas it takes me at least two and a half hours 
> (and often much longer than that) when using the regular install process 
> for Gentoo.

On my virtual servers I have a BTRFS subvol /xenstore for the block devices of 
virtual machines.  When I want to duplicate a VM I run
"cp -a --reflink=aways /xenstore/A /xenstore/B" which takes a few seconds.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
