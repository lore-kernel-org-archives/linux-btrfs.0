From: Li Dongyang <lidongyang@novell.com>
Subject: Re: [PATCH] Btrfs: Batched discard support for btrfs
Date: Thu, 24 Feb 2011 10:24:59 +0800
Message-ID: <201102241024.59950.lidongyang@novell.com>
References: <201102211652.28014.lidongyang@novell.com> <20110221143315.GA2979@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110221143315.GA2979@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, February 21, 2011 10:33:16 PM Josef Bacik wrote:
> So you have just done 2 searches for the same thing.  Instead of doing
> btrfs_remove_free_space here, put
> 
> bitmap_clear_bits()
> 
> after the search_bitmap, and do a
> 
> unlink_free_space()
> 
> if it's not a bitmap, that way we don't race with the allocator (even
> though this isn't a problem, it just sucks) and we don't do the search
> twice.  Other than that it looks great, thank you,
yes we are searching the same extent for twice, once in btrfs_trim_block_group,
another once we call btrfs_remove_free_space, I'll get it fixed and post a new version,
Thanks a lot.
> 
> Josef
