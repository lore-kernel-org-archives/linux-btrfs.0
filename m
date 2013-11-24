Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:59567 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab3KXONp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 09:13:45 -0500
Received: by mail-vc0-f179.google.com with SMTP id ie18so2146939vcb.10
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Nov 2013 06:13:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131124135032.GE28883@carfax.org.uk>
References: <CAD_cGvHFg11+RhqYDcu=zcUWpRAi85WqW7Wm5K040J_+h_mcGw@mail.gmail.com>
	<20131124135032.GE28883@carfax.org.uk>
Date: Sun, 24 Nov 2013 15:13:44 +0100
Message-ID: <CAD_cGvEXj2cLjzifw1WHc3dPBqnr-F32B=T4h2y0qn+bbYY04A@mail.gmail.com>
Subject: Re: The state of btrfs RAID6 as of kernel 3.13-rc1
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: Hans-Kristian Bakke <hkbakke@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you.

Are the missing RAID5/6 standard features beeing worked on at the
moment or could it just as well take several years until the basic
features are in place and working?
Mvh

Hans-Kristian Bakke


On 24 November 2013 14:50, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sun, Nov 24, 2013 at 02:47:56PM +0100, Hans-Kristian Bakke wrote:
>> Hi
>>
>> What is the general state of btrfs RAID6 as of kernel 3.13-rc1 and the
>> latest btrfs tools?
>>
>> More specifically:
>> - Is it able to correct errors during scrubs?
>
>    Not yet, I believe.
>
>> - Is it able to transparently handle disk failures without downtime?
>
>    Not yet.
>
>> - Is it possible to convert btrfs RAID10 to RAID6 without recreating the fs?
>
>    Yes.
>
>> - Is it possible to add/remove drives to a RAID6 array?
>
>    Yes.
>
>    HTH,
>    Hugo.
>
>> Regards,
>>
>> Hans-Kristian
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>       --- Normaliser unix c'est comme pasteuriser le Camembert ---
