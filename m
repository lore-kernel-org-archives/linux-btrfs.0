Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756748Ab3H2TAt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 15:00:49 -0400
Date: Thu, 29 Aug 2013 12:00:45 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Filipe David Borba Manana <fdmanana@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs: optimize key searches in btrfs_search_slot
Message-ID: <20130829190045.GP26818@lenny.home.zabbo.net>
References: <1377780253-17826-1-git-send-email-fdmanana@gmail.com>
 <1377784766-7552-1-git-send-email-fdmanana@gmail.com>
 <20130829180816.GO26818@lenny.home.zabbo.net>
 <20130829183532.GC10591@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130829183532.GC10591@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > We can replace all that stuff with two easy memcmp_extent_buffers()
> > which vanish if ASSERT is a nop. 
> 
> Actually we can't since we have a cpu key and the keys in the eb are disk keys.
> So maybe keep what we have here and wrap it completely in CONFIG_BTRFS_ASSERT?

I could have sworn that I checked that the input was a disk key.

In that case, then, I'd put all this off in a helper function that's
called in the asserts that swabs to a disk key and then does the memcmp.
All this fiddly assert junk (which just compares keys!) doesn't belong
implemented by hand in this trivial helper.

- z
