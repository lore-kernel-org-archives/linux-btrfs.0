Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:38539 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab3CVHGj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 03:06:39 -0400
Message-ID: <514C02F5.4030003@profihost.ag>
Date: Fri, 22 Mar 2013 08:06:29 +0100
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>
CC: Roman Mamedov <rm@romanrm.ru>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: No space left on device (28)
References: <514ABEB8.3090104@profihost.ag> <20130321180020.30044.84729@localhost.localdomain> <967ED686-7E9C-4158-80A0-D58D18818BA2@profihost.ag> <20130321190249.30044.79438@localhost.localdomain> <514B62A4.1030201@profihost.ag> <20130322121356.237e57e8@natsu> <CAE5mzvizzxotHP2OikoBZ1+OuHm_WBgMVHuWnm+Unr+DfAfXxQ@mail.gmail.com> <48C0CCB4-5381-4569-B777-472EC2EF1725@profihost.ag> <CAE5mzvh4mdVLagEFynZOqoM_7_3Yrojd2WLowWGw-AqZPhH1XQ@mail.gmail.com>
In-Reply-To: <CAE5mzvh4mdVLagEFynZOqoM_7_3Yrojd2WLowWGw-AqZPhH1XQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Am 22.03.2013 07:41, schrieb cwillu:> On Fri, Mar 22, 2013 at 12:39 AM,
Stefan Priebe - Profihost AG
> <s.priebe@profihost.ag> wrote:
>> Already tried with value 5 did not help ;-( and it also happens with
>> plain cp copying a 15gb file and aborts at about 80%
>
> You tried -musage=5?  Your original email said -dusage=5.

sorry i missed the difference - but it does not work:

~# btrfs fi balance start -musage=5 /mnt/
ERROR: error during balancing '/mnt/' - No space left on device
There may be more info in syslog - try dmesg | tail

~# dmesg|tail
[ 1183.019367] device fsid fc23c4a8-a351-4c91-96a2-ee6abeffe59a devid 1
transid 6224 /dev/mapper/raid54tb1
[ 1183.019860] btrfs: disk space caching is enabled
[42719.915781] btrfs: relocating block group 4194304 flags 4
[42727.916141] btrfs: 5 enospc errors during balance

Stefan
