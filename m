Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:36826 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbcCFW1v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Mar 2016 17:27:51 -0500
Received: by mail-io0-f170.google.com with SMTP id z76so11840742iof.3
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Mar 2016 14:27:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRonySo0VqUeWtqG2Eu9N3VxL9LHmEgnpRQVu2tOaJqOw@mail.gmail.com>
References: <CAO2Nr8dqVBiOSTLxdS-E_WoKk13mJkGJ9PB7qOBDq-1YhHi-Gg@mail.gmail.com>
	<20160301162758.GA27786@carfax.org.uk>
	<CAGfcS_nXei2FszQz_-HoeOi04vhWw9YF3LKwd+2zRxmW1Wiupw@mail.gmail.com>
	<CAJCQCtRonySo0VqUeWtqG2Eu9N3VxL9LHmEgnpRQVu2tOaJqOw@mail.gmail.com>
Date: Sun, 6 Mar 2016 17:27:50 -0500
Message-ID: <CAGfcS_kwQU5YsDBjw8LnDLd14ebDOq7b1ei9fSyQof-SvEwnQA@mail.gmail.com>
Subject: Re: btrfs raid
From: Rich Freeman <rich0@gentoo.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 6, 2016 at 4:07 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Sun, Mar 6, 2016 at 5:01 AM, Rich Freeman <rich0@gentoo.org> wrote:
>
>> I think it depends on how you define "old."  I think that 3.18.28
>> would be fine as it is a supported longterm.
>
> For raid56? I disagree. There were substantial raid56 code changes in
> 3.19 that were not backported to 3.18.

Of course.  I was referring to raid1.  I wouldn't run raid56 without
an expectation of occasionally losing everything on any version of
linux.  :)  If I were just testing it or I could tolerate losing
everything occasionally I'd probably track the current stable, if not
mainline, depending on my goals.

-- 
Rich
