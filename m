Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:33937 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403AbcBXEhE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 23:37:04 -0500
Received: by mail-oi0-f54.google.com with SMTP id m82so5509658oif.1
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Feb 2016 20:37:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160224030236.GA30797@gmail.com>
References: <20160224004045.GA20632@gmail.com>
	<20160224015658.GY22487@merlins.org>
	<20160224030236.GA30797@gmail.com>
Date: Tue, 23 Feb 2016 21:37:03 -0700
Message-ID: <CAJCQCtQLY-zcz1e8zqNrekEfo1yo9DcDfwR_m4Y8AGaKxV32qg@mail.gmail.com>
Subject: Re: Input/Output errors
From: Chris Murphy <lists@colorremedies.com>
To: Kenny MacDermid <kenny.macdermid@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 23, 2016 at 8:02 PM, Kenny MacDermid
<kenny.macdermid@gmail.com> wrote:

>
> rw,noatime,compress=lzo,ssd,discard,space_cache,autodefrag,inode_cache

It sounds like an ssd trim bug. I'd check the firmware for updates. If
it's up to date, I'd drop discard mount option first and try to
reproduce. Or just use the default mount options and try to reproduce,
then add them back one at a time until you discover the culprit.

Also, how many files/directories are there? inode_cache isn't
recommended for most use cases. And space_cache is the default so it
doesn't need to be listed.



-- 
Chris Murphy
