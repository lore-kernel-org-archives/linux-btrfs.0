Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:43211 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2KQQuV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Nov 2012 11:50:21 -0500
Received: by mail-qa0-f46.google.com with SMTP id c11so3912818qad.19
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Nov 2012 08:50:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50A7B583.90105@gmail.com>
References: <CAA+Oeuv=VthbT9HkEJm5REiNmOPSL0pPtV=gu4PXP1w1tM284A@mail.gmail.com>
	<50A7B583.90105@gmail.com>
Date: Sat, 17 Nov 2012 16:50:20 +0000
Message-ID: <CAMU1PDhQF5SLjDHosnaEp2uSukWrJN=Uk7qCpLCX5Pz9o8s-MQ@mail.gmail.com>
Subject: Re: How to remove btrfs information
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: Yangtse Su <yangtsesu@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 17 November 2012 16:04, Goffredo Baroncelli <kreijack@gmail.com> wrote:
> On 11/17/2012 03:52 AM, Yangtse Su wrote:
>> I have an btrfs part on /dev/sda5,Then I install windows8 with the
>> windows8 installer.I remove this btrfs part and install windows8 on
>> it.Now in my Linux,'btfrs filesystem show' still show /dev/sda5 as a
>> btrfs part. but now it is Microsoft Reserved part,only 128MB.
>>
>
> There was a patch about that [1] and David posted a script perl that
> does the same [2]. Moreover it seems that "wipefs" is also able to wipe
> out a btrfs super-block. I never tried it.
>
>
>> Here is some information:
>> http://paste.ubuntu.org.cn/155508
>
> Please the next time put all these info in the email
>
>> # blkid
>> ...
>> /dev/sda5: UUID="9c3e097a-bab0-4f18-b074-5cd2f081c8c7"
> UUID_SUB="ef0e296c-f554-415e-9aa9-31b1cb9aef31" TYPE="btrfs"
> /dev/sda6: UUID="3AFE3D50FE3D0623" TYPE="ntfs"
>> # btrfs filesystem show
>> Label: none  uuid: 9c3e097a-bab0-4f18-b074-5cd2f081c8c7
>>       Total devices 1 FS bytes used 284.00KB
>>       devid    1 size 33.48GB used 2.04GB path /dev/sda5
>> ...
>> Btrfs Btrfs v0.19
>> #gdisk /dev/sda
>> >p
>> Number  Start (sector)    End (sector)  Size       Code  Name
>> ......
>>    5       493025280       493287423   128.0 MiB   0C01  Microsoft
> reserved part
>>   6       493287424       625141759   62.9 GiB    0700  Basic data
> partition
>
>
> [1]http://comments.gmane.org/gmane.comp.file-systems.btrfs/17065
> [2]http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg16197.html

Yes wipefs is the simplest method.

Check first:
# wipefs /dev/sda5

Do it second:
# wipefs -a /dev/sda5

Mike
