Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36354 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbcHLSCh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Aug 2016 14:02:37 -0400
Received: by mail-oi0-f66.google.com with SMTP id b22so2640068oii.3
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Aug 2016 11:02:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1471023419.16857.9.camel@gmail.com>
References: <1471023419.16857.9.camel@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 12 Aug 2016 12:02:36 -0600
Message-ID: <CAJCQCtSwHCkW_nUNp4-R=S+ExZMk97i2qr6MwSuRU540c6xtfg@mail.gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 12, 2016 at 11:36 AM, Ronan Arraes Jardim Chagas
<ronisbr@gmail.com> wrote:
> Hi guys,
>
> I'm facing a daily problem with BTRFS. Almost everyday, I get the
> message "No space left on device". Sometimes I can recover by balancing
> the system but sometimes even balancing does not work due to the lack
> of space. In this case, only a hard reset works if I can't delete some
> files. The problem is that I have a huge unallocated space as you can
> see here:
>
> # btrfs fi usage /
> Overall:
>     Device size:                   1.26TiB
>     Device allocated:            119.07GiB
>     Device unallocated:            1.14TiB

Tons of unallocated space. What kernel messages do you get for the
enospc? It sounds like this will be one of the mystery -28 error file
systems. So far as I recall the only work around is recreating the
file system. There are two additional things you can try: mount with
enospc_debug mount option and see if you can gather more information
about the problem. Or try a 4.8rc1 kernel which as a large number of
enospc changes.


-- 
Chris Murphy
