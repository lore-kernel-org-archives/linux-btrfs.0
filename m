Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbcCVKAL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 06:00:11 -0400
Date: Tue, 22 Mar 2016 10:59:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix build warning
Message-ID: <20160322095941.GG8095@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1455609767-26992-1-git-send-email-sudipm.mukherjee@gmail.com>
 <CAMuHMdVfCP97jKauZ5j29zAnWPi0ro_hRkq=A0AS=N6jgPHdwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAMuHMdVfCP97jKauZ5j29zAnWPi0ro_hRkq=A0AS=N6jgPHdwA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 22, 2016 at 10:39:59AM +0100, Geert Uytterhoeven wrote:
> On Tue, Feb 16, 2016 at 9:02 AM, Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
> > We were getting build warning about:
> > fs/btrfs/extent-tree.c:7021:34: warning: ‘used_bg’ may be used
> >         uninitialized in this function
> >
> > It is not a valid warning as used_bg is never used uninitilized since
> > locked is initially false so we can never be in the section where
> > 'used_bg' is used. But gcc is not able to understand that and we can
> > initialize it while declaring to silence the warning.
> >
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> 
> FWIW, I've posted an alternative patch that killed the silly locked variable
> a while ago.
> "[PATCH] Btrfs: Refactor btrfs_lock_cluster() to kill compiler warning"
> https://lkml.org/lkml/2014/6/22/96

The cleanup looks great, thanks, patch picked.
