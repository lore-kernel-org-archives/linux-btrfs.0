Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:62326 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab3GAKQm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jul 2013 06:16:42 -0400
Received: by mail-la0-f52.google.com with SMTP id fo12so4200295lab.11
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jul 2013 03:16:40 -0700 (PDT)
Message-ID: <1372673798.3030.2.camel@Waves.darkmere>
Subject: Re: raid 10 corruption from single drive failure
From: "D. Spindel" <spider@skuggor.se>
To: cwillu <cwillu@cwillu.com>
Cc: linux-btrfs@vger.kernel.org
Date: Mon, 01 Jul 2013 12:16:38 +0200
In-Reply-To: <CAE5mzvhhMZGg7=Wy8CGZPzy93emHBNg+mqhjfo9GWmjvMBrSug@mail.gmail.com>
References: <1372492506.3088.0.camel@Waves.darkmere>
	 <CAE5mzvhhMZGg7=Wy8CGZPzy93emHBNg+mqhjfo9GWmjvMBrSug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On lör, 2013-06-29 at 03:08 -0600, cwillu wrote:
> 
> Not sure I entirely follow: mounting with -o degraded (not -o
> recovery) is how you're supposed to mount if there's a disk missing.

What I'm wondering about is why btrfsck segfaults, why it won't claim
which drive is supposedly "corrupt" in a data-loss case.  In this case
the drive was present, at least the first superblock should be readable,
but I get these somewhat strange issues.

Re-sending as I forgot CC.
( Curse you, evolution )

//D.S.



