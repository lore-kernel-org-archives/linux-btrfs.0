Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbbKYMoV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 07:44:21 -0500
Date: Wed, 25 Nov 2015 13:42:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/25] Btrfs-convert rework to support native separate
Message-ID: <20151125124235.GO31035@suse.cz>
Reply-To: dsterba@suse.cz
References: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151123173330.GH31035@twin.jikos.cz>
 <565424B8.3020502@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <565424B8.3020502@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 24, 2015 at 04:50:00PM +0800, Qu Wenruo wrote:
> It seems the conflict is quite huge, your reiserfs support is based on 
> the old behavior, just like what old ext2 one do: custom extent allocation.

> I'm afraid the rebase will take a lot of time since I'm completely a 
> newbie about reiserfs... :(

Yeah, the ext2 callbacks are abstracted and replaced by reiserfs
implementations, and the abstratction is quite direct. This might be a
problem with merging your patchset.

> I may need to change a lot of ext2 direct call to generic one, and may 
> even change the generic function calls.(no alloc/free, only free space 
> lookup)
> 
> And some (maybe a lot) of reiserfs codes may be removed during the rework.

As far as the conversion support stays, it's not a problem of course. I
don't have a complete picture of all the actual merging conflicts, but
the idea is to provide the callback abstraction v2 to allow ext2 and
reiser plus allow all the changes of this pathcset.
