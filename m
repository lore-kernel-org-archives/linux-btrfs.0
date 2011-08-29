From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: don't use delalloc block rsv for free space inodes
Date: Mon, 29 Aug 2011 12:17:10 -0400
Message-ID: <4E5BBB86.7050501@redhat.com>
References: <1314631147-13434-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314631147-13434-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/29/2011 11:19 AM, Josef Bacik wrote:
> In tracking down this "not enough space" warning with checksums, it seems that
> we were running out of space partly because we do not reserve space for our free
> space inodes.  Since this is technically metadata anyway go ahead and use the
> global_block_rsv for our free space inodes.  We shouldn't be modifying too much
> other metadata since this will be a preallocated extent and that was already
> accounted for earlier.  Thanks,
> 

Ignore these, they cause other problems, I'll fix it a different way.
Thanks,

Josef
