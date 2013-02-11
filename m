Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758626Ab3BKSOZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 13:14:25 -0500
Date: Mon, 11 Feb 2013 19:14:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add cancellation points to defrag
Message-ID: <20130211181423.GT12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1360453086-10683-1-git-send-email-dsterba@suse.cz>
 <5119238A.9080306@redhat.com>
 <20130211174547.GS12339@twin.jikos.cz>
 <51192EE4.4090403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51192EE4.4090403@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 11, 2013 at 11:48:20AM -0600, Eric Sandeen wrote:
> On 2/11/13 11:45 AM, David Sterba wrote:
> > __btrfs_run_defrag_inode -> btrfs_defrag_file applies only in case of
> > autodefrag. The ioctl 'defrag' goes directly to btrfs_defrag_file and
> > what you describe does not happen here.
> 
> Ok, was thinking that might be the case, but wasn't sure what all that
> worker thread handled.  So I guess there should be no signals in that case.

Just for the record, btrfs_run_defrag_inodes is called from cleaner
thread, so if we had a cleaner way to inform the thread to stop the
defrag it'd be possible to stop autodefrag as well. I tested defrag of a
1G file with ~90k of extents (produced by overwriting random 4k ranges
in the file) and then doing sequential rewrite of the file. Cpu and IO
activity went expectedly high and in case of many files under defrag
it'd be more flexible to actually control the internal defrag as well.
Not by a signal, because in case of more mounted filesystems one cannot
know which process to target.

> > I agree that the negative error code should be handled in
> > __btrfs_run_defrag_inode (there are two of them EINVAL and ENOMEM).
> > Requeing defrag might make sense in theory in the ENOMEM case, but
> > triggering more activity when the system is low on memory is not
> > practical.
> 
> *nod* - but a separate issue, I guess.

Yes.

david
