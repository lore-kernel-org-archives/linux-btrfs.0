Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36498 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbcDVJiD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Apr 2016 05:38:03 -0400
Received: by mail-io0-f174.google.com with SMTP id u185so113316903iod.3
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Apr 2016 02:38:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAcrkYKh_F_M3KC1YHs1PTT7zLsaTAkJageY5A3buhwGXT1YdA@mail.gmail.com>
References: <CAAcrkYLYu7Gk8_O+vMYp3B2z+yJiktp7AyEc1mONNHtA8kpxUw@mail.gmail.com>
 <CAJCQCtSagDUoA_tf4tTMMYK3K5bCtmHNSRjc=OLgoLYQpXw0cg@mail.gmail.com>
 <CAAcrkYK9C41wrXWkw4pgfrpSGgUbZ3amSD1y49_06dPH8oERgw@mail.gmail.com>
 <CAJCQCtRiTcy3OSA60G=N7LMA3xEpjeqmxv+gNyv7E+HyvG68Mg@mail.gmail.com>
 <CAAcrkYK=Hd5xvEXp-51JMD1_kMYfsHR9Pt3DRNoq+HTi=eTALg@mail.gmail.com>
 <CAJCQCtQ1sJKVb2dKfF7E2+OgFQCO2nKM0gZon62xo8058JrwvA@mail.gmail.com>
 <CAAcrkYJObUr_yUw1emfy2v3eBYLOkY_5VsTdYZ3cCJ7KoxWvTA@mail.gmail.com>
 <20160421052706.GB26182@localhost.localdomain> <CAAcrkYKKY+8MYsemOeahGHSf2Qofrwm4936ea+_cbphRoxeVWA@mail.gmail.com>
 <c893405d-4a47-fe69-827e-a0d91b891f5a@cn.fujitsu.com> <CAAcrkYKh_F_M3KC1YHs1PTT7zLsaTAkJageY5A3buhwGXT1YdA@mail.gmail.com>
From: lenovomi <lenovomi@gmail.com>
Date: Fri, 22 Apr 2016 11:37:32 +0200
Message-ID: <CAAcrkYLaQwZjWQqbg3wexHDfN18ctcDVFRk+9U75X8XtXmrPyg@mail.gmail.com>
Subject: Fwd: KERNEL PANIC + CORRUPTED BTRFS?
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello there,

any idea what are the next steps that i can proceed?

thank you



---------- Forwarded message ----------
From: lenovomi <lenovomi@gmail.com>
Date: Thu, Apr 21, 2016 at 9:29 AM
Subject: Re: KERNEL PANIC + CORRUPTED BTRFS?
To: Qu Wenruo <quwenruo@cn.fujitsu.com>


Hello,

files are uploaded here:
https://drive.google.com/folderview?id=0B6RZ_9vVuTEcUkhDM0VsYW1JWUE&usp=sharing

