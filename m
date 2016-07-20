Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35209 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbcGTUU0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jul 2016 16:20:26 -0400
Received: by mail-oi0-f50.google.com with SMTP id l72so88163152oig.2
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jul 2016 13:20:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6acece40-1457-e4f3-646b-083780d8a251@gmail.com>
References: <A06BAA26-44FF-4947-B552-26ED228B5BF6@gmx.net> <179e2713-cd97-213c-3476-82f0b48c6442@gmail.com>
 <1378A988-195F-4E68-B6DE-30CEDFAC8474@gmx.net> <6acece40-1457-e4f3-646b-083780d8a251@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 20 Jul 2016 14:20:25 -0600
Message-ID: <CAJCQCtTQepjAtcmtC6mdrU4xmxbV4jbK2UPWr_ikaOzwjv1ntw@mail.gmail.com>
Subject: Re: Data recovery from a linear multi-disk btrfs file system
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Matt <langelino@gmx.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 15, 2016 at 12:52 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> Your own 'btrfs fi df' output clearly says that more than 99% of your data
> chunks are in a RAID0 profile, hence my statement.

Somewhen in ancient Btrfs list history, there was a call to change the
mkfs default for multiple device from data raid0 profile to single.
But I just tried it and it's still raid0. That's pretty risky for a
default as any file more than 64KiB is going to end up with an
unrecoverable hole in the data, and it might be that the OP was
expecting single profile when creating this file system and just
overlooked that it's raid0, not linear.

Even single profile is risky. Some users might be prepared to lose
some data on one failed device. But the safest option would be to use
raid1 (two copies only, should we one day get n-copies) profile for
data and metadata when the profile isn't otherwise specified. By
default.


-- 
Chris Murphy
