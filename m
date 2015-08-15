Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41277 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbbHOE7f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Aug 2015 00:59:35 -0400
Message-ID: <55CEC72D.4060503@oracle.com>
Date: Sat, 15 Aug 2015 12:59:25 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Timothy Normand Miller <theosib@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: "delete missing" with two missing devices doesn't delete both
 missing, only does a partial reconstruction
References: <CAK7bmU9vTap5JdkhCDNB=6BC4_fsU-6MCmS3QiFP1Mu2C7yjng@mail.gmail.com> <CAK7bmU-a6W1UaPf31WargEGzQdWH7-GDN9Vd1h_1GnQwv-_FsQ@mail.gmail.com>
In-Reply-To: <CAK7bmU-a6W1UaPf31WargEGzQdWH7-GDN9Vd1h_1GnQwv-_FsQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


 > BTW, when this is all over with, how do I make sure there are really
 > two copies of everything?  Will a scrub verify this?  Should I run a
 > balance operation?

pls use 'btrfs bal profile and convert' to migrate single chunk (if any 
created when there were lesser number of RW-able devices) back to your 
desired raid1. Do this when all the devices are back online. Kindly note 
there is a bug in the btrfs VM that you won't be able to bring a device 
online with out unmount -> mount (I am working to fix). btrfs-progs will 
be wrong in this case don't depend too much on that.
So to understand inside of btrfs kernel volume I generally use:
     https://patchwork.kernel.org/patch/5816011/

In there if bdev is null it indicates device is scanned but not part of 
VM yet. Then unmount -> mount will bring device back to be part of VM.

 >> After applying Anand's patch, I was able to mount my 4-drive RAID1
 >> and bring a new fourth drive online.

 >> However, something weird happened
 >> where the first "delete missing" only deleted one missing drive and
 >> only did a partial duplication.  I've posted a bug report here:

that seems to be normal to me. unless I am missing something else / clarity.


Thanks, Anand
