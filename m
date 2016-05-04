Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757573AbcEDJAc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 May 2016 05:00:32 -0400
Date: Wed, 4 May 2016 11:00:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: cleanup assigning next active device with a
 check
Message-ID: <20160504090014.GO29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1460978752-27375-1-git-send-email-anand.jain@oracle.com>
 <1462143728-3000-1-git-send-email-anand.jain@oracle.com>
 <20160502152618.GK29353@suse.cz>
 <572876FB.4070208@oracle.com>
 <20160503174728.GM29353@twin.jikos.cz>
 <572934EB.8030604@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <572934EB.8030604@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 04, 2016 at 07:31:55AM +0800, Anand Jain wrote:
> 
> >>    While here can also integrate this.
> >>
> >>    [PATCH 1/1] btrfs: fix lock dep warning move scratch super outside of
> >> chunk_mutex
> >
> > That one has been in for-next for some time.
> 
> There is another patch which is similarly named (sorry about that),
> I see that one but not this.
> 
> ---------
> git log -i --author=anand.jain@oracle.com --oneline  | egrep "btrfs: fix 
> lock dep"
> 58681ad85b9f btrfs: fix lock dep warning, move scratch dev out of 
> device_list_mutex and uuid_mutex

I see, the subjects partially differ in the last word, that's easy to
miss and I got te 'chunk_mutex' patch marked as dropped as it looked
like the other patch superseded it.

https://patchwork.kernel.org/patch/8868771/ -- in next

https://patchwork.kernel.org/patch/8810591/ -- pending
