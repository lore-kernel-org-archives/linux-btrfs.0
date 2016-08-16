Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbcHPOco (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Aug 2016 10:32:44 -0400
Date: Tue, 16 Aug 2016 16:31:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs-progs: Introduce new send-dump object
Message-ID: <20160816143130.GO30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160801062944.25355-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160801062944.25355-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 01, 2016 at 02:29:42PM +0800, Qu Wenruo wrote:
> Introduce send-dump.[ch] which implements a new btrfs_send_ops to
> exam and output all operations inside a send stream.
> 
> It has a better output format than the old and no longer compilable
> send-test tool, but still tries to be script friendly.
> 
> Provides the basis for later "inspect-internal dump-send" command.

I'd rather put that into the receive subcommand, as it takes the stream
as argument and it's closer to the send/receive commands, but that's
a minor thing.
