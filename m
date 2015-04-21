Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:43986 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbbDUJir (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 05:38:47 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: Carefully crafted BTRFS-image causes kernel to crash
Date: Tue, 21 Apr 2015 19:38:34 +1000
Cc: Lukas Lueg <lukas.lueg@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAJF-kYngS4U6=oiXhs0ZF3Na3ezTGcMX1Wyd5HVVm887V61mWw@mail.gmail.com> <5535C11C.2050308@cn.fujitsu.com>
In-Reply-To: <5535C11C.2050308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201504211938.35080.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 21 Apr 2015, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Although we may add extra check for such problem to improve robustness,
> but IMHO it's not a real world problem.

Some of the ReiserFS developers gave a similar reaction to some of my bug 
reports.  ReiserFS wasn't the most robust filesystem.

I think that it should be EXECTED that a kernel will have to occasionally deal 
with filesystem images that are created by hostile parties.  Userspace crash 
and kernel freeze is not a suitable way of dealing with it.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
