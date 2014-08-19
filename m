Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:52698 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaHSQ4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 12:56:43 -0400
Received: by mail-ie0-f169.google.com with SMTP id rd18so1469161iec.0
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Aug 2014 09:56:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140819162151.GA15166@forwiss.uni-passau.de>
References: <20140819162151.GA15166@forwiss.uni-passau.de>
Date: Tue, 19 Aug 2014 09:56:43 -0700
Message-ID: <CAM9fjH6t4P0U7wFgrcQcjMp0o58O00NFOhVbDPjhtYvcxgw1-g@mail.gmail.com>
Subject: Re: Questions on using BtrFS for fileserver
From: Kyle Manna <2bluesc@gmail.com>
To: M G Berberich <btrfs@oss.m-berberich.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> · Besides using bcache, are there any possibilities to boost
>   performance by adding (dedicated) cache-SSDs to a BtrFS?

dm-cache is in the mainline kernel and lvm2 recently added support to
make devicemapper configuration automatic.  In my opinion, dm-cache is
a little easier to use because you can add/remove/resize the cache
without recreating the filesystem.  If you're interested, take a peek
at the man page for lvmcache.

- Kyle
