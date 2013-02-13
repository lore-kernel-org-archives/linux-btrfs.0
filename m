Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310Ab3BMMQ7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 07:16:59 -0500
Date: Wed, 13 Feb 2013 13:16:55 +0100
From: Karel Zak <kzak@redhat.com>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, sandeen@redhat.com,
        Zach Brown <zabrown@redhat.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
Message-ID: <20130213121655.GA7799@x2.net.home>
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com>
 <20130212202753.GC26694@dastard>
 <20130213080154.GC18597@x2.net.home>
 <alpine.LFD.2.00.1302131127070.2315@(none)>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <alpine.LFD.2.00.1302131127070.2315@(none)>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 13, 2013 at 11:41:08AM +0100, Lukáš Czerner wrote:
> However
> 
> mkfs.btrfs /dev/sda
> mkfs.ext4 -F /dev/sda
> 
> works well, however I am not sure why that is. Is that some kind of
> mount(8) magic ?

 This is bug in libmount. Fixed in upstream tree. The libmount in some
 cases ignores the ambivalent probing result from libblkid and tries 
 stuff from /etc/filesystems (where is for example ext4).

> So I think that liblkid _and_ btrfs tools has to be fixed not to treat
> backup superblocks as primary!

 The problem with additional btrfs superblocks has been already reported
 to btrfs guys:

   http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg20957.html

 and I don't see a reply "yep, this is btrfs-progs bug" :-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
