Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:51066 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaAGOvL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jan 2014 09:51:11 -0500
Received: by mail-ie0-f182.google.com with SMTP id as1so455357iec.27
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jan 2014 06:51:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52C6A917.90502@gmail.com>
References: <CAEx9m44ZiJLqTO1_G_rVfn+csD7_pOguEdiAjsvr3uPzna+mFA@mail.gmail.com>
 <52C30C8E.9020103@gmail.com> <20140103083950.GB29349@panda> <52C6A917.90502@gmail.com>
From: Aastha Mehta <aasthakm@gmail.com>
Date: Tue, 7 Jan 2014 15:50:51 +0100
Message-ID: <CAEx9m44p1zSaQPVZdcyEtaK7rObOP-U6z5ULvWeWg_78_PTbww@mail.gmail.com>
Subject: Re: question regarding caching
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: sander@humilis.net, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3 January 2014 13:12, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:
>
> On 2014-01-03 03:39, Sander wrote:
> > Austin S Hemmelgarn wrote (ao):
> >> The data is probably still cached in the block layer, so after
> >> unmounting, you could try 'echo 1 > /proc/sys/vm/drop_caches'
> >> before mounting again, but make sure to run sync right before
> >> doing that, otherwise you might lose data.
> >
> > Lose data? Where you get this from?
> >
> > Sander
> >
> Sorry, misread the documentation, thought it said destructive where it
> really said non-destructive.
> It's still a good idea to run sync before trying to clear the caches
> though, cause dirty objects aren't freeable.

Hello,

I figured out what the problem was. After remounting, I was doing
fseek to the end of file to calculate the file size. It seems that
fseek does prefetching of file data, which is why my reads were being
served from the cache rather than from the disk. I could not find
where this prefetching is called from. Anyways, using fstat instead of
fseek to find the file size ensures that there is no unwanted
prefetching.

Thanks,
Aastha.
