Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44254 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757669AbcK2PeN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 10:34:13 -0500
Date: Tue, 29 Nov 2016 16:34:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: David Sterba <dsterba@suse.cz>, Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] btrfs-progs-v4.8.4: test of 'btrfs receive' in xfstests
 fails
Message-ID: <20161129153408.GH12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <79c9366a-913f-375f-8fa6-729947b74901@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <79c9366a-913f-375f-8fa6-729947b74901@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 28, 2016 at 04:27:06PM +0900, Tsutomu Itoh wrote:
> Many test of xfstests such as btrfs/007, btrfs/008 and btrfs/016 failed
> with the following patch.
> 
>   fefbab75  btrfs-progs: send-stream: check number of read bytes from stream
> 
> This is because cmds-receive.c:do_receive() make a judgement of the end
> of stream by returning 1 from send-stream.c:read_buf().
> So, when applying this patch, 'btrfs receive' will always output the
> following message at the end of stream.
> 
>   ERROR: short read from stream: expected 17 read 0

Thanks for the report, should be fixed in devel, I'm also adding more
tests.
