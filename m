Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:51589 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbbDREYp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Apr 2015 00:24:45 -0400
From: Russell Coker <russell@coker.com.au>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Subject: Re: how to clone a btrfs filesystem
Date: Sat, 18 Apr 2015 04:24:40 +0000
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
References: <1429312124.8371.62.camel@scientia.net>
In-Reply-To: <1429312124.8371.62.camel@scientia.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201504180424.40385.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 17 Apr 2015 11:08:44 PM Christoph Anton Mitterer wrote:
> How can I best copy one btrfs filesystem (with snapshots and subvolumes)
> into another, especially with keeping the CoW/reflink status of all
> files?

dd works.  ;)

> And ideally incrementally upgrade it later (again with all
> snapshots/subvols, and again not loosing the shared blocks between these
> files).

There are patches to rsync that make it work on block devices.  Of course that 
will copy space occupied by deleted files too.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
