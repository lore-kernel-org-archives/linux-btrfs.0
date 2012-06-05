Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:50190 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753315Ab2FEXnP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jun 2012 19:43:15 -0400
Message-ID: <1338939792.11962.4.camel@joe2Laptop>
Subject: Re: [PATCH 0/8] Rework KERN_<LEVEL>
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        alsa-devel@alsa-project.org
Date: Tue, 05 Jun 2012 16:43:12 -0700
In-Reply-To: <CAPXgP13J+8-dPpZkSfh9sM3xXujC2Rb9tJaOvGoEPghgdr8jiw@mail.gmail.com>
References: <cover.1338889066.git.joe@perches.com>
	 <20120605142826.d92316a0.akpm@linux-foundation.org>
	 <1338934303.5780.8.camel@joe2Laptop>
	 <20120605151754.a794ac7c.akpm@linux-foundation.org>
	 <1338936572.5780.29.camel@joe2Laptop>
	 <20120605162910.caccb0d4.akpm@linux-foundation.org>
	 <1338939316.11962.3.camel@joe2Laptop>
	 <CAPXgP13J+8-dPpZkSfh9sM3xXujC2Rb9tJaOvGoEPghgdr8jiw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2012-06-06 at 01:39 +0200, Kay Sievers wrote:
> On Wed, Jun 6, 2012 at 1:35 AM, Joe Perches <joe@perches.com> wrote:
> > On Tue, 2012-06-05 at 16:29 -0700, Andrew Morton wrote:
> >> What about writes starting with \001n?  AFACIT, that will be stripped
> >> away and the printk level will be altered.  This is new behavior.
> >
> > Nope.
> >
> > # echo "\001Hello Andrew" > /dev/kmsg
> > /dev/kmsg has
> > 12,774,2462339252;\001Hello Andrew
> 
> Try "echo -e"? The stuff is copied verbatim otherwise.

# echo -e "\001Hello Kay" > /dev/kmsg
gives
12,776,3046752764;\x01Hello Kay


