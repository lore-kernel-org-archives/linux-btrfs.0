From: Sander <sander@humilis.net>
Subject: Re: [PATCH 0/3] Btrfs: save free space cache to the disk
Date: Mon, 20 Sep 2010 13:24:46 +0200
Message-ID: <20100920112446.GA10866@attic.humilis.net>
References: <1284577734-3161-1-git-send-email-josef@redhat.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1284577734-3161-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote (ao):
> This patch series introduces the ability for btrfs to store the free space cache
> ondisk to make the caching of a block group much quicker.  Previously we had to
> search the entire extent-tree to look for gaps everytime we wanted to allocate
> in a block group.  This approach instead dumps all of the free space cache to
> disk for every dirtied block group each time we commit the transaction.  This is
> a disk format change, but in order to use the feature you will have to mount
> with -o space_cache, and then from then on you won't be able to use old kernels
> with your filesystem.

Will this go into a future version of btrfs?

If so, would it make sense to include other changes that would require a
format change?

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
