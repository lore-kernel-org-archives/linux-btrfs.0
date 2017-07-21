Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48551 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751643AbdGUMh5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 08:37:57 -0400
Date: Fri, 21 Jul 2017 14:36:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Adam Buchbinder <abuchbinder@google.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Use '-t btrfs' mount option in tests.
Message-ID: <20170721123640.GG2866@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170712200522.18830-1-abuchbinder@google.com>
 <20170712215259.GL2866@twin.jikos.cz>
 <70c530f5-24fa-c2ff-6aa1-a3f9e7963e47@gmx.com>
 <20170720154246.GF2866@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170720154246.GF2866@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 20, 2017 at 05:42:46PM +0200, David Sterba wrote:
> On Thu, Jul 20, 2017 at 05:40:00PM +0800, Qu Wenruo wrote:
> > 
> > 
> > On 2017年07月13日 05:52, David Sterba wrote:
> > > On Wed, Jul 12, 2017 at 01:05:22PM -0700, Adam Buchbinder wrote:
> > >> Without it, mount (at least from util-linux 2.20.1) tries (and
> > >> fails) to mount some filesystems as NTFS.
> > >>
> > >> Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
> > > 
> > > Applied, thanks.
> > 
> > This patch will break convert self test.
> > 
> > Convert test will try to mount ext* filesystem and re-check its content.
> 
> Right. I'd like to keep -t btrfs everywhere it applies, so I'll add
> another helper that will be used in the convert tests and seems the
> convert test helpers will need to be enhanced with extra parameter of
> the converted fs. Which is sounds like a good idea anyway.

With

https://github.com/kdave/btrfs-progs/commit/18b519e694a6ef559d85072f86898ab5a61f6a05

https://github.com/kdave/btrfs-progs/commit/46809a7287eb41ff2fdb83f742bd5250b820145a

the testsuite now passes.
