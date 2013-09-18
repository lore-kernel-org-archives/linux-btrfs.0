Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab3IRWCn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 18:02:43 -0400
Date: Wed, 18 Sep 2013 15:02:42 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Chris Mason <chris.mason@fusionio.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Zach Brown <zab@redhat.com>
Subject: Re: Build failures due to commit 416161db (btrfs: offline dedupe)
Message-ID: <20130918220241.GQ31381@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20130913133314.GA20461@roeck-us.net> <CAMuHMdWoNo9U0DCRoXt8V2d1SiSxX5Sku9rNvg+9MiX++XjVRg@mail.gmail.com> <20130913163535.GA5681@roeck-us.net> <20130913170022.18785.82013@localhost.localdomain> <20130913175801.GL31381@wotan.suse.de> <20130913193334.18785.8623@localhost.localdomain> <20130917224354.GP31381@wotan.suse.de> <20130918184007.GA12206@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130918184007.GA12206@roeck-us.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 18, 2013 at 11:40:07AM -0700, Guenter Roeck wrote:
> On Tue, Sep 17, 2013 at 03:43:54PM -0700, Mark Fasheh wrote:
> > On Fri, Sep 13, 2013 at 03:33:34PM -0400, Chris Mason wrote:
> > > Mark, could you please send a patch for the whole-struct option until
> > > the unaligned put is upstreamed?
> > > 
> > > -chris
> > 
> > Here you go. It's been lightly tested and needs review.
> > 
> At the very least it does fix the build error on the affected platforms.

Thanks for verifying that Guenter.
	--Mark

--
Mark Fasheh
