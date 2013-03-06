Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab3CFQr6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Mar 2013 11:47:58 -0500
Date: Wed, 6 Mar 2013 17:47:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, alex.btrfs@zadarastorage.com
Subject: Re: [PATCH v2] btrfs: clean snapshots one by one
Message-ID: <20130306164756.GC21081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAOcd+r152Ot9RYjGfCc_sW46BNKuKrhEN=xR_hw_9QKSu5Agpw@mail.gmail.com>
 <1362154654-17655-1-git-send-email-dsterba@suse.cz>
 <20130301163057.GW27541@twin.jikos.cz>
 <20130306090857.GA1953@zambezi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130306090857.GA1953@zambezi.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 06, 2013 at 11:08:57AM +0200, Ilya Dryomov wrote:
> On Fri, Mar 01, 2013 at 05:30:57PM +0100, David Sterba wrote:
> > 3407         BUG_ON(fs_info->balance_ctl || atomic_read(&fs_info->balance_running));
> 
> Were you by any chance running this on top of a for-linus that included
> a raid56 merge commit?  If so, this is result of a raid56 mismerge --
> fs_info->balance_ctl is supposed to be cleared in __cancel_balance(), a
> call to which was accidentally nuked.

I've been testing either plain next/master or based on linus' tree, so
yes, this merge was there and the missing cancel explains the BUG_ON.

david
