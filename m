Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:54691 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaATPze (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jan 2014 10:55:34 -0500
Received: by mail-we0-f182.google.com with SMTP id w62so7182218wes.27
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 07:55:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52DC9453.4000705@gmail.com>
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de>
	<CAPpBBdNfxchPw0DCLxNNoFZc5jGec88Q5j0C-uGy88oae0TDiw@mail.gmail.com>
	<52DC9453.4000705@gmail.com>
Date: Mon, 20 Jan 2014 22:55:33 +0700
Message-ID: <CAG1y0scoeKD7cGRtMUW3=HR+XKfRndGue7gjT4HgeyiJLy9Q7A@mail.gmail.com>
Subject: Re: btrfs and ECC RAM
From: "Fajar A. Nugraha" <list@fajar.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 20, 2014 at 10:13 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
>
> AFAIK, ZFS does background data scrubbing without user intervention


No, it doesn't.

> BTRFS however works differently, it only scrubs data when you tell it
> to.  If it encounters a checksum or read error on a data block, it
> first tries to find another copy of that block elsewhere (usually on
> another disk), if it still sees a wrong checksum there, or gets
> another read error, or can't find another copy, then it returns a read
> error to userspace,


zfs does the same thing.

-- 
Fajar
