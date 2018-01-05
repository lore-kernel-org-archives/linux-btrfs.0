Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45491 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751109AbeAEMuW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jan 2018 07:50:22 -0500
Date: Fri, 5 Jan 2018 13:48:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Don't generate UUID for non-fs tree
Message-ID: <20180105124814.GG3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171031060816.683-1-wqu@suse.com>
 <20180103143708.GC3553@twin.jikos.cz>
 <88f114b2-5b45-7228-a612-51042a3ca2a8@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <88f114b2-5b45-7228-a612-51042a3ca2a8@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 04, 2018 at 09:38:46AM +0800, Qu Wenruo wrote:
> >> -	uuid_le uuid;
> >> +	uuid_le uuid = { 0 };
> > 
> > I get a warning with gcc 4.8.5
> > 
> > fs/btrfs/disk-io.c:1236:2: warning: missing braces around initializer [-Wmissing-braces]
> > 
> > but no warning with gcc 7.2.1 (built as 'make ccflags-y=-Wmissing-braces
> > and checking that the option is really there). I think we should use
> > NULL_UUID_LE.
> 
> Do I need to resend the whole patch or a new delta patch?

Not needed, I've fixed in the patch,

uuid_le = NULL_UUID_LE;
