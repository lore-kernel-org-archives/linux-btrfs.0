Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30156 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaIMFcR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Sep 2014 01:32:17 -0400
Message-ID: <5413D7E5.6080905@oracle.com>
Date: Sat, 13 Sep 2014 13:36:37 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: "xavier.gnata@gmail.com" <xavier.gnata@gmail.com>,
        Johannes Hirte <johannes.hirte@datenkhaos.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: "Btrfs: device_list_add() should not update list when mounted"
 breaks subvol mount
References: <20140911002241.201bc6c2@datenkhaos.de> <54110AEC.6040301@oracle.com> <54135AE7.40400@gmail.com>
In-Reply-To: <54135AE7.40400@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Xavier,

  Thanks for the report.

  I got this reproduced: its a very corner case, it depends on the
  device path given in the subsequent subvol mounts, the fix appear
  to be outside of this patch at this moment and I am digging to know
  if we need to normalize the device path before using it in the btrfs
  kernel, just like btrfs-progs did recently.


  reproducer:
  ls -l /root/dev/sde-link
    /root/dev/sde-link -> /dev/sde

  mount -o device=/root/dev/sde-link /dev/sdd /btrfs1
  btrfs fi show
  Label: none  uuid: 943bf422-998c-4640-9d7f-d49f17b782ce
	Total devices 2 FS bytes used 272.00KiB
	devid    1 size 1.52GiB used 339.50MiB path /dev/sdd
	devid    2 size 1.52GiB used 319.50MiB path /root/dev/sde-link

  mount -o subvol=sv1,device=/dev/sde /dev/sdd /btrfs  <-shouldn't fail.
   mount: /dev/sdd already mounted or /btrfs busy
   mount: according to mtab, /dev/sdd is mounted on /btrfs1

  mount -o device=/root/dev/sde-link /dev/sdd /btrfs
   echo $?
   0


Xavier, Johannes,

     The quickest workaround for you will be to try to match
  the device path as in the btrfs fi show -m </mnt> output to
  your probably fstab/mnttab entry.


Anand

On 09/13/2014 04:43 AM, xavier.gnata@gmail.com wrote:
> Hi,
>
> On standard ubuntu 14.04 a with an encrypted (cryptsetup) /home as brtfs
> subvolume we have the following results:
> 3.17-rc2 : Ok.
> 3.17-rc3 and 3.17-rc4 :  /home fails to mount on boot. If one try mount
> -a then the system tells that the partition is already mounted according
> to matab.


>
> On a 3.17-rc4, btrfs fi sh returns nothing special:
> "
> Label: none  uuid: f4f554bb-57d9-4647-ab14-ea978c9e7e9f
>          Total devices 1 FS bytes used 131.41GiB
>          devid    1 size 173.31GiB used 134.03GiB path /dev/sda5
>
> Btrfs v3.12
> "
>
> I'm not sure if it has something to do with cryptsetup...
>
>
> Xavier
>
>> Hi Johannes,
>>
>>> I've two more systems with kernel version >3.17-rc3
>>> running and no problem like this.
>>
>>  Does this 3.17-rc3 also has the same type of subvol config
>>  and it mount operation/sequence as you mentioned ?
>>
>> > - one hdd with btrfs
>> > - default subvolume (rootfs) is different from subovlid=0
>> > - at boot, several subvols are mounted at /home/$DIR
>>
>>  I ran a few tests, on our mainline
>>  ----
>>  mount -o subvol=sv1 /dev/sdh1 /btrfs
>>  mount /dev/sdh1 /btrfs
>>   mount: /dev/sdh1 already mounted or /btrfs busy [*]
>>  mount /dev/sdh1 /btrfs1
>>  echo $?
>>  0
>>  -----
>>
>>  [*] hope this isn't the problem you are mentioning.
>>
>> Thanks, Anand
