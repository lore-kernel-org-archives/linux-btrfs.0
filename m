Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:48856 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab2IRMH2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 08:07:28 -0400
Date: Tue, 18 Sep 2012 14:06:58 +0200
From: David Sterba <dave@jikos.cz>
To: Hugo Mills <hugo@carfax.org.uk>, Roman Mamedov <rm@romanrm.ru>,
        miaox@cn.fujitsu.com, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs-progs: add mount-option command
Message-ID: <20120918120657.GY17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5057CDA7.3090201@jp.fujitsu.com>
 <5057CEA9.3070707@jp.fujitsu.com>
 <5057DD0D.1070201@cn.fujitsu.com>
 <20120918101930.6f3edb3c@natsu>
 <20120918081940.GH1129@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120918081940.GH1129@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 18, 2012 at 09:19:40AM +0100, Hugo Mills wrote:
> On Tue, Sep 18, 2012 at 10:19:30AM +0600, Roman Mamedov wrote:
> > On Tue, 18 Sep 2012 10:31:41 +0800
> > Miao Xie <miaox@cn.fujitsu.com> wrote:
> > 
> > > On tue, 18 Sep 2012 10:30:17 +0900, Hidetoshi Seto wrote:
> > > > This patch adds mount-option command.
> > > > The command can set/get default mount options.
> > > > Now, the command can set/get 24 options.
> > > > These options are equal to mount options which store
> > > > in fs_info/mount-opt.
> > > 
> > > I don't think we need implement a separate command to do this,
> > > we can add it into btrfstune just like ext3/4. If so, the users
> > > who used ext3/4 before can be familiar with btrfs command as soon
> > > as possible.
> > 
> > btrfstune currently only does one thing:
> > 
> > $ sudo btrfstune
> > usage: btrfstune [options] device
> > 	-S value	enable/disable seeding
> > 
> > To me it'd seem more logical the other way, why not move this operation to the
> > base "btrfs" utility under some command, and remove "btrfstune" completely.
> 
>    I would suggest picking up and extending Alex Block's "btrfs
> property set/get" idea for this.

And I'm with you here. I'm not sure if btrfstune has widespread use, the
functionality should go into a single management tool that everybody
uses.

david
