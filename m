Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:34536 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbcCGSJ6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2016 13:09:58 -0500
Received: by mail-ig0-f177.google.com with SMTP id ir4so54519407igb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Mar 2016 10:09:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160307173811.GK6939@torres.zugschlus.de>
References: <20160307172717.GJ6939@torres.zugschlus.de>
	<20160307173811.GK6939@torres.zugschlus.de>
Date: Mon, 7 Mar 2016 11:09:57 -0700
Message-ID: <CAJCQCtRe4NXm5kC4svvO1det4NFN2fxUjDPSe7DFpOvXiL9X6w@mail.gmail.com>
Subject: Re: btrfs-image run time
From: Chris Murphy <lists@colorremedies.com>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 7, 2016 at 10:38 AM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> On Mon, Mar 07, 2016 at 06:27:17PM +0100, Marc Haber wrote:
>> how long is btrfs-image taking to run on a 400 GiB filesystem?
>>
>> I have /bin/btrfs-image -s -t 8 -s /dev/mapper/mydevice - | pixz -9 >
>> file.on.other.fs running for four hours now
>
> Strike my question please, I didn't see that I had the -s doubled.
> With one -s I now see actual progress.

Could be worth a bug report and a patch to keep it from using
duplicate switches.

-- 
Chris Murphy
