Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38061 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933714AbbEOBJf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 May 2015 21:09:35 -0400
Received: by wicnf17 with SMTP id nf17so116764781wic.1
        for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2015 18:09:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150515003329.GA17120@mew>
References: <CA+5PVA5HhK07LHXcPxDV=JztgdRRa+2LsK7RJXDZ-Y+esAqX1g@mail.gmail.com>
	<pan$f2ed7$f0336ef0$1026d216$35cc450c@cox.net>
	<20150515003329.GA17120@mew>
Date: Thu, 14 May 2015 19:09:34 -0600
Message-ID: <CAJCQCtRgT9-zm8ywOP4GkLykY8tznpsL+1upDZmiDVneYgtQNA@mail.gmail.com>
Subject: Re: btrfs balance 4.0 regression?
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 14, 2015 at 6:33 PM, Omar Sandoval <osandov@osandov.com> wrote:
>
>
> Yup, Chris says he has a proper fix but it hasn't hit the list yet.
>
>
> Actually, ext4 convert is broken anyways (with irrelevant output
> elided):


I'm curious how this bug ended up in mainline. Isn't there an XFS test
for both balance+convert and ext4 convert? If not, shouldn't there be?
It's not a data loss bug but Btrfs is in a transitional stretch where
functionality loss bugs are no longer minor. (I'd look but I'm lazy
and xfs tests doesn't appear to be indexed.)


-- 
Chris Murphy
