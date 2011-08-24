From: Arne Jansen <sensille@gmx.net>
Subject: Re: BTRFS and power loss ~= corruption?
Date: Wed, 24 Aug 2011 15:31:29 +0200
Message-ID: <4E54FD31.1050003@gmx.net>
References: <4E54F884.9090004@cyberwizzard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Berend Dekens <btrfs@cyberwizzard.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E54F884.9090004@cyberwizzard.nl>
List-ID: <linux-btrfs.vger.kernel.org>

On 24.08.2011 15:11, Berend Dekens wrote:
> Hi,
> 
> I have followed the progress made in the btrfs filesystem over time and while I have experimented with it a little in a VM, I have not yet used it in a production machine.
> 
> While the lack of a complete fsck was a major issue (I read the update that the first working version is about to be released) I am still worried about an issue I see popping up.
> 
> How is it possible that a copy-on-write filesystem becomes corrupted if a power failure occurs? I assume this means that even (hard) resetting a computer can result in a corrupt filesystem.
> 
> I thought the idea of COW was that whatever happens, you can always mount in a semi-consistent state?
> 
> As far as I can see, you wind up with this:
> - No outstanding writes when power down
> - File write complete, tree structure is updated. Since everything is hashed and duplicated, unless the update propagates to the highest level, the write will simply disappear upon failure. While this might be rectified with a fsck, there should be no problems mounting the filesystem (read-only if need be)
> - Writes are not completed on all disks/partitions at the same time. The checksums will detect these errors and once again, the write disappears unless it is salvaged by a fsck.
> 
> Am I missing something? How come there seem to be plenty people with a corrupt btrfs after a power failure? And why haven't I experienced similar issues where a filesystem becomes unmountable with say NTFS or Ext3/4?
> 

Problems arise when in your scenario writes from higher levels in the
tree hit the disk earlier than updates on lower levels. In this case
the tree is broken and the fs is unmountable.
Of course btrfs takes care of the order it writes, but problems arise
when the disk is lying about whether a write is stable on disk, i.e.
about cache flushes or barriers.

