Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37600 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726679AbeHURpG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 13:45:06 -0400
Date: Tue, 21 Aug 2018 16:24:32 +0200
From: David Sterba <dsterba@suse.cz>
To: David Howells <dhowells@redhat.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz, clm@fb.com,
        linux-btrfs@vger.kernel.org, wqu@suse.de
Subject: Re: Are the btrfs mount options inconsistent?
Message-ID: <20180821142432.GD24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4b5b0a92-8a51-e516-b14a-74557b002d71@gmx.com>
 <20180816130515.GR24025@twin.jikos.cz>
 <31114.1534417285@warthog.procyon.org.uk>
 <32208.1534767847@warthog.procyon.org.uk>
 <341.1534859015@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <341.1534859015@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 21, 2018 at 02:43:35PM +0100, David Howells wrote:
> Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> 
> > But to be more clear, NOSSD shouldn't be a special case.
> > In fact currently NOSSD only affects whether we will output the message
> > "enabling ssd optimization", no real effect if I didn't miss anything.

There is a real effect.

> That's not quite true.  In:
> 
> 	if (!btrfs_test_opt(fs_info, NOSSD) &&
> 	    !fs_info->fs_devices->rotating) {
> 		btrfs_set_and_info(fs_info, SSD, "enabling ssd optimizations");
> 	}
> 
> the call to btrfs_set_and_info() will turn on SSD.
> 
> What this seems to me is that, normally, SSD will be turned on automatically
> unless at least one of the devices is a rotating medium - but this appears to
> be explicitly suppressed by the NOSSD option.

Right. So expected behaviour:

- nothing: auto-detect non-rotating devices, enable SSD mount option in turn
- nossd: disable auto-detection of non-rotating devices
- ssd: enable SSD optimizations uconditionally
- ssd_spread: implies SSD and affects some allocator decisions regarding
              new extent alignments
