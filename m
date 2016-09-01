Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45016 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750825AbcIAMQr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Sep 2016 08:16:47 -0400
Date: Thu, 1 Sep 2016 14:15:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: remove pointless debugfs interface
Message-ID: <20160901121523.GM16983@suse.cz>
Reply-To: dsterba@suse.cz
References: <d6715b5b-0aa3-3032-43c6-eccd907a60b8@redhat.com>
 <20160831190858.GJ16983@twin.jikos.cz>
 <d3e6540b-903d-4d35-e7b0-07a41f1feec5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d3e6540b-903d-4d35-e7b0-07a41f1feec5@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 31, 2016 at 04:38:16PM -0500, Eric Sandeen wrote:
> On 8/31/16 2:08 PM, David Sterba wrote:
> > On Wed, Aug 31, 2016 at 10:13:49AM -0500, Eric Sandeen wrote:
> >> A /sys/kernel/debug/btrfs/test file was added nearly
> >> two and a half years ago, but it serves no purpose;
> > 
> > It does. Introduced in 1bae30982bc86ab66d61ccb6e22792593b45d44d says
> > something about helping developers to easily export information from the
> > filesystem, to aid debugging. Writing the debugfs support code is not
> > obviously trivial, so it's idling in the source. Exporing a new value is
> > as easy as copy and update 3 lines of code. If you have no use for it,
> > fine.
> 
> I had thought that Documentation/filesystems/debugfs.txt would suffice,
> but if you keep stuff lying around in btrfs just in case somebody needs
> to export a global variable in the future, I suppose that's cool too.  ;)

How much time would you spend coding it?  I guess more than a couple of
minutes, possibly more than once.  And not in the middle of debugging
something else.  There are more examples of code that has no apparent
user but is used for debugging.
