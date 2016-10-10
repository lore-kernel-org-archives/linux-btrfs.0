Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:37966 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752803AbcJJRRM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 13:17:12 -0400
Date: Mon, 10 Oct 2016 13:17:04 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs_direct_IO oops
Message-ID: <20161010171704.skyaq2sy6de7ghn6@codemonkey.org.uk>
References: <20161008180806.fmpwtw4vcc7lzd36@codemonkey.org.uk>
 <20161008182903.GU19539@ZenIV.linux.org.uk>
 <20161008232008.nouzkd54kiquvpir@codemonkey.org.uk>
 <20161009151106.damzuhyjpdzq4x2w@codemonkey.org.uk>
 <20161010034356.GY19539@ZenIV.linux.org.uk>
 <20161010131122.cjmoof6yblwl7tak@codemonkey.org.uk>
 <20161010155503.GZ19539@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161010155503.GZ19539@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 10, 2016 at 04:55:03PM +0100, Al Viro wrote:
 
 > > WARNING: CPU: 1 PID: 13581 at lib/iov_iter.c:327 sanity+0x102/0x150
 > > CPU: 1 PID: 13581 Comm: trinity-c17 Not tainted 4.8.0-think+ #9 
 > >  ffffc90000963ae8
 > >  ffffffffb93e22d1
 > >  0000000000000000
 > >  0000000000000000
 > > 
 > >  ffffffffb9c1e1cb
 > >  ffffffffb93fa5b2
 > >  ffffc90000963b28
 > >  ffffffffb908b010
 > > 
 > >  00000147d43c0e7f
 > >  ffffffffb9c1e1cb
 > >  0000000000000147
 > >  0000000000000010
 > 
 > What are these from?  Confused...

That's the stack I think. I don't know why it started printing all weird..

 > [via splice_direct_to_actor()]
 > 
 > Hmmm...  I think I see it.  Could you try the following (on top of debugging
 > in lib/iov_iter.c) and see if anything triggers?
 
Been running for an hour without incident so far, so this looks promising.
I'll follow-up if anything jumps out, but normally I'd have seen this by now.

	Dave
