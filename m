Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:35796 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbbEFDux (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 23:50:53 -0400
Received: by igbyr2 with SMTP id yr2so120636227igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 05 May 2015 20:50:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA=o1p=kKF3-fCbMsvHdtzTq5ya=-krfWH9K8_ayccV-puOVwg@mail.gmail.com>
References: <CAA=o1p=kKF3-fCbMsvHdtzTq5ya=-krfWH9K8_ayccV-puOVwg@mail.gmail.com>
Date: Tue, 5 May 2015 21:50:52 -0600
Message-ID: <CAJCQCtSrSHS+545vtKgyR=4dcAft4gQLBHZyHtr1+gLzJgM4Jg@mail.gmail.com>
Subject: Re: Compression: effect of chattr: wiki is contradictory
From: Chris Murphy <lists@colorremedies.com>
To: Rory Jaffe <rsjaffe@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 5, 2015 at 2:45 PM, Rory Jaffe <rsjaffe@gmail.com> wrote:

> never -- if the NOCOMPRESS flag is set per-file/-directory

Confused, what is this flag?

> if possible -- if the COMPRESS per-file flag (aka chattr +c) is set,
> but it may get converted to NOCOMPRESS eventually

Yeah earlier it says +c forces compression, but here it says "if
possible" which makes it more like the compress mount option (rather
than compress-force).


-- 
Chris Murphy