again, diff is exactly same ;-(


thanks

On Thu, Apr 21, 2016 at 9:21 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> lenovomi wrote on 2016/04/21 08:53 +0200:
>>
>> Hello Liu,
>>
>> please find both files stored here:
>>
>>
>> https://drive.google.com/folderview?id=0B6RZ_9vVuTEcMDV6eGNmRlZ0ZjQ&usp=sharing
>>
>>
>> Thanks
>>
>>
>>
>>
>>
>>
>> On Thu, Apr 21, 2016 at 7:27 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>>>
>>> On Wed, Apr 20, 2016 at 10:09:07PM +0200, lenovomi wrote:
>>>>
>>>> Hi Chris,
>>>>
>>>> please find below attached the complete log while executing all the
>>>> brtrfs commands, all of them failed.
>>>>
>>>> ;-(
>>>>
>>>>
>>>> https://bpaste.net/show/4d8877a49b80
>>>> https://bpaste.net/show/7e2e5aa30741
>>>> https://bpaste.net/show/482e91b25fc5
>>>> https://bpaste.net/show/5093cc3daa5a
>>>> https://bpaste.net/show/a24935eb5a1b
>>>
>>>
>>> It's not that easy to corrupt both of metadata copies which are located
>>> in two different drives by an unclean shutdown because we always do COW.
>>>
>>> From what I can tell from the above results, the two copies of raid1
>>> remain consistent and indentical, but somehow there are some problems in
>>> checksum field.
>>>
>>> ---------------------------------------------------------------------
>>> root@heap-unreal:/home/heap/btrfs-progs# ./btrfs check --readonly
>>> /dev/sda
>>> checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC,
>>> dev bytenr 2972268003328, devid 2
>>> checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC,
>>> dev bytenr 2972268003328, devid 2
>>> checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC,
>>> dev bytenr 2973311336448, devid 1
>>> checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC,
>>> dev bytenr 2972268003328, devid 2
>>> ---------------------------------------------------------------------
>>>
>>> In order to verify that, please follow this and show us what you get.
>>>
>>> 1. dd if=/dev/sdb of=/tmp/corrupt-dev2.txt bs=1 skip=2972268003327
>>> count=16384
>>> 2. dd if=/dev/sdd of=/tmp/corrupt-dev1.txt bs=1 skip=2973311336447
>>> count=16384
>>> 3. od -x /tmp/corrupt-dev2.txt
>>> 4. od -x /tmp/corrupt-dev1.txt
>
>
> It seems that your dump command is wrong. Your skip caused one byte offset.
> Just as Lenovomi's dump:
>
> 00000000: 00ec 2ab0 bf00 0000 0000 0000 0000 0000  ..*.............
>
> It should be ec2a b0bf.
>
> So Lenovomi, please dump it again with correct command:
>
> dd if=/dev/sdb of=/tmp/corrupt-dev2.txt bs=1 skip=2972268003328 count=16384
> dd if=/dev/sdd of=/tmp/corrupt-dev1.txt bs=1 skip=2973311336448 count=16384
>
> Thanks,
> Qu
>
>
>>>
>>> Thanks,
>>>
>>> -liubo
>>>
>>>>
>>>> Thanks
>>>>
>>>> On Tue, Apr 12, 2016 at 9:58 PM, Chris Murphy <lists@colorremedies.com>
>>>> wrote:
>>>>>
>>>>> On Tue, Apr 12, 2016 at 9:48 AM, lenovomi <lenovomi@gmail.com> wrote:
>>>>>
>>>>>> root@ubuntu:/home/ubuntu# btrfs restore -D -v  /dev/sda /mnt/usb/
>>>>>> checksum verify failed on 17802818387968 found FF45E2D3 wanted
>>>>>> BFB02AEC
>>>>>> checksum verify failed on 17802818387968 found FF45E2D3 wanted
>>>>>> BFB02AEC
>>>>>> checksum verify failed on 17802818387968 found FF45E2D3 wanted
>>>>>> BFB02AEC
>>>>>> checksum verify failed on 17802818387968 found FF45E2D3 wanted
>>>>>> BFB02AEC
>>>>>> Csum didn't match
>>>>>> Couldn't read tree root
>>>>>> Could not open root, trying backup super
>>>>>> warning, device 2 is missing
>>>>>> warning devid 2 not found already
>>>>>> warning devid 3 not found already
>>>>>> warning devid 4 not found already
>>>>>> checksum verify failed on 17802818387968 found FF45E2D3 wanted
>>>>>> BFB02AEC
>>>>>> checksum verify failed on 17802818387968 found FF45E2D3 wanted
>>>>>> BFB02AEC
>>>>>> Csum didn't match
>>>>>> Couldn't read tree root
>>>>>> Could not open root, trying backup super
>>>>>> warning, device 2 is missing
>>>>>> warning devid 2 not found already
>>>>>> warning devid 3 not found already
>>>>>> warning devid 4 not found already
>>>>>> checksum verify failed on 17802818387968 found FF45E2D3 wanted
>>>>>> BFB02AEC
>>>>>> checksum verify failed on 17802818387968 found FF45E2D3 wanted
>>>>>> BFB02AEC
>>>>>> Csum didn't match
>>>>>> Couldn't read tree root
>>>>>> Could not open root, trying backup super
>>>>>>
>>>>>
>>>>> Why are devices 2, 3, 4 missing? I think there's a known issue where
>>>>> btrfs fi show might see drives as available that other tools won't
>>>>> see. Try 'btrfs dev scan' and then repeat the restore command with -D
>>>>> just to see if the missing device warnings go away. If devices are
>>>>> missing, it's kinda hard to do a restore.
>>>>>
>>>>>
>>>>> If these are hard drives, there should be supers 0, 1, 2 and they
>>>>> should all be the same. But they may not be the same on each drive, so
>>>>> it's worth checking:
>>>>>
>>>>> btrfs-show-super -f <eachdevice>
>>>>>
>>>>> And then also btrfs-find-root <anydevice>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> Chris Murphy
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>>>>> in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>
