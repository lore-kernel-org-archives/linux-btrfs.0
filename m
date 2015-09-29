Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933616AbbI2JsX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 05:48:23 -0400
Date: Tue, 29 Sep 2015 17:48:18 +0800
From: Eryu Guan <eguan@redhat.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>, Martin Raiber <martin@urbackup.org>
Subject: Re: [PATCH] fstests: test for btrfs incremental send after replacing
 a file
Message-ID: <20150929094818.GG30949@dhcp-13-216.nay.redhat.com>
References: <1443267613-9453-1-git-send-email-fdmanana@kernel.org>
 <20150929035411.GE30949@dhcp-13-216.nay.redhat.com>
 <CAL3q7H4w_f3N+s4xzN-v13h=nD2Wgm7+YYgswwRZJub-VEGfDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H4w_f3N+s4xzN-v13h=nD2Wgm7+YYgswwRZJub-VEGfDQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 29, 2015 at 09:33:34AM +0100, Filipe Manana wrote:
> On Tue, Sep 29, 2015 at 4:54 AM, Eryu Guan <eguan@redhat.com> wrote:
> > On Sat, Sep 26, 2015 at 12:40:13PM +0100, fdmanana@kernel.org wrote:
> >> From: Filipe Manana <fdmanana@suse.com>
> >>
> >> Test that an incremental send works after a file from the parent snapshot
> >> gets replaced in the send snapshot by another one at the same exact
> >> location, with the same name and with the same inode number.
> >>
> >> This test used to fail after the linux kernel commit 8b191a684968
> >> ("Btrfs: incremental send, check if orphanized dir inode needs delayed
> >> rename") and it's fixed by patch titled:
> >>
> >>   "Btrfs: send, fix corner case for reference overwrite detection"
> >
> > I got "btrfs receive" error when testing this, with 4.3-rc1 kernel and
> > btrfs-progs v4.2, not sure if this is expected
> 
> Yes, it's expected.
> The fix isn't yet in any kernel release (nor rc).

Thanks for the clarification, I was somehow expecting a file md5 mismatch.

Then the patch looks good to me.

Reviewed-by: Eryu Guan <eguan@redhat.com>
