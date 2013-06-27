Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 110-174-82-20.static.tpgi.com.au ([110.174.82.20]:55320 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752777Ab3F0N4H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 09:56:07 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Kelvin <kelvin9302104@gmail.com>
Subject: Re: Transparent Tagging?
Date: Thu, 27 Jun 2013 23:56:01 +1000
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
References: <CAFwaWH=iuaq2W05GrpitARq3L9w+ZNGPkC1C4p=Bd0AP6p84FQ@mail.gmail.com>
In-Reply-To: <CAFwaWH=iuaq2W05GrpitARq3L9w+ZNGPkC1C4p=Bd0AP6p84FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201306272356.01246.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 27 Jun 2013, Kelvin <kelvin9302104@gmail.com> wrote:
> It seems that there are some tagging systems, but they are not native
> for the filesystem. It means that when we read the filesystem from an
> OS without that system installed, everything will be in a mess (or we
> can arrange the files in traditional way as well, but this is
> inconvenient). Also, we need to manage the files through the utilities
> provided, and this is not convenient.

I think it would be useful to have a way of searching for XATTR values.  One 
example of how this could be used is when analysing a SE Linux system it would 
be useful to be able to quickly get a list of all files with a particular 
security label (value for the security.selinux XATTR).

But it's probably best that developers concentrate on reliability, 
performance, and more commonly desired features such as RAID5/6 support.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
