Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44847 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754298AbcHXMut (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 08:50:49 -0400
Date: Wed, 24 Aug 2016 14:49:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs-progs: Introduce new send-dump object
Message-ID: <20160824124940.GR16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160801062944.25355-1-quwenruo@cn.fujitsu.com>
 <20160816143130.GO30795@twin.jikos.cz>
 <22e65257-c864-aa4e-9e6b-59610aec347a@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <22e65257-c864-aa4e-9e6b-59610aec347a@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 17, 2016 at 08:42:48AM +0800, Qu Wenruo wrote:
> 
> 
> At 08/16/2016 10:31 PM, David Sterba wrote:
> > On Mon, Aug 01, 2016 at 02:29:42PM +0800, Qu Wenruo wrote:
> >> Introduce send-dump.[ch] which implements a new btrfs_send_ops to
> >> exam and output all operations inside a send stream.
> >>
> >> It has a better output format than the old and no longer compilable
> >> send-test tool, but still tries to be script friendly.
> >>
> >> Provides the basis for later "inspect-internal dump-send" command.
> >
> > I'd rather put that into the receive subcommand, as it takes the stream
> > as argument and it's closer to the send/receive commands, but that's
> > a minor thing.
> >
> >
> I'm OK to put it into receive command.
> 
> Although unlike normal receive usage, it doesn't need the <path> 
> parameter, and make <path> to be optional.

That's a good point and would make the syntax work in two modes, but we
do that in ohter commands and I hope it will not be confusing. Exmaples:

Normal receive:

 btrfs receive -f file /mount

Dump the stream:

 btrs receive --dump -f file
