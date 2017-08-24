Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45944 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753759AbdHXRC5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 13:02:57 -0400
Date: Thu, 24 Aug 2017 19:01:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Eric Sandeen <sandeen@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Hallo32@gmx.net, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] btrfs-progs: fix cross-compile build
Message-ID: <20170824170131.GG2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <8f01ac45-1b6e-be1d-b6e3-48fe6cdc4833@redhat.com>
 <9a81d05e-68ab-45a1-a4dc-386b89f4c733@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <9a81d05e-68ab-45a1-a4dc-386b89f4c733@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 16, 2017 at 08:17:00AM +0800, Qu Wenruo wrote:
> 
> 
> On 2017年08月16日 02:11, Eric Sandeen wrote:
> > The mktables binary needs to be build with the host
> > compiler at built time, not the target compiler, because
> > it runs at build time to generate the raid tables.
> > 
> > Copy auto-fu from xfsprogs and modify Makefile to
> > accomodate this.
> > 
> > Reported-by: Hallo32 <Hallo32@gmx.net>
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Looks better than my previous patch.
> With @BUILD_CLFAGS support and better BUILD_CC/CLFAGS detection for 
> native build environment.

The contents of tables.c has practially not changed since its
introduction in 2000s. I see no sense in regenerating it each time
during build and I don't want to introduce host CC build just for
this one file, standard practice or not.
