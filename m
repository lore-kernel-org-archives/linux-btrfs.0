Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:38667 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab3KYVXb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Nov 2013 16:23:31 -0500
Received: from [192.168.1.27] (151.25.181.179) by outrelay08.libero.it (8.6.033) (authenticated as kreijack@libero.it)
        id 52817A1202E3329B for linux-btrfs@vger.kernel.org; Mon, 25 Nov 2013 22:23:30 +0100
Message-ID: <5293BFD1.6000502@libero.it>
Date: Mon, 25 Nov 2013 22:23:29 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS-PROG: recursively subvolume snapshot and delete
References: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
In-Reply-To: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

nobody is interested in these new features ?

On 2013-11-16 18:09, Goffredo Baroncelli wrote:
> Hi All,
> 
> the following patches implement the recursively snapshotting and
> deleting of a subvolume. 
> 
> To snapshot recursively you must pass the -R switch:
> 
> # btrfs subvolume create sub1
> Create subvolume './sub1'
> # btrfs subvolume create sub1/sub2
> Create subvolume 'sub1/sub2'
> 
> # btrfs subvolume snapshot -R sub1 sub1-snap
> Create a snapshot of 'sub1' in './sub1-snap'
> Create a snapshot of 'sub1/sub2' in './sub1-snap/sub2'
> 
> To recursively delete subvolumes, you must pass the switch '-R':
> 
> # btrfs subvolume create sub1
> Create subvolume './sub1'
> # btrfs subvolume create sub1/sub2
> Create subvolume 'sub1/sub2'
> 
> # btrfs subvolume delete -R sub1
> Delete subvolume '/root/sub1/sub2'
> Delete subvolume '/root/sub1'
> 
> 
> Some caveats:
> 1) the recursively behaviour need the root capability
> This because how the subvolume are discovered
> 
> 2) it is not possible to recursively snapshot a subvolume
> in read-only mode
> This because when a subvolume is snapshotted, its 
> nested subvolumes appear as directory in the snapshot.
> These directories are removed before snapshotting the 
> nested subvolumes. This is incompatible with a read
> only subvolume.
> 
> BR
> G.Baroncelli
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
