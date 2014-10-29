Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:65303 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513AbaJ2MPJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Oct 2014 08:15:09 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]) by mail.gmx.com
 (mrgmx002) with ESMTPSA (Nemesis) id 0MY7dI-1XWCbb04I4-00Uobt for
 <linux-btrfs@vger.kernel.org>; Wed, 29 Oct 2014 13:15:07 +0100
Received: by mail-qg0-f54.google.com with SMTP id q108so2135615qgd.27
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Oct 2014 05:15:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <545062CC.6020206@oracle.com>
References: <CAHOQfW0CF1CrHrZ_T_G49kXh6scKK59aYYZn48fi112RfHX=wg@mail.gmail.com>
	<545062CC.6020206@oracle.com>
Date: Wed, 29 Oct 2014 13:15:05 +0100
Message-ID: <CAHOQfW2hKtjJ=oCGp2KbvbtBsWxQpo+zforzrashVO7zDAmLHg@mail.gmail.com>
Subject: Re: read block failed check_tree_block / Couldn't read chunk tree
From: Rene Thomas <re.thomas@gmx.de>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can't find commit in official repos

Get "fatal: bad object 915902c5002485fb13d27c4b699a73fb66cc0f09" from git show

Found
----------------------------
commit 2513077f2f830b4bc83d528bfb6979eb461918bd

btrfs-progs: fix device missing of btrfs fi show with seed devices
----------------------------

Thanks
René

2014-10-29 4:45 GMT+01:00 Anand Jain <Anand.Jain@oracle.com>:
>
> this is (most likely) due to patch below,
> ----------------
> commit 915902c5002485fb13d27c4b699a73fb66cc0f09
>
>     btrfs-progs: fix device missing of btrfs fi show with seed devices
> ----------------
>
>  Could you try to back out the patch from progs and give it a shot ?
>  and pls report what you see. Thanks.
>
>
>
>
>
> On 10/25/14 00:43, Rene Thomas wrote:
>>
>>   # btrfs --version
>> Btrfs v3.17
>>
>>   # btrfs fi show
>> Label: 'mythstorage'  uuid: 9b454272-6800-4b3c-b196-9e180407a6cb
>>          Total devices 1 FS bytes used 2.36MiB
>>          devid    1 size 931.51GiB used 10.04GiB path /dev/sdd1
>>
>>   Check tree block failed, want=5845480062976, have=0
>> Check tree block failed, want=5845480062976, have=0
>> Check tree block failed, want=5845480062976, have=65536
>> Check tree block failed, want=5845480062976, have=0
>> Check tree block failed, want=5845480062976, have=0
>> read block failed check_tree_block
>> Couldn't read chunk tree
