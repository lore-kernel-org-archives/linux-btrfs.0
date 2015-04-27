Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:35984 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbbD0QIG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 12:08:06 -0400
Message-ID: <553E5C8C.4070202@siedziba.pl>
Date: Mon, 27 Apr 2015 17:58:04 +0200
From: =?UTF-8?B?UGlvdHIgUGF3xYJvdw==?= <pp@siedziba.pl>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, sri <toyours_sridhar@yahoo.co.in>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs freeze/thaw when using with LVM2
References: <loom.20150427T140306-446@post.gmane.org> <20150427121521.GB18187@carfax.org.uk>
In-Reply-To: <20150427121521.GB18187@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 27.04.2015 o 14:15, Hugo Mills wrote:
> HOWEVER, you shouldn't take LVM snapshots of a btrfs filesystem AT ALL

I'd like to add, that generally when working with LVM and BTRFS, it's 
probably a good idea to always use "device=" mount option to make it 
scan only specified devices instead of all. I'd learned that the hard 
way, when I enabled SSD caching, and got massive corruption, because 
BTRFS mixed up cached devices with cache-origin devices. Now I have 
"device=/dev/mapper/vg-home1,device=/dev/mapper/vg-home2" in mount 
options in my fstab, and I can use LVM cache without worrying that 
things will get mixed up again.
