Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:58892 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaLTIxF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Dec 2014 03:53:05 -0500
Received: by mail-yk0-f172.google.com with SMTP id 131so1041212ykp.31
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Dec 2014 00:53:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$97927$88ff6377$b9b2d72e$d33f9ad1@cox.net>
References: <20141217024228.GA5544@pyropus.ca>
	<5493E8B0.1080107@jp.fujitsu.com>
	<20141219165849.GA15104@pyropus.ca>
	<pan$97927$88ff6377$b9b2d72e$d33f9ad1@cox.net>
Date: Sat, 20 Dec 2014 01:53:03 -0700
Message-ID: <CAJCQCtTF4A1irkms=QxcxDyuVVTSEon5=7R+8=V7cj76GxiBYA@mail.gmail.com>
Subject: Re: Oddly slow read performance with near-full largish FS
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 19, 2014 at 10:33 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Charles Cazabon posted on Fri, 19 Dec 2014 10:58:49 -0600 as excerpted:

> There's also raid10, if you have enough devices or little enough data to
> do it.  That's much more mature than raid56 mode and should be about as
> mature and stable as btrfs in single-device mode, which is what you are
> using now.  But it'll require more devices than a raid56 would...

And also with such large storage stacks with big drives, when they
fail (note I use when not if) it takes a long time to restore. So if
you have the ability to break them up and use something like GlusterFS
to distribute it, it helps to mitigate this as well as other kinds of
failures like power supply, logic board, controllers, and with georep
even the entire local site.

This is not meant to indicate the current layout is wrong. Just that
there are other possibilities to achieve the desired up-time and data
safety.

-- 
Chris Murphy
