From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [PATCH] Btrfs: don't panic if orphan item already exists
Date: Tue, 13 Dec 2011 14:03:14 -0500
Message-ID: <4EE7A172.2010105@cfl.rr.com>
References: <1323798951-4329-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1323798951-4329-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/13/2011 12:55 PM, Josef Bacik wrote:
> I've been hitting this BUG_ON() in btrfs_orphan_add when running xfstest 269 in
> a loop.  This is because we will add an orphan item, do the truncate, the
> truncate will fail for whatever reason (*cough*ENOSPC*cough*) and then we're
> left with an orphan item still in the fs.  Then we come back later to do another
> truncate and it blows up because we already have an orphan item.  This is ok so
> just fix the BUG_ON() to only BUG() if ret is not EEXIST.  Thanks,

Wouldn't it be better to fix the underlying bug, and remove the orphan 
item when the truncate fails?

