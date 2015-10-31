Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33143 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbbJaWpQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Oct 2015 18:45:16 -0400
Received: by lbbec13 with SMTP id ec13so68694924lbb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2015 15:45:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56352AEA.7040907@uni-koeln.de>
References: <5634DD93.9050605@uni-koeln.de>
	<20151031164112.GF21103@carfax.org.uk>
	<5634FB01.9030602@uni-koeln.de>
	<20151031183337.GG21103@carfax.org.uk>
	<56352AEA.7040907@uni-koeln.de>
Date: Sat, 31 Oct 2015 23:45:15 +0100
Message-ID: <CAPmG0jYNmTvuKnbRfYcViCQFnghL5LYnj_KyCOCLqVynseY2BA@mail.gmail.com>
Subject: Re: How to delete this snapshot, and how to succeed with balancing?
From: Henk Slager <eye1tm@gmail.com>
To: Simon King <simon.king@uni-koeln.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Simon,

>>> linux-va3e:~ # btrfs balance start -dlimit=2 /
>>> ERROR: error during balancing '/' - No space left on device
>>> There may be more info in syslog - try dmesg | tail
>>
>>    And this is with a filesystem that's not fully allocated?
>> (i.e. btrfs fi show indicates that used and total are different for
>> each device). If that's the case, then you may have hit a known but
>> unfixed bug to do with space allocation.
>
> linux-va3e:~ # btrfs fi show
> Label: none  uuid: 656dc65f-240b-4137-a490-0175717dd7fa
>         Total devices 1 FS bytes used 13.71GiB
>         devid    1 size 20.00GiB used 16.88GiB path /dev/sda2
>
> btrfs-progs v4.0+20150429
>
> Is there a manual work-around?
For 'No space left on device', a trick I once saw is to run:

btrfs balance start -dusage=0 -musage=0 /

Under certain circumstances (i don't remember which kernel, tools
versions etc), this enables you to create files again on the
filesystem.
Looking at the   btrfs fi df /  output, I don't see a real need for
balancing, the numbers can be much different and then balance might be
usefull.

The 318 snaphot is more of a problem and you should get rid of
(some/unneeded/all) snapshots first. Default openSuse snapshot ages is
high (months and years) so maybe you want to edit configs
/etc/snapper/configs/<>
/etc/sysconfig/snapper

to keep snapshot age just 1 or 2 days or so, but it really depends on
how you use the notebook and the subvolumes on the filesystem. Or
maybe you just disable snapper snapshotting completely, as 20GB will
quite easily get too full with default snapper config. A crontask will
automatically delete too old snapshots based on the snapper config.

if command (318 or with higher snapshot number)
snapper -c root delete 1-318

does not work, or the crontask fails, try
btrfs sub del /.snapshots/<number>/snapshot

The 318 related error might also be fixed/workedaround by newer tools/kernel.
Maybe get newer (4.2.3) btrfstools from this repo
ttp://download.opensuse.org/repositories/filesystems/openSUSE_13.2/
and find some 4.1 kernel rpm for openSuse 13.2 (or compile your own
from kernel.org)

You could also start with a Leap/Tumbleweed liveDVD and mount your
/dev/sda2  somewhere and run the commands suggested above.

You should probably install/enable btrfsmaintenance package (and tune
its config) so that defrag and balancing runs as crontask.

And one important thing: A btrfs fi defragment with still many
snapshots around and 20GB rootfs will make the situation worse...

/Henk
