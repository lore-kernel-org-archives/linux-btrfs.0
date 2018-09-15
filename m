Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.idedalo.net ([178.33.75.195]:45780 "EHLO mx1.idedalo.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727052AbeIOSfU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Sep 2018 14:35:20 -0400
Subject: Re: Problem with BTRFS
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
References: <c7040285-599d-4f6c-cf16-50dc77c9b5f1@idedalo.com>
 <20180914224612.07a5db1b@natsu>
 <20180914181818.rnef5ml3wgelwjm5@DigitalMercury.dynalias.net>
 <3dcb98e2-a3e5-4166-a4e0-42dddf6b7080@idedalo.com>
 <20180914202443.b5jnos64d2gymrqz@DigitalMercury.dynalias.net>
From: =?UTF-8?Q?Rafael_Jes=c3=bas_Alc=c3=a1ntara_P=c3=a9rez?=
        <ralcantara@idedalo.com>
Message-ID: <1705124f-fc1f-f913-3f8a-417dce26b3f7@idedalo.com>
Date: Sat, 15 Sep 2018 15:16:18 +0200
MIME-Version: 1.0
In-Reply-To: <20180914202443.b5jnos64d2gymrqz@DigitalMercury.dynalias.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi:

I've installed the package from your link and it has fixed the issue ;)

$ sudo btrfs rescue fix-device-size /dev/sdc1
Fixed device size for devid 3, old size: 1999843081728 new size:
1999843078144
Fixed device size for devid 5, old size: 1999843081728 new size:
1999843078144
Fixed device size for devid 4, old size: 1999843081728 new size:
1999843078144
Fixed super total bytes, old size: 6010266660864 new size: 6010266652672
Fixed unaligned/mismatched total_bytes for super block and device items

Thank you very much.

El 14/09/18 a las 22:24, Nicholas D Steeves escribió:
> Hi,
> 
> On Fri, Sep 14, 2018 at 10:13:06PM +0200, Rafael Jesús Alcántara Pérez wrote:
>> Hi,
>>
>> It seems that btrfs-progs_4.17-1 from Sid, includes that feature (at
>> least, it says so in the manual page). I don't know if I can install it
>> on Stretch but I'll try.
>>
>> Greets and thank you very much to both of you ;)
>> Rafael J. Alcántara Pérez.
> 
> Please do not install btrfs-progs from sid on stretch, it's likely to
> break your system.  If you can't wait, here is a link to what I
> uploaded.  It includes both the source and the binary packages (see
> gpg signed changes file, and please take care to verify the binaries
> weren't tampered with):
> 
> https://drive.google.com/file/d/1WflwBEn-QN_btrKPiefz7Kxz58VT8kIQ/view?usp=sharing
> 
> Of course, this package is unofficial.  The official one will soon
> become available through the regular channels.
> 
> For best results, set up a local file:// apt repository so that apt
> update && apt upgrade will work properly.  Official bpo will
> automatically overwrite these, in any case.
> 
> Cheers,
> Nicholas
> 


-- 
