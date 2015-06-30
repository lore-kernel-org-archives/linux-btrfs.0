Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbbF3POy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 11:14:54 -0400
Date: Tue, 30 Jun 2015 17:14:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@kernel.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] Btrfs-progs: add feature to get mininum size for
 resizing a fs/device
Message-ID: <20150630151450.GH726@suse.cz>
Reply-To: dsterba@suse.cz
References: <1434541495-14934-1-git-send-email-fdmanana@kernel.org>
 <20150629154221.GD726@twin.jikos.cz>
 <CAL3q7H4zr=v_A7aDSPGvS-cpOWosmwuNx0F+5nVN2R=yisa_9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H4zr=v_A7aDSPGvS-cpOWosmwuNx0F+5nVN2R=yisa_9w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 29, 2015 at 05:15:12PM +0100, Filipe Manana wrote:
> On Mon, Jun 29, 2015 at 4:42 PM, David Sterba <dsterba@suse.cz> wrote:
> > On Wed, Jun 17, 2015 at 12:44:55PM +0100, fdmanana@kernel.org wrote:
> > The test fails after I do this before unmount:
> >
> > $SUDO_HELPER $TOP/btrfs balance start -mconvert=single -sconvert=single -f $TEST_MNT
> > shrink_test
> 
> Where are you doing this exactly?
> 
> Just tried the following:  https://friendpaste.com/2U7C4gBBLBjo4e2v1ZnJP2

Like in the the first part of the diff.

> > Output:
> >
> > ############### root_helper ../btrfs filesystem resize get_min_size ../tests/mnt
> > 6480199680 bytes (6.04GiB)
> > min size = 6480199680
> > ############### root_helper ../btrfs filesystem resize 6480199680 ../tests/mnt
> > ERROR: unable to resize '../tests/mnt' - No space left on device
> > Resize '../tests/mnt' of '6480199680'
> >
> > Last successful resize before this was:
> > Resize '../tests/mnt' of '7553941504'
> 
> And it didn't fail for me on a 4.1 kernel at least. It produced those
> 2 sizes as well, but it didn't fail for any of them.

The test was run on 4.0.5, I'm building a clean 4.1 + integration to
verify it there.
