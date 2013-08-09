Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966789Ab3HIABL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 20:01:11 -0400
Date: Fri, 9 Aug 2013 02:01:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC] Btrfs: add support for persistent mount options
Message-ID: <20130809000109.GH5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375813640-14063-1-git-send-email-fdmanana@gmail.com>
 <20130807104041.GN5284@twin.jikos.cz>
 <CAL3q7H7j1Hfx6p-dxP=+C_6uVa7gG22KTQr2_PphMLy3sPeLyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAL3q7H7j1Hfx6p-dxP=+C_6uVa7gG22KTQr2_PphMLy3sPeLyw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 07, 2013 at 12:33:09PM +0100, Filipe David Manana wrote:
> Thanks, I missed to find that before.
> The implementation is very different from the one I proposed.

That's one of the fundaental questions how to store the information:
inside existing structures, via xattrs, under new tree items. Each one
has pros and cons.

> > Designing and merging the properties feature takes time, but we want to tune
> > simple things now. The wiki project mentions ‘tune2fs’ as an example, but the
> > project details are not always accurate about how to do the things, it’s more
> > like ideas what to do. If you’re going to work on that, please claim the
> > project on the wiki, and possibly write more details abou the design.
> 
> I will.

The project is titled as persistent mount options, are you willing to
take the more general "per-object properties" task? IMHO there's not
much difference, the UI should be the same, just that it implements
per-fs or per-subvolume properties like mount options. The rest of the
object properties has to be collected and agreed on. I'm sure there's
community knowledge of what's desired, so it's a matter of writing it
down and bikeshe^Wagreement on the naming syntax.

david
