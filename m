Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:64111 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaHNXQS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 19:16:18 -0400
Received: by mail-oa0-f45.google.com with SMTP id i7so1559045oag.32
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Aug 2014 16:16:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <08770CD2-AA55-4BC1-B92C-E7D3360399F8@colorremedies.com>
References: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com>
	<20140812011401.568c16e6@natsu>
	<AC90CAC7-A8F5-4C74-8295-4360A6A8FE45@colorremedies.com>
	<CADw2B2NnWFY=rOvArTDtnw2jkRe-HqNCcqeB0r80et60euEy3g@mail.gmail.com>
	<9EB33BE3-FAC0-4AE8-BB95-ABE68C578D47@colorremedies.com>
	<CADw2B2MGyDAvAxrZOML0kX_shdFD6QSyMV9XWxKfJAoZpLXsSQ@mail.gmail.com>
	<08770CD2-AA55-4BC1-B92C-E7D3360399F8@colorremedies.com>
Date: Thu, 14 Aug 2014 16:16:17 -0700
Message-ID: <CADw2B2NJQYn_xkrAebmdu_c-7z7yFNZ1aDFS=jYmQcHfco2d+g@mail.gmail.com>
Subject: Re: Large files, nodatacow and fragmentation
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 14, 2014 at 11:40 AM, Chris Murphy <lists@colorremedies.com> wrote:
> and there may be a fit for bcache here because you actually would get these random writes committed to stable media much faster in that case, and a lot of work has been done to make this more reliable than battery backed write caches on hardware raid.

umph... heard of bcache, but never looked at it or considered it as an
option in this scenario. After reading the doco and some of the design
documents, it's looking like bcache and md/mdadm or LVM could do the
trick.

The gotchas state clearly that btrfs on top of bcache is not recommended.

However, can bcache be put 'in front' of a btrfs raid10 volume? I
think not, since btrfs volumes are not presented as individual block
devices, instead you've got several block devices (e.g. /dev/sda and
/dev/sdb are in a btrfs raid1, and can be seen individually by the
OS)... however I wish it could, since bcache "...turns random writes
into sequential writes", which solve entirely the problem which
prompts the nocow option in btrfs.

Much to think on here.

-rb
