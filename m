Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35410 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbbKMRaS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 12:30:18 -0500
Received: by lbbsy6 with SMTP id sy6so29159459lbb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 09:30:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56461034.3070209@gmail.com>
References: <CAHTEL3=r8kUJOU=xUAg2iG52HuWmqQ16QxUjY6d+zqbziW5+gw@mail.gmail.com>
	<564486F3.5020804@gmail.com>
	<CAHTEL3mEGmc5BhbGMEAbyPNU90nFQGZprLkWrh1WaEh5sSiH8w@mail.gmail.com>
	<56461034.3070209@gmail.com>
Date: Fri, 13 Nov 2015 18:30:16 +0100
Message-ID: <CAHTEL3m0uGWZGWUH_SLmg8TqMe4DcXU77p+S=4Aebukr1BZ-Bg@mail.gmail.com>
Subject: Re: illegal snapshot, cannot be deleted
From: Vedran Vucic <vedran.vucic@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Here are outputs of commands as you requested:
 btrfs fi df /
Data, single: total=8.00GiB, used=7.71GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=1.12GiB, used=377.25MiB
GlobalReserve, single: total=128.00MiB, used=0.00B

btrfs fi show
Label: none  uuid: d6934db3-3ac9-49d0-83db-287be7b995a5
        Total devices 1 FS bytes used 8.08GiB
        devid    1 size 18.71GiB used 10.31GiB path /dev/sda6

btrfs-progs v4.0+20150429

Thanks,

vedran

On Fri, Nov 13, 2015 at 5:30 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-11-13 11:12, Vedran Vucic wrote:
>>
>> Hello,
>>
>> I succeeded to delete illegal snapshot with command:
>> btrfs subvolume delete /.snapshots/741/snapshot
>> When I have done
>> btrfs balance / -dusage=0 -musage=0
>> increasing value up to 4o I did not have issues.
>> But on value 4- for-dusage= and -musage=
>> I got message that there is no space left on disk.
>> Do you have any advice how to manage that?
>
>
> Can you post the output of 'btrfs fi df' and 'btrfs fi show' again? Both
> should have changed after the balance, and I'd need to see what it looks
> like now to be able to give any reasonable advice.
>
>
