Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:34005 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753524AbdHUSaj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 14:30:39 -0400
Received: by mail-pg0-f49.google.com with SMTP id n4so40719921pgn.1
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 11:30:39 -0700 (PDT)
Date: Mon, 21 Aug 2017 11:30:37 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS warning (device dm-0): unhandled fiemap cache detected
Message-ID: <20170821183037.GA16030@vader.DHCP.thefacebook.com>
References: <1503282544.4669.10.camel@scientia.net>
 <d0d41a1e-7191-4c46-78a1-615dbcfe71c0@gmx.com>
 <1503286064.4669.12.camel@scientia.net>
 <ff53b205-4bdd-a360-91d7-068b65b23dad@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <ff53b205-4bdd-a360-91d7-068b65b23dad@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 11:31:34AM +0800, Qu Wenruo wrote:
> 
> 
> On 2017年08月21日 11:27, Christoph Anton Mitterer wrote:
> > On Mon, 2017-08-21 at 10:43 +0800, Qu Wenruo wrote:
> > > Harmless, it is only designed to merge fiemap output.
> > Thanks for the info :)
> > 
> > 
> > On Mon, 2017-08-21 at 10:57 +0800, Qu Wenruo wrote:
> > > Quite strange, according to upstream git log, that commit is merged
> > > between v4.12-rc7 and v4.12.
> > > Maybe I misunderstand the stable kernel release cycle.
> > 
> > Seems it was only added in 4.12.7? Maybe a typo?
> 
> I'm talking about upstream, which is managed by Linus.
> The 4.12.x is managed by maintainers of stable releases.
> 
> In Linus repo, the commit is between v4.12 and v4.12-rc7 tag.
> Maybe v4.12.x is started before v4.12 release.

It's not in 4.12.

$ git tag --contains 848c23b78fafdcd3270b06a30737f8dbd70c347f
for-4.13-part2-tag
v4.13-rc1
v4.13-rc2
v4.13-rc3
v4.13-rc4
v4.13-rc5
