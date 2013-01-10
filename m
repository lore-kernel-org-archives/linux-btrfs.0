Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:45255 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3AJRQW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 12:16:22 -0500
Received: by mail-ie0-f179.google.com with SMTP id k14so1116320iea.38
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 09:16:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130110114329.GC20089@twin.jikos.cz>
References: <CACCfv7ouftvEwAg0HWxCVSaOh+Q=K0+T65n0L4KJRqVa-e2_NA@mail.gmail.com>
	<50ECAC5C.9080902@electronsweatshop.com>
	<CACCfv7roxHpeBd5PCUEwn9ACFpq4396wHSMg2itEsf6k3CDkrA@mail.gmail.com>
	<50EE38DC.6000802@electronsweatshop.com>
	<20130110114329.GC20089@twin.jikos.cz>
Date: Fri, 11 Jan 2013 03:46:21 +1030
Message-ID: <CACCfv7oWBNB4sBSSsENdTzqRuXOmQRrKSEW2oFXg1R71LP6gLw@mail.gmail.com>
Subject: Re: Btrfs fs not mounting or being identified after power loss.
From: Jordan Windsor <jordanw2@gmail.com>
To: dsterba@suse.cz
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I've already recreated btrfs on the partition, so there'd be nothing
useful to send.
Thanks.

On Thu, Jan 10, 2013 at 10:13 PM, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Jan 09, 2013 at 10:43:24PM -0500, Randy Barlow wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> > kernel is at 3.6.11-1-ARCH
>>
>> Sorry I don't know much to help you, but I would suggest perhaps using
>> a newer kernel in the future. It sounds like your FS might be in
>> trouble as is, but I would recommend using the most recent RC kernel
>> (3.8-rc3) and restoring your data to a new btrfs from backups. In
>> general, it's a good idea to stick to pretty recent kernels with btrfs.
>
> There are some problems with the 3.8-rc kernels, please do not use them
> yet, and I don't think that kernel upgrade would help in Jordan's case.
>
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
