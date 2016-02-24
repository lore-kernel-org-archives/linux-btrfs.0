Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:33474 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbcBXKBi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 05:01:38 -0500
Received: by mail-lf0-f54.google.com with SMTP id m1so8409591lfg.0
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 02:01:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160223172635.GI22487@merlins.org>
References: <CAGGqMYS=O=zzZE2pK=Stx6OwrZn1Fz59oYBS+jbSHfu4Ovv68Q@mail.gmail.com>
 <04df0eaf-9dc8-b9fa-05cb-020507940bed@mokrynskyi.com> <pan$9ab32$bee891f3$832766e9$6d69ce8@cox.net>
 <20160223172635.GI22487@merlins.org>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Wed, 24 Feb 2016 11:01:16 +0100
Message-ID: <CAA7pwKMkrraeCcusTaKDjinKQ5YPgAyRPoKa+66XOZefYhi8Tg@mail.gmail.com>
Subject: Re: Major HDD performance degradation on btrfs receive
To: Marc MERLIN <marc@merlins.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23 February 2016 at 18:26, Marc MERLIN <marc@merlins.org> wrote:
>
> I'm currently doing a very slow defrag to see if it'll help (looks like
> it's going to take days).
> I'm doing this:
> for i in dir1 dir2 debian32 debian64 ubuntu dir4 ; do echo $i; time btrfs fi defragment -v -r $i; done
[snip]
> Also, should I try running defragment -r from cron from time to time?

I find the default threshold a bit low and defragment daily with "-t
1m" to combat heavy random write fragmentation.

Once in a while I defrag e.g. VM disk images with "-t 128m" but find
higher thresholds mostly a waste of time.

YMMV.


> But, just to be clear, is there a way I missed to see how fragmented my
> filesystem is without running filefrag on millions of files and parsing
> the output?

I don't think so, and filefrag is slow with heavily fragmented files
because ioctl(FS_IOC_FIEMAP) is called many times with a buffer which
only fits 292 fiemap_extents.
