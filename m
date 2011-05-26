From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] Btrfs: load the key from the dir item in readdir into a fake dentry
Date: Thu, 26 May 2011 11:50:18 -0700
Message-ID: <m2fwo19tzp.fsf@firstfloor.org>
References: <1306421316-1504-2-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1306421316-1504-2-git-send-email-josef@redhat.com> (Josef
	Bacik's message of "Thu, 26 May 2011 10:48:36 -0400")
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik <josef@redhat.com> writes:
> +
> +				newkey = kzalloc(sizeof(struct btrfs_key),
> +						 GFP_NOFS);
> +				if (!newkey)
> +					goto no_dentry;
> +				tmp = d_alloc(filp->f_dentry, &q);

This doesn't seem to address the "find / fills all memory with dentries"
concerns brought up earlier at all.

d_alloc uses a normal GFP_KERNEL, which is quite in appropiate for this.

It should at least reclaim and probably more, but even then it's
risky.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
