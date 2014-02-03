Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:38811 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaBCUz6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Feb 2014 15:55:58 -0500
Received: by mail-qc0-f181.google.com with SMTP id e9so11960212qcy.40
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Feb 2014 12:55:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <C3B0EA86-0CBA-4500-81A8-7F3A99306E76@colorremedies.com>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com>
 <C0AD9885-8F81-4642-809F-BDC3933A5932@colorremedies.com> <20140130175831.GU3314@carfax.org.uk>
 <C3B0EA86-0CBA-4500-81A8-7F3A99306E76@colorremedies.com>
From: =?UTF-8?Q?Johan_Kr=C3=B6ckel?= <johan.kroeckel@gmail.com>
Date: Mon, 3 Feb 2014 21:55:17 +0100
Message-ID: <CABgvyo8ZG=pk=i-7iXzoOWqZj_fVvUd6xiaXef1KWR8QLibhXg@mail.gmail.com>
Subject: Re: lost with degraded RAID1
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-01-30 Chris Murphy <lists@colorremedies.com>:
>
> On Jan 30, 2014, at 10:58 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>
>> On Thu, Jan 30, 2014 at 10:33:21AM -0700, Chris Murphy wrote:
>>> You're doing an online conversion of a degraded raid1 volume into single? Does anyone know if this is expected or intended to work?
>>
>>   I don't see why not. One suggested method of recovering RAID from a
>> degraded situation is to rebalance over just the remaining devices
>> (space permitting, of course).
>
> Right but that's not a conversion. That's a regular balance on a degraded mount, with multiple remaining devices: e.g. a 4 disk raid1, drive fails, mount -o degraded, delete missing, then balance will replicate any missing 2nd copies onto three drives.
>
> The bigger problem at the moment is that -o degraded isn't working for Johan. The too many missing devices message seems like a bug and with limited information it may even be whatever that bug is, that cause the conversion to fail. Some 11GB were converted prior to the failure.
Which usefull information can provide. On the weekend I was at the
server and found out, that the vanishing of the drive at reboot was
strange behavior of the bios. So the drive is online again. but the
filesystem is still showing strange behavior, but now I can mount it
rw.
> Chris Murphy
