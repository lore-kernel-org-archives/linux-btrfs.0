Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34805 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbbLFUm6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Dec 2015 15:42:58 -0500
Received: by ioir85 with SMTP id r85so163131457ioi.1
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Dec 2015 12:42:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+pSGYcxAHUppSgODwk16i+5rLdojzjYxp8=SWWkLXmXOAo9kg@mail.gmail.com>
References: <CA+pSGYcxAHUppSgODwk16i+5rLdojzjYxp8=SWWkLXmXOAo9kg@mail.gmail.com>
Date: Sun, 6 Dec 2015 13:42:57 -0700
Message-ID: <CAJCQCtQX5Ov6YKZ=SdxaGSPaGa0sEFF6gz89WsDm9qegmykGkA@mail.gmail.com>
Subject: Re: Scrub on btrfs single device only to detect errors, not correct them?
From: Chris Murphy <lists@colorremedies.com>
To: Jon Panozzo <jonp@lime-technology.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 6, 2015 at 12:15 PM, Jon Panozzo <jonp@lime-technology.com> wrote:
> Just to confirm, is the sole purpose of supporting scrub on single btrfs
> devices to detect errors, but not to correct them?

If that single device metadata profile is DUP, then it will correct
those. If there is only one copy of anything, then it just reports.
Scrub works on all data, but a passive scrub happens anytime something
is read.


-- 
Chris Murphy
