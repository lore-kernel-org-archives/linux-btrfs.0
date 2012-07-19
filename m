Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60387 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2GSMnx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jul 2012 08:43:53 -0400
Received: by ghrr11 with SMTP id r11so2692050ghr.19
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2012 05:43:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALa9hx0C8-PpDRFr9fZMtDW95=56XGYHQMnPt5nXOS=2r=tQUA@mail.gmail.com>
References: <CALa9hx1ojpNEYOr8-pLbcm3Y80+GNaeJBtnEugh-BZF4OkpAHw@mail.gmail.com>
	<50076A4C.8080400@stinkt.kicks-ass.org>
	<201207191304.03829.Martin@lichtvoll.de>
	<CALa9hx0C8-PpDRFr9fZMtDW95=56XGYHQMnPt5nXOS=2r=tQUA@mail.gmail.com>
Date: Thu, 19 Jul 2012 19:43:51 +0700
Message-ID: <CAG1y0sfZ7MukzW+Ysh0MrDfRAq0_Ub0nY2igdrM2kdf-EEF8Vg@mail.gmail.com>
Subject: Re: Very slow samba file transfer speed... any ideas ?
From: "Fajar A. Nugraha" <list@fajar.net>
To: Shavi N <shavi64@gmail.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-btrfs@vger.kernel.org,
        Bernhard Redl <bernhard@stinkt.kicks-ass.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2012 at 7:39 PM, Shavi N <shavi64@gmail.com> wrote:
> So btrfs gives a massive difference locally, but that still doesn't
> explain the slow transfer speeds.
> Is there a way to test this?

I'd try with real data, not /dev/zero. e.g:
dd_rescue -b 1M -m 1.4G /dev/sda testfile.img

... or use whatever non-zero data source you have. dd_rescue will give
a nice progress bar and speed indicator.

Also, run "iostat -mx 3" while you're running dd, and while accessing
it from samba. In my experice, btrfs is simply slower than ext4.
Period. There's no way around it for now.

-- 
Fajar
