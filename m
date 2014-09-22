Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbaIVNNK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 09:13:10 -0400
Date: Mon, 22 Sep 2014 15:13:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Dimitri John Ledkov <xnox@debian.org>
Cc: Tobias Geerinckx-Rice <tobias.geerinckx.rice@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] Default to acting like fsck.
Message-ID: <20140922131308.GN9715@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1411261282-26831-1-git-send-email-xnox@debian.org>
 <1411261282-26831-4-git-send-email-xnox@debian.org>
 <CAKFHe2RwgjBDCEd6D4jva8QFou=gj8Pzd2auFUNyHFNephrYTw@mail.gmail.com>
 <CANBHLUghtYatMgdGHDunp4osE16Ve2urTcmK9u963scOgiFwHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANBHLUghtYatMgdGHDunp4osE16Ve2urTcmK9u963scOgiFwHg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 22, 2014 at 09:58:34AM +0100, Dimitri John Ledkov wrote:
> On 21 September 2014 13:59, Tobias Geerinckx-Rice
> <tobias.geerinckx.rice@gmail.com> wrote:
> > On 21 September 2014 03:01, Dimitri John Ledkov <xnox@debian.org> wrote:
> >>
> >> Inspect arguments, if we are not called as btrfs, then assume we are
> >> called to act like fsck.
> > [...]
> >> -       if (!strcmp(bname, "btrfsck")) {
> >> +       if (strcmp(bname, "btrfs") != 0) {
> >
> > That's assuming a lot.
> >
> > Silently (!) breaking people's btrfs-3.15_patched-DontRandomlyPanicV2
> > is a recipe for needless hair-pulling. Is there a reason for not using
> > something less like strstr(bname, "fsck") that I am missing?
> >
> 
> Quite. This is verbatim patch as I have currently applied in Debian
> packaging, and it was a fast fix to prevent breakage we had at one
> point.
> 
> Indeed using "strstr(bname, "fsck")" would be better and sufficient to
> resolve the problem we encountered (specifically fsck.btrfs -> btrfs
> not acting like btrfs). Also using strstr, would fix btrfsck.my-build
> to act like fsck tool.

The intention was to provide backward compatibility shortcut for
'btrfsck' -> 'btrfs check' and nothing else. The referenced bug is again
for 0.19 but there's an upstream-shipped stub fsck.btrfs (since 3.14)
that should avoid any packaging tricks.
