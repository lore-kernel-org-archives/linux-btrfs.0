Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbbEFPH2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 May 2015 11:07:28 -0400
Date: Wed, 6 May 2015 17:07:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-progs 4.0 breaks btrfs fi show?
Message-ID: <20150506150727.GA23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAJCQCtR7ZT6vt06fbw3sh9sQxufsck=v2J+HJKz2DLFxR9q8RQ@mail.gmail.com>
 <5549CCD8.2010000@cn.fujitsu.com>
 <5549D20F.1030607@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5549D20F.1030607@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 06, 2015 at 04:34:23PM +0800, Anand Jain wrote:
> On 05/06/2015 04:12 PM, Qu Wenruo wrote:
> > Works for me.
> > Although with a lot of annoying extra missing device warning:
> 
> Yep. Its from 915902c5002485fb13d27c4b699a73fb66cc0f09
> after various objections I made it still got in.

I don't see this commit id in my git, what's the patch subject?
