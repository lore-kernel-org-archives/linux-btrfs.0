Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbbEFP1g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 May 2015 11:27:36 -0400
Date: Wed, 6 May 2015 17:27:34 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Anand Jain <Anand.Jain@oracle.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-progs 4.0 breaks btrfs fi show?
Message-ID: <20150506152734.GB23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAJCQCtR7ZT6vt06fbw3sh9sQxufsck=v2J+HJKz2DLFxR9q8RQ@mail.gmail.com>
 <5549CCD8.2010000@cn.fujitsu.com>
 <5549D20F.1030607@oracle.com>
 <20150506150727.GA23255@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150506150727.GA23255@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 06, 2015 at 05:07:27PM +0200, David Sterba wrote:
> On Wed, May 06, 2015 at 04:34:23PM +0800, Anand Jain wrote:
> > On 05/06/2015 04:12 PM, Qu Wenruo wrote:
> > > Works for me.
> > > Although with a lot of annoying extra missing device warning:
> > 
> > Yep. Its from 915902c5002485fb13d27c4b699a73fb66cc0f09
> > after various objections I made it still got in.
> 
> I don't see this commit id in my git, what's the patch subject?

Found by other means "btrfs-progs: fix device missing of btrfs fi show
with seed devices", merged into 3.17.
