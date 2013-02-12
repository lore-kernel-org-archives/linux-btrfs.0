Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073Ab3BLWwN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 17:52:13 -0500
Date: Tue, 12 Feb 2013 23:52:07 +0100
From: David Sterba <dsterba@suse.cz>
To: kreijack@inwind.it
Cc: Filipe Brandenburger <filbranden@google.com>, dsterba@suse.cz,
        Ian Kumlien <pomac@demius.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/6] Btrfs-progs: add btrfsck functionality to btrfs
Message-ID: <20130212225207.GD12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
 <1360283822-23452-3-git-send-email-pomac@demius.net>
 <20130212163938.GA12339@twin.jikos.cz>
 <CADU+-uBA3k3wW_tLDR4WvRt1EaitWcUNGXCzs6xhYJ_ExSmXkw@mail.gmail.com>
 <511A837D.7090203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <511A837D.7090203@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 12, 2013 at 07:01:33PM +0100, Goffredo Baroncelli wrote:
> On 02/12/2013 06:37 PM, Filipe Brandenburger wrote:
> > Hi,
> > 
> > On Tue, Feb 12, 2013 at 8:39 AM, David Sterba <dsterba@suse.cz> wrote:
> >> +# For backward compatibility, 'btrfs' changes behaviour to fsck if it's named 'btrfsck'
> >> +btrfsck: btrfs
> >> +       @echo "    [CP]     $@"
> >> +       $(Q)cp btrfs btrfsck
> >> +
> > 
> > I think the idea was that btrfsck becomes a link (either symbolic or
> > hardlink works) to btrfs...
> > 
> > Maybe just replace cp with ln?
> 
> I agree with Filipe, or even a script is reasonable. So we have only one
> binary to update, and we avoid the risk to have a version mismatch
> between btrfsck and btrfs. This could lead to a different behaviour
> when the user call btrfsck instead btrfs. Finally this could save some
> bytes of space.

Ok, I'll replace it with a hardlink. A symlink is not reliable (cannot
be copied without breaking the path).

> Anyway my opinion would be to left this kind to decision to the
> distribution. We (as upstream) should only remove the old btrfsck and
> issue an WARNING/REMARK in the release note to notify this change.
> Unfortunately btrfsck is old; now we must provide an alternative file to
> overwrite this binary in order to avoid the mismatch above when the user
> is used to recompile the binary from the source.

A warning is a good idea and it will start a deprecation period of
btrfsck as separate utility. Unil some point in future, I'd rather stay
conservative and let it exist.

david
