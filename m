Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f47.google.com ([209.85.212.47]:48050 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab3AVPgR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 10:36:17 -0500
Received: by mail-vb0-f47.google.com with SMTP id e21so371037vbm.6
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2013 07:36:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1358867297.5681.23.camel@cwalton-XPS-8300>
References: <CAFCsa79Cn65gUFKT9RmCYG1WjP257n+iy0zGh_-vaX4Pc_grVA@mail.gmail.com>
	<1358867297.5681.23.camel@cwalton-XPS-8300>
Date: Tue, 22 Jan 2013 19:29:47 +0400
Message-ID: <CAFCsa79DrFA18FAApJHXazAwmb2YRWwfKsGQzn_3C36-diGhcQ@mail.gmail.com>
Subject: Re: Simple btrfs use case
From: Pavel Vasilyev <ml@yekm.name>
To: Calvin Walton <calvin.walton@kepstin.ca>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> In "single" data mode, btrfs makes no special attempt to keep files
> together on the same disk, but if a file is written linearly and never
> modified there's a chance it might happen. (Each modification will COW
> the file, putting the modified portion on a random disk.)
>
> As a result, yes, you may lose a substantial number - even most - of
> your files if one disk dies while in single data mode.

So, on highly fragmented fs reliability in single data mode is near to raid0?
Rhetorical question, actually.

> The failure mode you are describing would be interesting, and people
> talk about it now and then, but there is no current support in btrfs for
> it.

Is there any plans to support it?

> (One thing to note: small files are often stored in the metadata area
> instead of data area, which would be raid1 in your setup. As a result,
> those small files are more likely to be recoverable).
