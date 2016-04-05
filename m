Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:36722 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149AbcDEDpM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Apr 2016 23:45:12 -0400
Received: by mail-ob0-f170.google.com with SMTP id j9so1103610obd.3
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 20:45:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$603b6$4c4f876d$1daf06de$ec75378d@cox.net>
References: <CA+WRLO-vu4B8X3Td12F0gueU70G6KwjRTD07MNwDrJfodAscNA@mail.gmail.com>
	<pan$603b6$4c4f876d$1daf06de$ec75378d@cox.net>
Date: Tue, 5 Apr 2016 13:45:11 +1000
Message-ID: <CA+WRLO_fmgogzErEdgNpnqJL2jozDRQGHrhUPt9aFtPb43iqyw@mail.gmail.com>
Subject: Re: Scrub priority, am I using it wrong?
From: Gareth Pye <gareth@cerberos.id.au>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 5, 2016 at 12:37 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> CPU bound, 0% IOWait even at idle IO priority, in addition to the
> hundreds of M/s values per thread/device, here.  You OTOH are showing
> under 20 M/s per thread/device on spinning rust, with an IOWait near 90%,
> thus making it IO bound.


And yes I'd love to switch to SSD, but 12 2TB drives is a bit pricey still

-- 
Gareth Pye - blog.cerberos.id.au
Level 2 MTG Judge, Melbourne, Australia
