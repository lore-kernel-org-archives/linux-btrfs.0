Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from x1-6-a4-2b-8c-8c-bd-da.cpe.webspeed.dk ([2.104.2.239]:52680
	"EHLO mail.musikcheck.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462AbcECLNp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 07:13:45 -0400
In-Reply-To: <20160503102746.GN7228@carfax.org.uk>
References: <983F0471-51E8-47EC-B5A0-FBA9040F634B@hagenjohansen.dk> <20160503095515.GM7228@carfax.org.uk> <B66776EA-68EA-490F-862E-C49A1D51FCE5@hagenjohansen.dk> <20160503102746.GN7228@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Subvolumes cannot be mounted after raid1 conversion
From: Hasse Hagen Johansen <hasse@hagenjohansen.dk>
Date: Tue, 03 May 2016 13:13:33 +0200
To: Hugo Mills <hugo@carfax.org.uk>
CC: linux-btrfs@vger.kernel.org
Message-ID: <DF5803A5-7C03-461B-B72C-A374FE57ABBF@hagenjohansen.dk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok. Thanks for the info. I will look into it some more and return when I find out what happens. Thanks for the help until now


On 3. maj 2016 12.27.46 CEST, Hugo Mills <hugo@carfax.org.uk> wrote:
>On Tue, May 03, 2016 at 12:24:52PM +0200, Hasse Hagen Johansen wrote:
>> Ok.  I can mount it manually just fine now using this command : sudo
>mount -t btrfs -o subvol=music /dev/sde /mnt/temp
>> 
>> But somehow I cannot mount it at /music anymore(and I just found out
>that is what has been tricking me) 
>> 
>> I have also tried with this in fstab 
>> 
>> /dev/sde  /music          btrfs
>device=/dev/sdd,device=/dev/sde,subvol=music          0       2
>> 
>> But I don't get any errors anyway (and no errors in dmesg) 
>> 
>> The exact thing I did was having the subvols mounted. Then mounted
>top-level volume on /mbt/temp. And then ran balance to convert to
>raid1.. When finished I umounted /mnt/temp (the top-level) and then my
>3 subvolumes was unmounted and a cannot mount them at the same
>mountpoints again... No errors and it says that it is not mounted when
>trying to umount them. So it seems they don't get mounted at all and
>without throwing an error
>> 
>> I will look into it more thoroughly now that I can at least mount the
>subvols on other mountpoints than the original 
>
>   Given those symptoms (mount doesn't report errors, but no mount
>happens), I would guess that your problem is with systemd. It has a
>bug where it sometimes unmounts things immediately after you've
>mounted them.
>
>   Hugo.
>
>-- 
>Hugo Mills             | "You know, the British have always been nice
>to mad
>hugo@... carfax.org.uk | people."
>http://carfax.org.uk/  |
>PGP: E2AB1DE4          |                         Laura Jesson, Brief
>Encounter

-- 
Sendt fra min telefon med K9 Mail. Undskyld hvis jeg er lidt kortfattet.
