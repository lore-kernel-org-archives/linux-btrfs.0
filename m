Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35547 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965012AbcDLPtB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Apr 2016 11:49:01 -0400
Received: by mail-ig0-f178.google.com with SMTP id gy3so91270944igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Apr 2016 08:49:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRiTcy3OSA60G=N7LMA3xEpjeqmxv+gNyv7E+HyvG68Mg@mail.gmail.com>
References: <CAAcrkYLYu7Gk8_O+vMYp3B2z+yJiktp7AyEc1mONNHtA8kpxUw@mail.gmail.com>
 <CAJCQCtSagDUoA_tf4tTMMYK3K5bCtmHNSRjc=OLgoLYQpXw0cg@mail.gmail.com>
 <CAAcrkYK9C41wrXWkw4pgfrpSGgUbZ3amSD1y49_06dPH8oERgw@mail.gmail.com> <CAJCQCtRiTcy3OSA60G=N7LMA3xEpjeqmxv+gNyv7E+HyvG68Mg@mail.gmail.com>
From: lenovomi <lenovomi@gmail.com>
Date: Tue, 12 Apr 2016 17:48:30 +0200
Message-ID: <CAAcrkYK=Hd5xvEXp-51JMD1_kMYfsHR9Pt3DRNoq+HTi=eTALg@mail.gmail.com>
Subject: Re: KERNEL PANIC + CORRUPTED BTRFS?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

i tried these:


1)

 mount -o ro,recovery  /dev/sda /mnt/usb

[ 1707.971925] BTRFS info (device sdd): enabling auto recovery
[ 1707.971933] BTRFS info (device sdd): disk space caching is enabled
[ 1708.005073] BTRFS: sdd checksum verify failed on 17802818387968
wanted BFB02AEC found FF45E2D3 level 1
[ 1708.005230] BTRFS: sdd checksum verify failed on 17802818387968
wanted BFB02AEC found FF45E2D3 level 1
[ 1708.005244] BTRFS: failed to read tree root on sdd
[ 1708.005395] BTRFS: sdd checksum verify failed on 17802818387968
wanted BFB02AEC found FF45E2D3 level 1
[ 1708.005550] BTRFS: sdd checksum verify failed on 17802818387968
wanted BFB02AEC found FF45E2D3 level 1
[ 1708.005562] BTRFS: failed to read tree root on sdd
[ 1708.509471] BTRFS: sdd checksum verify failed on 17802812309504
wanted BFB02AEC found 75187952 level 1
[ 1709.004781] BTRFS: sdd checksum verify failed on 17802812309504
wanted BFB02AEC found 75187952 level 1
[ 1709.004819] BTRFS: failed to read tree root on sdd
[ 1709.026808] BTRFS: sdd checksum verify failed on 17802806853632
wanted BFB02AEC found B6624BB6 level 1
[ 1709.109491] BTRFS: sdd checksum verify failed on 17802806853632
wanted BFB02AEC found B6624BB6 level 1
[ 1709.109521] BTRFS: failed to read tree root on sdd
[ 1709.111635] BTRFS: sdd checksum verify failed on 17802801315840
wanted BFB02AEC found 55A30545 level 1
[ 1709.113389] BTRFS: sdd checksum verify failed on 17802801315840
wanted BFB02AEC found 55A30545 level 1
[ 1709.113426] BTRFS: failed to read tree root on sdd
[ 1709.139603] BTRFS: open_ctree failed

2)
root@ubuntu:/home/ubuntu# btrfs check --readonly -s0 /dev/sda
using SB copy 0, bytenr 65536
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
Csum didn't match
Couldn't read tree root
Couldn't open file system
root@ubuntu:/home/ubuntu# btrfs check --readonly -s1 /dev/sda
using SB copy 1, bytenr 67108864
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
Csum didn't match
Couldn't read tree root
Couldn't open file system
root@ubuntu:/home/ubuntu# btrfs check --readonly -s2 /dev/sda
using SB copy 2, bytenr 274877906944
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
Csum didn't match
Couldn't read tree root
Couldn't open file system
root@ubuntu:/home/ubuntu# btrfs check --readonly -s3 /dev/sda
ERROR: super mirror should be less than: 3


3) restore

root@ubuntu:/home/ubuntu# btrfs restore -D -v  /dev/sda /mnt/usb/
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
Csum didn't match
Couldn't read tree root
Could not open root, trying backup super
warning, device 2 is missing
warning devid 2 not found already
warning devid 3 not found already
warning devid 4 not found already
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
Csum didn't match
Couldn't read tree root
Could not open root, trying backup super
warning, device 2 is missing
warning devid 2 not found already
warning devid 3 not found already
warning devid 4 not found already
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
Csum didn't match
Couldn't read tree root
Could not open root, trying backup super


4) Everything is failing up to this point, any other ideas?:(


thanks



On Tue, Apr 12, 2016 at 5:43 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Mon, Apr 11, 2016 at 3:51 PM, lenovomi <lenovomi@gmail.com> wrote:
>> Hi,
>>
>> i didnt try mount -o ro, when i tried to mount it via esata i got
>> kernel panic immediately. Then i conntected enclosure with drives via
>> usb and tried to mount it :
>
> OK so try '-o ro,recovery' and report back what you get.
>
>
>
>>
>> https://bpaste.net/show/641ab9172539
>> plugged via usb -> mount randomly one of the drive mount /dev/sda /mnt/brtfs
>>
>> I was told on irc channel that i should not run btrfs check and if so
>> i should run it as
>> btrfs check --repair --init-extent-tree
>>
>>
>> Also there was recommendation to run btrfs restore before repair.
>
> Did you use btrfs restore?
> https://btrfs.wiki.kernel.org/index.php/Restore
>
> And did you use --repair --init-extent-tree? I don't recommend it
> until you use restore as well.
>
>
>
>> Still not clear what should i do as next step.
>
> 1. mount with -o ro,recovery  and get important date backed up. It
> sounds like you don't have a backup?
>
> 2. If that doesn't work, use btrfs restore. It's tedious but at least
> you can update your backup.
>
> 3. Next try btrfs check without repair. There's some nuance whether
> it's better to use init-extent-tree or try zeroing the log. But don't
> use repair until there's a current backup with 1 or 2.
>
> --
> Chris Murphy
