Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:38793 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751104AbdJBTHc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Oct 2017 15:07:32 -0400
Reply-To: kreijack@inwind.it
Subject: Re: What means "top level" in "btrfs subvolume list" ?
To: Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <762acea0-3f55-4fc0-c5eb-604304152f3e@inwind.it>
 <22991.45029.564275.154171@tree.ty.sabi.co.uk>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <4f1fccd3-4127-2e55-2014-1e4bdb6e94cd@libero.it>
Date: Mon, 2 Oct 2017 21:07:28 +0200
MIME-Version: 1.0
In-Reply-To: <22991.45029.564275.154171@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/30/2017 04:53 PM, Peter Grandi wrote:
>> My Hypothesis, it should be the ID of the root subvolume ( or
>> 5 if it is not mounted). [ ... ]
> Well, a POSIX filesystem typically has a root directory, and it
> can be mounted as the system root or any other point. A Btrfs
> filesystem has multiple root directories, that are mounted by
> default "somewhere" (a design decision that I think was unwise,
> but "whatever").

I agree that the possibility to create a subvolume/snapshot everywhere could create a bit of confusion; i.e. the "mountpoint" of a subvolume after a snapshot is a very strange beast:

ghigo@venice:/tmp$ btrfs sub cre sv1
Create subvolume './sv1'
ghigo@venice:/tmp$ btrfs sub cre sv1/sv2
Create subvolume 'sv1/sv2'
ghigo@venice:/tmp$ btrfs sub snap  sv1 sn1
Create a snapshot of 'sv1' in './sn1'
ghigo@venice:/tmp$ ls -lid sn1/
256 drwxr-xr-x 1 ghigo ghigo 6 Oct  2 20:54 sn1/
ghigo@venice:/tmp$ ls -li sn1/
total 0
2 drwxr-xr-x 1 root root 0 Oct  2 20:55 sv2
ghigo@venice:/tmp$ touch sn1/sv2/foo
touch: cannot touch 'sn1/sv2/foo': Permission denied
ghigo@venice:/tmp$ sudo touch sn1/sv2/foo
touch: cannot touch 'sn1/sv2/foo': Permission denied

It seems a directory, but it is not allowed to create file inside (!)

However the user is free to limit itself to create snapshot only under / (rootid==5) :-). 

 
> The subvolume containing the mountpoint directory of another
> subvolume's root directory is is no way or sense its "parent",
> as there is no derivation relationship; root directories are
> independent of each other and their mountpoint is (or should be)
> a runtime entity.

This is true. However I think that "btrfs fi list" was designed to show where subvolumes (or snapshots) are, for two reasons:
1) avoid to search trough all the filesystem looking for directory having inode=256
2) when the user mounts a subvolume as root, he has not direct access to all subvolume unless he also mount / (rootid=5) on another place. "btrfs sub list" has not this limit

BTW, my preferred choice is:
- mount a subvolume as root; 
- mount the root filesystem (rootid=5) under /var/btrfs
- make snapshot and/or subvolume only under / (rootid=5), handle these in /var/btrfs
- if needed, mount a subvolume in the filesystem through fstab;
- however I am still searching a way to handle the snapshots which fully satisfy  me (putting them under /, is not the best)

BR

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
