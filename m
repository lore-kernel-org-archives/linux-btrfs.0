Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([80.100.93.5]:59060 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab3IQL1Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 07:27:16 -0400
Date: Tue, 17 Sep 2013 13:18:09 +0200
From: Sander <sander@humilis.net>
To: Jogi =?iso-8859-1?Q?Hofm=FCller?= <jogi@mur.at>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: rootfs crash
Message-ID: <20130917111809.GA16032@panda>
Reply-To: sander@humilis.net
References: <5236E1FF.4080900@mur.at>
 <5238343F.3020802@mur.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <5238343F.3020802@mur.at>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jogi Hofmüller wrote (ao):
> I am limited to working with the tools the Debian initramfs
> provides.  This means kernel 3.10.2 (Debian 3.10.7-1) and
> btrfs-tools  0.19+20130705-1.  The latter seems to be up to date
> with git although `btrfs version` says v0.20 rc1. All this is
> happening on an Asus Zen book  UX32V with two 128GB SSDs.
> 
> If anyone is interested in images produced by btrfs-image, they are
> available at
> 
>   http://plagi.at/images/
> 
> I am fresh out of ideas at the moment, so if anyone has a suggestion
> I am willing to try.

Did you try btrfs chunk-recover ?

	Sander
