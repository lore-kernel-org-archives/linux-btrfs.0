Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:34980 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbbHOMv2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Aug 2015 08:51:28 -0400
Received: by iodt126 with SMTP id t126so109918606iod.2
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2015 05:51:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55CEC72D.4060503@oracle.com>
References: <CAK7bmU9vTap5JdkhCDNB=6BC4_fsU-6MCmS3QiFP1Mu2C7yjng@mail.gmail.com>
	<CAK7bmU-a6W1UaPf31WargEGzQdWH7-GDN9Vd1h_1GnQwv-_FsQ@mail.gmail.com>
	<55CEC72D.4060503@oracle.com>
Date: Sat, 15 Aug 2015 08:51:27 -0400
Message-ID: <CAK7bmU9Hwz9ekQQhC+kzAJ_f1Jyzk5_=LLd4aPZN7f-Q2L3POw@mail.gmail.com>
Subject: Re: "delete missing" with two missing devices doesn't delete both
 missing, only does a partial reconstruction
From: Timothy Normand Miller <theosib@gmail.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I didn't quite understand "profile and convert", since I can't find a
profile option.  Is this something your patch adds?

Before I do that, however, I have to deal with this:

compute0 ~ # btrfs device delete missing /mnt/btrfs
ERROR: error removing the device 'missing' - Input/output error

[13058.298763] BTRFS warning (device sdc): csum failed ino 596 off
623218688 csum 2756583412 expected csum 4104700738
[13058.298775] BTRFS warning (device sdc): csum failed ino 596 off
623222784 csum 2568037276 expected csum 275151414
[13058.298782] BTRFS warning (device sdc): csum failed ino 596 off
623226880 csum 2227564114 expected csum 3824181799
[13058.298788] BTRFS warning (device sdc): csum failed ino 596 off
623230976 csum 3298529275 expected csum 1155389604
[13058.298794] BTRFS warning (device sdc): csum failed ino 596 off
623235072 csum 2603391790 expected csum 1861925401
[13058.298801] BTRFS warning (device sdc): csum failed ino 596 off
623239168 csum 2044148708 expected csum 3227559459
[13058.298807] BTRFS warning (device sdc): csum failed ino 596 off
623243264 csum 615351306 expected csum 2720021058
[13058.329747] BTRFS warning (device sdc): csum failed ino 596 off
623218688 csum 2756583412 expected csum 4104700738
[13058.329759] BTRFS warning (device sdc): csum failed ino 596 off
623222784 csum 2568037276 expected csum 275151414
[13058.329770] BTRFS warning (device sdc): csum failed ino 596 off
623226880 csum 2227564114 expected csum 3824181799

Because of this, it won't delete the missing device.  How do I get
past this?  I'm pretty sure the problem is in some files I want to
delete anyhow.  Would deleting them solve the problem?

On Sat, Aug 15, 2015 at 12:59 AM, Anand Jain <anand.jain@oracle.com> wrote:
>
>> BTW, when this is all over with, how do I make sure there are really
>> two copies of everything?  Will a scrub verify this?  Should I run a
>> balance operation?
>
> pls use 'btrfs bal profile and convert' to migrate single chunk (if any
> created when there were lesser number of RW-able devices) back to your
> desired raid1. Do this when all the devices are back online. Kindly note
> there is a bug in the btrfs VM that you won't be able to bring a device
> online with out unmount -> mount (I am working to fix). btrfs-progs will be
> wrong in this case don't depend too much on that.
> So to understand inside of btrfs kernel volume I generally use:
>     https://patchwork.kernel.org/patch/5816011/
>
> In there if bdev is null it indicates device is scanned but not part of VM
> yet. Then unmount -> mount will bring device back to be part of VM.
>
>>> After applying Anand's patch, I was able to mount my 4-drive RAID1
>>> and bring a new fourth drive online.
>
>>> However, something weird happened
>>> where the first "delete missing" only deleted one missing drive and
>>> only did a partial duplication.  I've posted a bug report here:
>
> that seems to be normal to me. unless I am missing something else / clarity.
>
>
> Thanks, Anand



-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
