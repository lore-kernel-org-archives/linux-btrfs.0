Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36.italiaonline.it ([212.48.25.164]:39226 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750994AbbCTTid (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 15:38:33 -0400
Message-ID: <550C7655.10907@libero.it>
Date: Fri, 20 Mar 2015 20:34:45 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: systemd-devel@lists.freedesktop.org
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: [systemd-devel] systemd and nested Btrfs subvolumes
References: <CAJCQCtRFUMAeyjLxADKLVaHA0wqQBY_tbyZoJJ6Hze7AeeTa_w@mail.gmail.com>
In-Reply-To: <CAJCQCtRFUMAeyjLxADKLVaHA0wqQBY_tbyZoJJ6Hze7AeeTa_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,
On 2015-03-20 02:27, Chris Murphy wrote:
> Short version:
> ------------------
>   Instead of machinectl clone using btrfs snapshots, or even needing
> to store things in a var/lib/machines Btrfs subvolume, does it meet
> the requirements for Btrfs optimization to do this with cp -a
> --reflink instead?
> 
> Why? Nested subvolumes are confusing. And nested subvolumes are
> excluded from snapshots. Subvolume B inside of Subvolume A, will not
> be snapshot or rolled back, if I snapshot Subvolume A and subsequently
> rollback to the snapshot of A. 

Personally I prefer this kind of behavior. Each subvolumes may have its life cycle so a rollback on a volume doesn't means that the other also need it.

In the past [2] I proposed a patch to introduces a recursively snapshot; but it was unnoticed :-(

[...]
> Can clone instead use cp -a --reflink instead of using snapshots? Can
> subvolumes be entirely avoided?

[...]

> So back to cp -a --reflink as a work around for both paradigms? Does
> this method of cloning meet the requirements for systemd containers?
> If so, it works on both the RH/Fedora and the openSUSE layouts.
> Meaning the var/lib/machines subvolume isn't needed, just use cp -a
> --reflink on either directories or files, and it's almost as fast as a
> btrfs snapshot.

I think that a "cp --reflink" is slower than a snapshot, because all the metadata still have to be copied. Another disadvantage, is that a snapshot and its parent could be "easily" [3] compared; the same would be not true if a cp --reflink is used. 

> 
> 
> 
> [1]
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg42333.html
> 
> 


[2] http://comments.gmane.org/gmane.comp.file-systems.btrfs/30119
[3] "btrfs find-new" and "btrfs send" do that

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
