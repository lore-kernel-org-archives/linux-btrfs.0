From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [patch 0/2]btrfs: add two ioctls to do metadata readahead
Date: Wed, 14 Jul 2010 16:26:45 +0800
Message-ID: <20100714082645.GA32458@sli10-desk.sh.intel.com>
References: <1279094536.1528.93.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	"Wu, Fengguang" <fengguang.wu@intel.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1279094536.1528.93.camel@sli10-desk.sh.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 14, 2010 at 04:02:16PM +0800, Shaohua Li wrote:
> Hi,
>   We have file readahead to do asyn file read, but has no metadata
> readahead. For a list of files, their metadata is stored in fragmented
> disk space and metadata read is a sync operation, which impacts the
> efficiency of readahead much. The patches try to add meatadata readahead
> for btrfs.
>   In btrfs, metadata is stored in btree_inode. Ideally, if we could hook
> the inode to a fd so we could use existing syscalls (readahead, mincore
> or upcoming fincore) to do readahead, but the inode is hidden, there is
> no easy way for this from my understanding. So we add two ioctls for
> this. One is like readahead syscall, the other is like micore/fincore
> syscall.
>   Under a harddisk based netbook with Meego, the metadata readahead
> reduced about 3.5s boot time from total 16s.
> 
> Issues:
> 1. it appears readahead metadata pages skipped checksum checking. I'm
> still working on this.
> 2. in latest kernel, I got a lockdep warning. It looks not related to
> the patches but I only observed it with the patches. The warning looks
> like a false warning, as in my debug the spin_lock isn't hold. from my
> understanding, all extent_buffer share a lockdep class and in the btree
> lookup we might lock several extent_buffer. But I don't know how to fix
> it yet.
Ha, sorry, actually the two issues are one issue. We set lockdep level class
and doing checksum in one place. I have a debug patch for this and will
send out later. But before this, I'd like know your comments about the idea.

Thanks,
Shaohua 
