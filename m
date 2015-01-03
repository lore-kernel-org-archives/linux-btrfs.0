Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:59639 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbbACSzd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Jan 2015 13:55:33 -0500
Received: by mail-ig0-f175.google.com with SMTP id h15so850199igd.2
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Jan 2015 10:55:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$872b8$2e173aaa$59613c61$c4e30dfd@cox.net>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
	<54A7D3D1.10508@shiftmail.org>
	<pan$872b8$2e173aaa$59613c61$c4e30dfd@cox.net>
Date: Sat, 3 Jan 2015 12:55:27 -0600
Message-ID: <CAAe=sHXzrAoFr9wPUk49F5kV6knpWM7PtdxfNWBRXvpU0b+PgQ@mail.gmail.com>
Subject: Re: I need to P. are we almost there yet?
From: "sys.syphus" <syssyphus@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>
> But btrfs raid56 mode should be complete with kernel 3.19 and presumably
> btrfs-progs 3.19 tho I'd give it a kernel or two to mature to be sure.
> N-way-mirroring (my particular hotly awaited feature) is next up, but
> given the time raid56 took, I don't think anybody's predicting when it'll
> be actually in-tree and ready for use.
>

is that the feature where you say i want x copies of this file and y
copies of this other file? e.g. raid at the file level, with the
ability to adjust redundancy by file?

I wonder if there is any sort of bandaid you can put on top of btrfs
to give some of this redundancy. things exist like git annex, but i
don't love it's bugs and oddball selection of programming language.

Do you guys use any other open source tools on top of btrfs to help
manage your data? (i.e. git annex; camlistore)
