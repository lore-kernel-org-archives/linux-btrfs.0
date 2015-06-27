Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:24600 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbbF0QKC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Jun 2015 12:10:02 -0400
Message-ID: <558ECB0B.3060505@profihost.ag>
Date: Sat, 27 Jun 2015 18:10:51 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, clm@fb.com
Subject: Re: kernel 4.1: no space left on device
References: <558EC1F4.1050301@profihost.ag> <20150627205148.284ff359@natsu>
In-Reply-To: <20150627205148.284ff359@natsu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 27.06.2015 um 17:51 schrieb Roman Mamedov:
> On Sat, 27 Jun 2015 17:32:04 +0200
> Stefan Priebe <s.priebe@profihost.ag> wrote:
>
>> Hi,
>>
>> while having some big btrfs volumes (44TB + 37TB).
>>
>> I see on a regular basis the "no space left on device" message. I'm only
>> able to "fix" this. By running btrfs balance AND unmounting and
>> remounting the btrfs volume.
>>
>> Is there any way to debug / workaround this one?
>
> You should post your 'df', 'btrfs fi df' and 'btrfs fi show' for both devices.

sorry - here for one server:
[ ~]# btrfs filesystem df /vmbackup/
Data, single: total=7.58TiB, used=7.58TiB
System, DUP: total=8.00MiB, used=1.19MiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=69.00GiB, used=38.25GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=3.30MiB

[ ~]# btrfs fi show /vmbackup/
Label: none  uuid: 0df5ed87-07da-4c15-9a2b-1d0ff6ec208d
         Total devices 1 FS bytes used 7.62TiB
         devid    1 size 43.66TiB used 7.72TiB path /dev/md50

btrfs-progs v4.0.1

Stefan
