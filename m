Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:47008 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3C0OcQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 10:32:16 -0400
Received: by mail-oa0-f47.google.com with SMTP id o17so8755293oag.6
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 07:32:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130327091822.GC9290@carfax.org.uk>
References: <CAFvQSYS4o8iGTKYahX8zL3ng4Qre=uYDT7iOB0NTP+inUijQJQ@mail.gmail.com>
	<20130327091822.GC9290@carfax.org.uk>
Date: Wed, 27 Mar 2013 15:32:16 +0100
Message-ID: <CAFvQSYT3BnPHTGhSiMy7rGAasHnGFHPZFT6xNtMzb9mCyhxD8w@mail.gmail.com>
Subject: Re: "No space left on device" although df reports only 55% in use
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

>> # btrfs filesystem df .
>> Data: total=28.22GB, used=14.25GB
>> System, DUP: total=8.00MB, used=12.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, DUP: total=1.50GB, used=1.16GB
>
>    Your metadata is close to full -- we need quite a lot of working
> space to CoW into. You (probably) have the full disk allocated to
> chunks, and too much is allocated to data; not enough to metadata. You
> need o balance, with a filter for the unused data chunks. See the
> section in the FAQ on the wiki about full filesystems. (Sorry for not
> finding the link, I'm on a restricted connection right now)

I'll re-run the test on a filesystem created with -M (metadata and
normal data combined).
As far as I understand it shouldn't run in the same problem.

> Almost 400MB are not sufficient to do simple touch? What is it doing?
I have to admit that thought occurred to me too ;)

Regards, Clemens
