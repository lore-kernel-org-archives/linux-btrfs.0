Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:51725 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab3IMTdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 15:33:37 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 51F949A06B4
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Sep 2013 13:33:37 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130913175801.GL31381@wotan.suse.de>
CC: Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Zach Brown <zab@redhat.com>
References: <20130913133314.GA20461@roeck-us.net>
 <CAMuHMdWoNo9U0DCRoXt8V2d1SiSxX5Sku9rNvg+9MiX++XjVRg@mail.gmail.com>
 <20130913163535.GA5681@roeck-us.net>
 <20130913170022.18785.82013@localhost.localdomain>
 <20130913175801.GL31381@wotan.suse.de>
Message-ID: <20130913193334.18785.8623@localhost.localdomain>
Subject: Re: Build failures due to commit 416161db (btrfs: offline dedupe)
Date: Fri, 13 Sep 2013 15:33:34 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Mark Fasheh (2013-09-13 13:58:01)
> On Fri, Sep 13, 2013 at 01:00:22PM -0400, Chris Mason wrote:
> > Quoting Guenter Roeck (2013-09-13 12:35:35)
> > I'm happy to fix this with a bigger put of the info struct, just
> > let me know the preferred arch-happy solution.
> 
> In fact old versions of the patch were putting the whole struct but during
> review I was asked to change it. This should be very straight forward to fix
> so long as we all stay calm ;)
>         --Mark

Mark, could you please send a patch for the whole-struct option until
the unaligned put is upstreamed?

-chris

