Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:59881 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab2ITLO6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 07:14:58 -0400
Date: Thu, 20 Sep 2012 13:14:38 +0200
From: David Sterba <dave@jikos.cz>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: miaox@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs-progs: add mount-option command
Message-ID: <20120920111437.GH17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5057CDA7.3090201@jp.fujitsu.com>
 <5057CEA9.3070707@jp.fujitsu.com>
 <5057DD0D.1070201@cn.fujitsu.com>
 <50598310.9010904@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50598310.9010904@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 19, 2012 at 05:32:16PM +0900, Hidetoshi Seto wrote:
> (2012/09/18 11:31), Miao Xie wrote:
> > On tue, 18 Sep 2012 10:30:17 +0900, Hidetoshi Seto wrote:
> >> This patch adds mount-option command.
> >> The command can set/get default mount options.
> >> Now, the command can set/get 24 options.
> >> These options are equal to mount options which store
> >> in fs_info/mount-opt.
> > 
> > I don't think we need implement a separate command to do this,
> > we can add it into btrfstune just like ext3/4. If so, the users
> > who used ext3/4 before can be familiar with btrfs command as soon
> > as possible.
> 
> As some people already pointed out, I also think that the btrfstune
> command is a kind of obsolete, and therefore it would be better to
> improve the btrfs command as centralized utility.
> 
> > 
> > Beside that, why not add a option into mkfs.btrfs?
> 
> It is planned. Once we can fix a way how to save default options,
> modifying mkfs.btfs would be easy.

It's desirable to extend mkfs with explict feature options like other
filesystems do (eg. mke2fs -O features...) or be able to set
incompatibility flags directly or the mount defaults prior to mount and
actual fs use.

david
