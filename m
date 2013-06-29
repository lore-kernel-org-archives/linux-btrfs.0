Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:40973 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3F2JIq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Jun 2013 05:08:46 -0400
Received: by mail-ie0-f175.google.com with SMTP id a13so6081101iee.34
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Jun 2013 02:08:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1372492506.3088.0.camel@Waves.darkmere>
References: <1372492506.3088.0.camel@Waves.darkmere>
Date: Sat, 29 Jun 2013 03:08:45 -0600
Message-ID: <CAE5mzvhhMZGg7=Wy8CGZPzy93emHBNg+mqhjfo9GWmjvMBrSug@mail.gmail.com>
Subject: Re: raid 10 corruption from single drive failure
From: cwillu <cwillu@cwillu.com>
To: "D. Spindel" <spider@skuggor.se>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Making this with all 6 devices from the beginning and btrfsck doesn't
> segfault. But it also doesn't repair the system enough to make it
> mountable. ( nether does -o recover, however -o degraded works, and
> files
> are then accessible )

Not sure I entirely follow: mounting with -o degraded (not -o
recovery) is how you're supposed to mount if there's a disk missing.
