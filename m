From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC, crash][PATCH] btrfs: allow cross-subvolume file clone
Date: Thu, 04 Aug 2011 10:42:09 +0800
Message-ID: <4E3A0701.6080900@cn.fujitsu.com>
References: <1312394862-28143-1-git-send-email-dsterba@suse.cz> <20110803182226.GD28122@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com, josef@redhat.com, miaox@cn.fujitsu.com,
	list.btrfs@jan-o-sch.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110803182226.GD28122@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba wrote:
> On Wed, Aug 03, 2011 at 08:07:42PM +0200, David Sterba wrote:
>> I'm working on a patch to fix cross-volume cloning, worked for simple cases
>> like cloning a single file. When I cloned a full linux-2.6 tree there was a
>> immediate BUG_ON (after third cloned file) in btrfs_delayed_update_inode
>> with -ENOSPC :
> 
> oh, a similar issue was already reported on 5 Jul 2011:
> 
> "[BUG] delayed inodes and reflinks"
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/11763 
> 

We've got four reports on this bug.

The cause is we didn't reserve enough space when starting a transaction.

We need space for:

1. btrfs_insert_empty_item()
2. btrfs_update_inode()
3. btrfs_drop_extents()

The first 2 are easy, but drop_extents is not, we have to calc the space
needed for drop_extents in worst case.

--
Li Zefan
