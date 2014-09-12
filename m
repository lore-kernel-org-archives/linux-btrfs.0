Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:34787 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaILUnV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 16:43:21 -0400
Received: by mail-we0-f172.google.com with SMTP id k48so1330687wev.3
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 13:43:20 -0700 (PDT)
Message-ID: <54135AE7.40400@gmail.com>
Date: Fri, 12 Sep 2014 22:43:19 +0200
From: "xavier.gnata@gmail.com" <xavier.gnata@gmail.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>,
        Johannes Hirte <johannes.hirte@datenkhaos.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: "Btrfs: device_list_add() should not update list when mounted"
 breaks subvol mount
References: <20140911002241.201bc6c2@datenkhaos.de> <54110AEC.6040301@oracle.com>
In-Reply-To: <54110AEC.6040301@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On standard ubuntu 14.04 a with an encrypted (cryptsetup) /home as brtfs 
subvolume we have the following results:
3.17-rc2 : Ok.
3.17-rc3 and 3.17-rc4 :  /home fails to mount on boot. If one try mount 
-a then the system tells that the partition is already mounted according 
to matab.


On a 3.17-rc4, btrfs fi sh returns nothing special:
"
Label: none  uuid: f4f554bb-57d9-4647-ab14-ea978c9e7e9f
         Total devices 1 FS bytes used 131.41GiB
         devid    1 size 173.31GiB used 134.03GiB path /dev/sda5

Btrfs v3.12
"

I'm not sure if it has something to do with cryptsetup...


Xavier

> Hi Johannes,
>
>> I've two more systems with kernel version >3.17-rc3
>> running and no problem like this.
>
>  Does this 3.17-rc3 also has the same type of subvol config
>  and it mount operation/sequence as you mentioned ?
>
> > - one hdd with btrfs
> > - default subvolume (rootfs) is different from subovlid=0
> > - at boot, several subvols are mounted at /home/$DIR
>
>  I ran a few tests, on our mainline
>  ----
>  mount -o subvol=sv1 /dev/sdh1 /btrfs
>  mount /dev/sdh1 /btrfs
>   mount: /dev/sdh1 already mounted or /btrfs busy [*]
>  mount /dev/sdh1 /btrfs1
>  echo $?
>  0
>  -----
>
>  [*] hope this isn't the problem you are mentioning.
>
> Thanks, Anand
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

