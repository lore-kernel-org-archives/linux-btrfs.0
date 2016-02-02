Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36393 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbcBBWGj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Feb 2016 17:06:39 -0500
Received: by mail-ig0-f175.google.com with SMTP id z14so71854703igp.1
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Feb 2016 14:06:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56B12742.9090101@friedels.name>
References: <56AFCEC3.9050803@friedels.name>
	<20160201221120.GD8313@carfax.org.uk>
	<56B12742.9090101@friedels.name>
Date: Tue, 2 Feb 2016 15:06:38 -0700
Message-ID: <CAJCQCtS3fQuypTbwTe4=H95rwtN0dMih_nPaBiWUc2s-qE2Xag@mail.gmail.com>
Subject: Re: booting from BTRFS works only with one device in the pool
From: Chris Murphy <lists@colorremedies.com>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 2, 2016 at 3:01 PM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Hello Hugo,
>
>>> Here I am stuck in a recovery prompt.
>>
>>     By far the simplest and most reliable method of doing this is to
>> use an initramfs with the command "btrfs dev scan" in it somewhere
>> before mounting. Most of the major distributions already have an
>> initramfs set up (as does yours, I see), and will install the correct
>> commands in the initramfs if you install the btrfs-progs package
>> (btrfs-tools in Debian derivatives).
>>
> I would like to go the sensible way :-)
> But can you hint me how and where to add the btrfs device scan option to the
> initramfs?

If btrfs-progs 4.3.1 is installed already, dracut -f will rebuild the
initramfs and should just drag in current tools which will include
'btrfs device scan'.

-- 
Chris Murphy
