Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45252 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161558AbaJaCij (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 22:38:39 -0400
Message-ID: <5452F626.4070102@oracle.com>
Date: Fri, 31 Oct 2014 10:38:30 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Rene Thomas <re.thomas@gmx.de>
CC: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: read block failed check_tree_block / Couldn't read chunk tree
References: <CAHOQfW0CF1CrHrZ_T_G49kXh6scKK59aYYZn48fi112RfHX=wg@mail.gmail.com>	<545062CC.6020206@oracle.com>	<CAHOQfW2hKtjJ=oCGp2KbvbtBsWxQpo+zforzrashVO7zDAmLHg@mail.gmail.com>	<5451B65A.9090302@oracle.com> <CAHOQfW1PJ4m4KEHkwp4sKBL9ttNwv+ZpLPG4PKx9ewXWsCJhQQ@mail.gmail.com>
In-Reply-To: <CAHOQfW1PJ4m4KEHkwp4sKBL9ttNwv+ZpLPG4PKx9ewXWsCJhQQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



There might be more than one issue. I was trying solve errors

Check tree block failed, want=5845480062976, have=0

when 'btrfs fi show' was run.  Thanks for confirming patchout
helped to fix that.



On 31/10/2014 00:47, Rene Thomas wrote:
> With commit patched out.
>
> All devices in Place
>
> uname -a
> Linux engelserver 3.18.0-031800rc1-generic #201410192135 SMP Mon Oct
> 20 01:37:04 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>
> root@engelserver:/# btrfs --version
> Btrfs v3.17-dirty
>
> root@engelserver:/# btrfs fi show
> Label: 'mythstorage'  uuid: 9b454272-6800-4b3c-b196-9e180407a6cb
> Total devices 1 FS bytes used 4.27MiB
> devid    1 size 931.51GiB used 2.04GiB path /dev/sdh1
>
> Label: none  uuid: 8ef575d9-2465-479c-bf9c-067e2e417770
> Total devices 3 FS bytes used 3.02TiB
> devid    1 size 2.73TiB used 1.77TiB path /dev/sdf1
> devid    2 size 2.73TiB used 1.77TiB path /dev/sda1
> devid    3 size 2.73TiB used 1.77TiB path /dev/sdg1
>
> Btrfs v3.17-dirty
>
> root@engelserver:/# dmesg | grep -i btrfs
> [   12.144778] Btrfs loaded
> [   12.155656] BTRFS: device label mythstorage devid 1 transid 633 /dev/sdh1
> [   12.167277] BTRFS info (device sdh1): enabling auto defrag
> [   12.178478] BTRFS info (device sdh1): disk space caching is enabled
> [   13.008943] BTRFS: device fsid 8ef575d9-2465-479c-bf9c-067e2e417770
> devid 1 transid 32270 /dev/sdf1
> [   13.017482] BTRFS: device fsid 8ef575d9-2465-479c-bf9c-067e2e417770
> devid 3 transid 32270 /dev/sdg1
> [   13.020782] BTRFS: device fsid 8ef575d9-2465-479c-bf9c-067e2e417770
> devid 2 transid 32270 /dev/sda1
>
> root@engelserver:/# mount -t btrfs -o recovery,ro /dev/sdf1 /home
> mount: wrong fs type, bad option, bad superblock on /dev/sdf1,
>         missing codepage or helper program, or other error
>         In some cases useful info is found in syslog - try
>         dmesg | tail  or so
>
> [  440.600286] BTRFS info (device sda1): enabling auto recovery
> [  440.600288] BTRFS info (device sda1): disk space caching is enabled
> [  440.601304] BTRFS (device sda1): bad tree block start 0 5845480062976
> [  440.601854] BTRFS (device sda1): bad tree block start 0 5845480054784
> [  440.601971] BTRFS (device sda1): bad tree block start 0 5845480067072
> [  440.602203] BTRFS (device sda1): bad tree block start 0 5845480050688
> [  440.602467] BTRFS (device sda1): bad tree block start 0 5845480071168
> [  440.602720] BTRFS (device sda1): bad tree block start 0 5845480058880
> [  440.603000] BTRFS (device sda1): bad tree block start 0 5845480075264
> [  440.603270] BTRFS (device sda1): bad tree block start 0 5845480079360
> [  440.603558] BTRFS (device sda1): bad tree block start 0 5845480046592
> [  440.603685] BTRFS (device sda1): bad tree block start 0 5845480091648
> [  440.630760] BTRFS: Failed to read block groups: -5
> [  440.651385] BTRFS: open_ctree failed
>
> Remove affected device (reboot)
>
> dmesg
> [   11.809442] Btrfs loaded
> [   11.835961] BTRFS: device label mythstorage devid 1 transid 634 /dev/sdc1
> [   11.847034] BTRFS info (device sdc1): enabling auto defrag
> [   11.857649] BTRFS info (device sdc1): disk space caching is enabled
> [   12.586106] BTRFS: device fsid 8ef575d9-2465-479c-bf9c-067e2e417770
> devid 2 transid 32270 /dev/sda1
> [   12.599428] BTRFS: device fsid 8ef575d9-2465-479c-bf9c-067e2e417770
> devid 3 transid 32270 /dev/sdb1
>
> root@engelserver:/# btrfs fi sh
> Label: 'mythstorage'  uuid: 9b454272-6800-4b3c-b196-9e180407a6cb
> Total devices 1 FS bytes used 4.27MiB
> devid    1 size 931.51GiB used 2.04GiB path /dev/sdc1
>
> Label: none  uuid: 8ef575d9-2465-479c-bf9c-067e2e417770
> Total devices 3 FS bytes used 3.02TiB
> devid    2 size 2.73TiB used 1.77TiB path /dev/sda1
> devid    3 size 2.73TiB used 1.77TiB path /dev/sdb1
> *** Some devices missing
>
> Btrfs v3.17-dirty
>
> root@engelserver:/# mount -t btrfs -o ro,degraded /dev/sda1 /home
> mount: wrong fs type, bad option, bad superblock on /dev/sda1,
>         missing codepage or helper program, or other error
>         In some cases useful info is found in syslog - try
>         dmesg | tail  or so
>
> root@engelserver:/# dmesg | grep -i btrfs
> [  299.792397] BTRFS info (device sdb1): allowing degraded mounts
> [  299.792400] BTRFS info (device sdb1): disk space caching is enabled
> [  299.964814] BTRFS (device sdb1): bad tree block start 0 5845002854400
> [  299.964896] BTRFS (device sdb1): bad tree block start 0 5845002854400
> [  299.964965] BTRFS: Failed to read block groups: -5
> [  299.987542] BTRFS: open_ctree failed
>
> root@engelserver:/# btrfs restore -i /dev/sda1 /media/mythstorage/
> warning, device 1 is missing
> warning, device 1 is missing
> warning devid 1 not found already
> Check tree block failed, want=5845480062976, have=65536
> Check tree block failed, want=5845480062976, have=65536
> read block failed check_tree_block
> Couldn't read chunk tree
> Could not open root, trying backup super
> warning, device 1 is missing
> warning, device 1 is missing
> warning devid 1 not found already
> Check tree block failed, want=5845480062976, have=65536
> Check tree block failed, want=5845480062976, have=65536
> read block failed check_tree_block
> Couldn't read chunk tree
> Could not open root, trying backup super
> warning, device 1 is missing
> warning, device 1 is missing
> warning devid 1 not found already
> Check tree block failed, want=5845480062976, have=65536
> Check tree block failed, want=5845480062976, have=65536
> read block failed check_tree_block
> Couldn't read chunk tree
> Could not open root, trying backup super
>
> root@engelserver:/# btrfs rescue chunk-recover -v /dev/sdb1
>
> http://sebsauvage.net/paste/?ed4437f335d9a563#Hy3yzV8fIrgEotLNs3dPg+xX4loQZ/DMxOhXQ/HqdVc=
>
> root@engelserver:/# btrfs rescue super-recover -v /dev/sda1
> All Devices:
> Device: id = 3, name = /dev/sdc1
> Device: id = 1, name = /dev/sdb1
> Device: id = 2, name = /dev/sda1
>
> Before Recovering:
> [All good supers]:
> device name = /dev/sdc1
> superblock bytenr = 65536
>
> device name = /dev/sdc1
> superblock bytenr = 67108864
>
> device name = /dev/sdc1
> superblock bytenr = 274877906944
>
> device name = /dev/sdb1
> superblock bytenr = 65536
>
> device name = /dev/sdb1
> superblock bytenr = 67108864
>
> device name = /dev/sdb1
> superblock bytenr = 274877906944
>
> device name = /dev/sda1
> superblock bytenr = 65536
>
> device name = /dev/sda1
> superblock bytenr = 67108864
>
> device name = /dev/sda1
> superblock bytenr = 274877906944
>
> [All bad supers]:
>
> All supers are valid, no need to recover
>
> Did I miss anything?
>
> Thanks
> René
>
> 2014-10-30 4:54 GMT+01:00 Anand Jain <Anand.Jain@oracle.com>:
>>
>>
>>
>>   yes that's the one.
>>
>>> btrfs-progs: fix device missing of btrfs fi show with seed devices
>>
>> Thanks
>>
>>
>>
>> On 10/29/2014 08:15 PM, Rene Thomas wrote:
>>>
>>> Can't find commit in official repos
>>>
>>> Get "fatal: bad object 915902c5002485fb13d27c4b699a73fb66cc0f09" from git
>>> show
>>>
>>> Found
>>> ----------------------------
>>> commit 2513077f2f830b4bc83d528bfb6979eb461918bd
>>>
>>> btrfs-progs: fix device missing of btrfs fi show with seed devices
>>> ----------------------------
>>>
>>> Thanks
>>> René
>>>
>>> 2014-10-29 4:45 GMT+01:00 Anand Jain <Anand.Jain@oracle.com>:
>>>>
>>>>
>>>> this is (most likely) due to patch below,
>>>> ----------------
>>>> commit 915902c5002485fb13d27c4b699a73fb66cc0f09
>>>>
>>>>       btrfs-progs: fix device missing of btrfs fi show with seed devices
>>>> ----------------
>>>>
>>>>    Could you try to back out the patch from progs and give it a shot ?
>>>>    and pls report what you see. Thanks.
>>>>
>>>>
>>>>
>>>>
>>>>
>>>> On 10/25/14 00:43, Rene Thomas wrote:
>>>>>
>>>>>
>>>>>     # btrfs --version
>>>>> Btrfs v3.17
>>>>>
>>>>>     # btrfs fi show
>>>>> Label: 'mythstorage'  uuid: 9b454272-6800-4b3c-b196-9e180407a6cb
>>>>>            Total devices 1 FS bytes used 2.36MiB
>>>>>            devid    1 size 931.51GiB used 10.04GiB path /dev/sdd1
>>>>>
>>>>>     Check tree block failed, want=5845480062976, have=0
>>>>> Check tree block failed, want=5845480062976, have=0
>>>>> Check tree block failed, want=5845480062976, have=65536
>>>>> Check tree block failed, want=5845480062976, have=0
>>>>> Check tree block failed, want=5845480062976, have=0
>>>>> read block failed check_tree_block
>>>>> Couldn't read chunk tree
