Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:53905 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3JKPOa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 11:14:30 -0400
Received: by mail-ie0-f182.google.com with SMTP id as1so6660084iec.13
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Oct 2013 08:14:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52580EE5.8090408@redhat.com>
References: <20131010102043.74230@gmx.com>
	<pan$d3f39$3d6ac9b9$db7362c7$80c1ae2b@cox.net>
	<52580EE5.8090408@redhat.com>
Date: Fri, 11 Oct 2013 18:14:29 +0300
Message-ID: <CAELSAVYqeoj=SoaqtVENxfVjv10ZmFOruHNe6pGCjtkTGy8=WQ@mail.gmail.com>
Subject: Re: BUG relating to fstrim on btrfs partitions
From: Emil Karlson <jekarlson@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Duncan <1i5t5.duncan@cox.net>, Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> If the filesystem is clever enough to know that the range in question has
> not been written to since the last discard, then it takes no action, and
> reports zero bytes.

File system images can be rewritten on a new media so there is a
drawback to that.

Best Regards
-Emil
