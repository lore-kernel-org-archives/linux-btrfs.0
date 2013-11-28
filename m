Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:62461 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3K1TXR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 14:23:17 -0500
Received: by mail-wg0-f51.google.com with SMTP id b13so5583227wgh.6
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Nov 2013 11:23:15 -0800 (PST)
Message-ID: <52979821.60401@gmail.com>
Date: Thu, 28 Nov 2013 20:23:13 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS-PROG: recursively subvolume snapshot and delete
References: <1384621747-25441-1-git-send-email-kreijack@inwind.it> <20131128183122.GL25312@twin.jikos.cz>
In-Reply-To: <20131128183122.GL25312@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,
On 2013-11-28 19:31, David Sterba wrote:
> On Sat, Nov 16, 2013 at 06:09:00PM +0100, Goffredo Baroncelli wrote:
>> the following patches implement the recursively snapshotting and
>> deleting of a subvolume. 
> 
> Nice feature, but can we try to make the snapshot creation atomic? This
> would need support from kernel of course.
> 
> I'm worried about the outcome from the users' perspective, the
> consistency of the whole subvolume subtree. As you've implemented it,
> there are several operations involved like traversing the subvolume
> list, replacing the empty-subvols with the real ones, taking the
> snapshots. The assumptions about existing source subvolumes may change
> in the meantime: renamed or deleted.

Definetely you are right. In fact this is true also for other tools like
tar: they complaint if you remove/move/rename a file during the copy. We
can work to increase the robustness of the process, to avoid strange
behaviour when a subvolume is removed/moved/renamed.

Anyway I am more afraid that we can't mix recursive and readonly snapshot.

Implementing the atomic recursive snapshot in the kernel, is out of my
possibility; anyway basically this means that the filesystem is frozen
until all the snapshot are done, which requires a finite time. In case
of a high number of subvolumes this could be a problem.

May be that it could be more simple to snapshot "all the filesystem", ie
snapshot not from the filesystem-tree but form the root-of-tree; then we
could cherry-pick the subvolume which are involved....

Another possibility is to forzen all subvolumes, then snapshot them,
then unfrozen all the subvolume...

> 
> The recursive deletion is safer form this point, I'll look at the
> patches closer. Deleting the whole directory subtree with randomly
> scattered subvolumes is not easy atm, I'm using wrappers around find and
> maxdepth/mindepth to look for subvols and issue delete until it's done.

The patches should be independent. Otherwise if you think that changing
the order it would be more simple to merge them (even without the
recursive-non-atomic-snapshot), let me know.

> 
> 
> david
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
