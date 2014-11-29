Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:34818 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbaK2VVZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 16:21:25 -0500
Received: by mail-qc0-f179.google.com with SMTP id c9so5999336qcz.24
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 13:21:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m5dcia$tk8$1@ger.gmane.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
	<20141125163905.GJ26471@twin.jikos.cz>
	<m5dash$58v$1@ger.gmane.org>
	<CAJBj3vd5tY93jkN7S25Am=c1A5iW=msqFDrOe-i9vYx9Phxwcg@mail.gmail.com>
	<m5dcia$tk8$1@ger.gmane.org>
Date: Sat, 29 Nov 2014 13:21:24 -0800
Message-ID: <CAJBj3ve8rfdAVLNwQ0ZxD8nQ3+5TwtTYXZ6BOMK0NquzHK15WA@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
From: John Williams <jwilliams4200@gmail.com>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 29, 2014 at 1:07 PM, Alex Elsayed <eternaleye@gmail.com> wrote:
> I'd suggest looking more closely at the crypto api section of menuconfig -
> it already has crc32c, among others. Just because it's called the "crypto
> api" doesn't mean it only has cryptographically-strong algorithms.

I have looked. What 128- or 256-bit hash functions in "crypto api" are
you referring to that are as fast as Spooky2 or CityHash?
