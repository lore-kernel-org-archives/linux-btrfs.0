Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34837 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab2LSQ6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Dec 2012 11:58:05 -0500
Received: by mail-pa0-f51.google.com with SMTP id fb11so1451258pad.10
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Dec 2012 08:58:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5848153.J4MMzXfUGd@bursa22>
References: <CAMiUzp95BXF8fcNb9EQQsrz1NpDtX9qr=FdC9C=+r3KYkYxgzw@mail.gmail.com>
	<5848153.J4MMzXfUGd@bursa22>
Date: Wed, 19 Dec 2012 17:58:04 +0100
Message-ID: <CAMiUzp9A7e6=YoLpL1kCpOip4P4LFtskmZUe0_DEJP9WCrD3UQ@mail.gmail.com>
Subject: Re: Online Deduplication for Btrfs (Master's thesis)
From: =?UTF-8?B?TWFydGluIEvFmcOtxb5law==?= <martin.krizek@gmail.com>
To: Hubert Kario <hka@qbs.com.pl>
Cc: linux-btrfs@vger.kernel.org, lczerner@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 17, 2012 at 2:12 PM, Hubert Kario <hka@qbs.com.pl> wrote:
> On Monday 17 of December 2012 13:05:01 Martin Křížek wrote:
>> * Limitations
>> Not really limitations, but this is a list of situations when dedup will
>> not be triggered:
>> - compression - basically, dedup is kind of compression, might be worth to
>> into it in the future though
>
> I don't see why it would be incompatible, compressed blocks are data like
> any other. COW and subvolume snapshots work with compressed nodes just as
> well as with regular ones...
>

I agree, I am not saying it's incompatible, just that I probably won't
deal with that unless time permits.

Thanks,
Martin
