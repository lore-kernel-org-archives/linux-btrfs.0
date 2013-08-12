Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:16169 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab3HLPQI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Aug 2013 11:16:08 -0400
Message-ID: <5208FC34.4080705@giantdisaster.de>
Date: Mon, 12 Aug 2013 17:16:04 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Emil Karlson <jekarlson@gmail.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible bug in send/receive with simple reproducer
References: <CAELSAVaZNofc+g8jgvbkiL7dmzv9jiFtYtNxDR1+UkLZyaCMmg@mail.gmail.com> <20130812145952.GC2150@localhost.localdomain>
In-Reply-To: <20130812145952.GC2150@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 12 Aug 2013 10:59:52 -0400, Josef Bacik wrote:
> On Sun, Aug 11, 2013 at 09:53:01PM +0300, Emil Karlson wrote:
>> Greetings
>>
>> Send fails for me unexpectedly:
>>
>> I get:
>> ERROR: rename o262-5-0 -> snapshots failed. No such file or directory
>>
>> reproducer ( http://users.tkk.fi/~jkarlson/files/test4.txt  ):
>>
>> for i in 1 2; do
>>   mkdir /mnt/$i
>>   truncate -s 4G /mnt/$i.img
>>   mkfs.btrfs /mnt/$i.img
>>   mount -o loop /mnt/$i.img /mnt/$i
>> done
>>
>> mkdir /mnt/1/testdir
>> mkdir /mnt/1/testdir/1/
>> mkdir /mnt/1/testdir/2/
>> dd if=/dev/urandom  of=/mnt/1/testdir/aa count=16
>> dd if=/dev/urandom  of=/mnt/1/testdir/bb count=16
>>
>> mkdir /mnt/1/snapshots
>> btrfs sub snap -r /mnt/1/ /mnt/1/snapshots/backup2
>> btrfs sub snap -r /mnt/1/ /mnt/1/snapshots/backup3
>> btrfs send /mnt/1/snapshots/backup3/ | btrfs receive /mnt/2/
>>
>> umount /mnt/{1,2}; rm /mnt/{1,2}.img; rmdir /mnt/{1,2}
> 
> This was perfect, thank you for that.  I've posted a fix and I'll turn this into
> an xfstest to make sure we don't ever regress.  Thanks again,
>

If you create a subvolume below /mnt/[12] and run the test there, you
have the problem reproduced again :)

for i in 1 2; do
 mkdir /mnt/$i
 truncate -s 4G /mnt/$i.img
 mkfs.btrfs /mnt/$i.img
 mount -o loop /mnt/$i.img /mnt/$i
done

btrfs subv create /mnt/1/sub
btrfs subv create /mnt/2/sub
mkdir /mnt/1/sub/testdir
mkdir /mnt/1/sub/testdir/1/
mkdir /mnt/1/sub/testdir/2/
dd if=/dev/urandom  of=/mnt/1/sub/testdir/aa count=16
dd if=/dev/urandom  of=/mnt/1/sub/testdir/bb count=16

mkdir /mnt/1/sub/snapshots
btrfs sub snap -r /mnt/1/sub/ /mnt/1/sub/snapshots/backup2
btrfs sub snap -r /mnt/1/sub/ /mnt/1/sub/snapshots/backup3
btrfs send /mnt/1/sub/snapshots/backup3/ | btrfs receive /mnt/2/sub/

umount /mnt/[12]; rm /mnt/[12].img; rmdir /mnt/[12]

