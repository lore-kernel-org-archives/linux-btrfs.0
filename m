Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:34041 "EHLO
	mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbbEZSut (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 14:50:49 -0400
Received: by qkgx75 with SMTP id x75so97220335qkg.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 11:50:48 -0700 (PDT)
Message-ID: <1432666245.4677.15.camel@kepstin.ca>
Subject: Re: intermittent -ENOSPC errors on btrfs filesystem with 170G free
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Tue, 26 May 2015 14:50:45 -0400
In-Reply-To: <CAJCQCtQsCU9OhSPRjqTS30i8KeC-_aa9SG+qmViA_q5po00QrQ@mail.gmail.com>
References: <20150526173634.GU11340@wantstofly.org>
	 <20150526180820.GG16826@carfax.org.uk>
	 <CAJCQCtQsCU9OhSPRjqTS30i8KeC-_aa9SG+qmViA_q5po00QrQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2015-05-26 at 12:18 -0600, Chris Murphy wrote:
> Oh yeah easy to miss, but obvious once pointed out:
> 
> > Data, single: total=227.94GiB, used=58.16GiB
> 
> I thought we had automatic deallocation of unused chunks but I guess
> it hasn't landed yet.

We do have automatic deallocation of unused chunks. (I know it's in 
4.0, dunno about earlier versions.)

Unfortunately, this only deallocates *completely* unused chunks - if 
you're e.g. writing a bunch of small files and large files at the same 
time, then delete the large files, you could end up with a bunch of 
data chunks that are mostly, but not completely, empty: they still 
have the small files hanging around.

In this case a balance is still necessary to clean things up.

-- 
Calvin Walton <calvin.walton@kepstin.ca>
