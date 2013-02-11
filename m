Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758459Ab3BKRsx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 12:48:53 -0500
Message-ID: <51192EE4.4090403@redhat.com>
Date: Mon, 11 Feb 2013 11:48:20 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add cancellation points to defrag
References: <1360453086-10683-1-git-send-email-dsterba@suse.cz> <5119238A.9080306@redhat.com> <20130211174547.GS12339@twin.jikos.cz>
In-Reply-To: <20130211174547.GS12339@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/11/13 11:45 AM, David Sterba wrote:
> On Mon, Feb 11, 2013 at 10:59:54AM -0600, Eric Sandeen wrote:
>> On 2/9/13 5:38 PM, David Sterba wrote:
>>> The defrag operation can take very long, we want to have a way how to
>>> cancel it. The code checks for a pending signal at safe points in the
>>> defrag loops and returns EAGAIN. This means a user can press ^C after
>>> running 'btrfs fi defrag', woks for both defrag modes, files and root.
>>>
>>> Returning from the command was instant in my light tests, but may take
>>> longer depending on the aging factor of the filesystem.
>>
>> When __btrfs_run_defrag_inode() calls btrfs_defrag_file() and gets
>> -EAGAIN back due to the cancellation, will it reset the defrag->
>> counters and call btrfs_requeue_inode_defrag()?  Is that ok?
>>
>> Should __btrfs_run_defrag_inode explicitly check for and handle
>> an actual error returned to it?
> 
> __btrfs_run_defrag_inode -> btrfs_defrag_file applies only in case of
> autodefrag. The ioctl 'defrag' goes directly to btrfs_defrag_file and
> what you describe does not happen here.

Ok, was thinking that might be the case, but wasn't sure what all that
worker thread handled.  So I guess there should be no signals in that case.

> (The autodefrag loop runs within kernel threads and I want to avoid
> enabling signals for them.)

Understood.

> I agree that the negative error code should be handled in
> __btrfs_run_defrag_inode (there are two of them EINVAL and ENOMEM).
> Requeing defrag might make sense in theory in the ENOMEM case, but
> triggering more activity when the system is low on memory is not
> practical.

*nod* - but a separate issue, I guess.

Thanks,
-Eric

> 
> david
> 

