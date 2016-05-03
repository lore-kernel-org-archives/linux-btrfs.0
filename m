Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from x1-6-a4-2b-8c-8c-bd-da.cpe.webspeed.dk ([2.104.2.239]:52144
	"EHLO mail.musikcheck.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbcECKZE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 06:25:04 -0400
Received: from [192.168.0.16]
	by mail.musikcheck.dk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.86_2)
	(envelope-from <hasse@hagenjohansen.dk>)
	id 1axXVm-0006dF-4x
	for linux-btrfs@vger.kernel.org; Tue, 03 May 2016 12:25:02 +0200
In-Reply-To: <20160503095515.GM7228@carfax.org.uk>
References: <983F0471-51E8-47EC-B5A0-FBA9040F634B@hagenjohansen.dk> <20160503095515.GM7228@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Subvolumes cannot be mounted after raid1 conversion
From: Hasse Hagen Johansen <hasse@hagenjohansen.dk>
Date: Tue, 03 May 2016 12:24:52 +0200
To: linux-btrfs@vger.kernel.org
Message-ID: <B66776EA-68EA-490F-862E-C49A1D51FCE5@hagenjohansen.dk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok.  I can mount it manually just fine now using this command : sudo mount -t btrfs -o subvol=music /dev/sde /mnt/temp

But somehow I cannot mount it at /music anymore(and I just found out that is what has been tricking me) 

I have also tried with this in fstab 

/dev/sde  /music          btrfs device=/dev/sdd,device=/dev/sde,subvol=music          0       2

But I don't get any errors anyway (and no errors in dmesg) 

The exact thing I did was having the subvols mounted. Then mounted top-level volume on /mbt/temp. And then ran balance to convert to raid1.. When finished I umounted /mnt/temp (the top-level) and then my 3 subvolumes was unmounted and a cannot mount them at the same mountpoints again... No errors and it says that it is not mounted when trying to umount them. So it seems they don't get mounted at all and without throwing an error

I will look into it more thoroughly now that I can at least mount the subvols on other mountpoints than the original 

Best regards
Hasse
-- 
Sendt fra min telefon med K9 Mail. Undskyld hvis jeg er lidt kortfattet.

On 3. maj 2016 11.55.15 CEST, Hugo Mills <hugo@carfax.org.uk> wrote:
>On Tue, May 03, 2016 at 10:52:36AM +0200, Hasse Hagen Johansen wrote:
>> Hi
>> 
>> I have made a btrfs on a single physical disk and made 3 subvolumes
>which I manually mounted and copied data to. Yesterday I added another
>disk to the filesystem and ran btrfs balance start -mconvert=raid1
>-dconvert=raid1 /mnt/temp where /mnt/temp is top-level fimesystem(not
>the subvolumes). After that have finished I cannot mount the individual
>subvolumes
>> 
>> can anyone explain how it is supposed to work. I can still see the
>files in the top-level filesystem but it seems subvolumes doesn't work
>after raid1 conversion
>
>   The balance should have made no difference.
>
> How are you trying to mount the subvols? (What commands/fstab config?)
>
>   What errors do you get when trying to mount?
>
>   Hugo.
>
>-- 
>Hugo Mills             | The Creature from the Black Logon
>hugo@... carfax.org.uk |
>http://carfax.org.uk/  |
>PGP: E2AB1DE4          |

-- 
Sendt fra min telefon med K9 Mail. Undskyld hvis jeg er lidt kortfattet.
