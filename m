Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:38601 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752212AbdLESYP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 13:24:15 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [RFC] Improve subvolume usability for a normal user
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <de59ec02-fb65-d101-4b99-628dc280a63e@libero.it>
Date: Tue, 5 Dec 2017 19:24:12 +0100
MIME-Version: 1.0
In-Reply-To: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/05/2017 09:25 AM, Misono, Tomohiro wrote:
> Hello all,
> 
> I want to address some issues of subvolume usability for a normal user.
> i.e. a user can create subvolumes, but
>  - Cannot delete their own subvolume (by default)
>  - Cannot tell subvolumes from directories (in a straightforward way)
>  - Cannot check the quota limit when qgroup is enabled
> 
> Here I show the initial thoughts and approaches to this problem.
> I want to check if this is a right approach or not before I start writing code.
> 
> Comments are welcome.
> Tomohiro Misono
> 
> ==========
> - Goal and current problem
> The goal of this RFC is to give a normal user more control to their own subvolumes.
> Currently the control to subvolumes for a normal user is restricted as below: 
> 
> +-------------+------+------+
> |   command   | root | user |
> +-------------+------+------+
> | sub create  | Y    | Y    |
> | sub snap    | Y    | Y    |
> | sub del     | Y    | N    |
> | sub list    | Y    | N    |
> | sub show    | Y    | N    |
> | qgroup show | Y    | N    |
> +-------------+------+------+
> 

I suggest to consider also 

   btrfs fi usage

see my patches [1] and [2]

> In short, I want to change this as below in order to improve user's usability:
> 
> +-------------+------+--------+
> |   command   | root | user   |
> +-------------+------+--------+
> | sub create  | Y    | Y      |
> | sub snap    | Y    | Y      |
> | sub del     | Y    | N -> Y |
> | sub list    | Y    | N -> Y |
> | sub show    | Y    | N -> Y |
> | qgroup show | Y    | N -> Y |
> +-------------+------+--------+
> 
> In words,
> (1) allow deletion of subvolume if a user owns it, and 
I commented this in another part of this thread. My suggestion is to extend unlink(2) to remove a subvolume if it is empty, and if the user has needed privileges. This would be fully POSIX compliant.

[....]

> 
>  (2) getting subvolume/quota info
> 
>   TREE_SEARCH ioctl is used to retrieve the subvolume/quota info by btrfs-progs
>   (sub show/list, qgroup show etc.). This requires the root permission.
>   
>   The easiest way to allow a user to get subvolume/quota info is just relaxing
>   the permission of TREE_SEARCH. However, since all the tree information (inc.
>   file name) will be exposed, this poses a sequrity risk and is not acceptable.
>   
>   So, I want to introduce 2 ioctls to get subvolume/quota info respectively for
>   a normal user, which return only the info readable by the user:
>   
>    [subvolume info]
>     Mainly search ROOT tree for ROOT_ITEM/ROOT_BACKREF, but check its read
>    right by searching FS/FILE tree and comparing it with caller's uid.

Is it POSIX compliant ? Currently I can't access an entry if its parent directory doesn't have the 'x' bit enabled.
>From another point of view, a subvolume is more like a "mount --bind". And I can know which and where devices are mounted looking at /proc/self/mountinfo.

I fear that we should build the path at the kernel level, then check (again at the kernel level) if all path elements are accessible by the user, and then returning the full path to the user. I am incline to think that accessing element by element (on the basis of the parent directory access bit), would be a nightmare from posix compliance POV.

A more simple approach would be traversing all the filesystem tree (via opendir/readdir) and return all the idem with inode == 256 (something like 'find / -inum 256'). Even tough it would be very inefficient


>   
>    [quota info]
>     Same as above, but mainly search QUOTA tree and only returns level 0 info.
>   
>   Also, in order to construct subvolume path, permission of INO_LOOKUP ioctl
>   needs to be relaxed for the user who has read access to the subvolume.
> 
> 
> - Summary of Proposal
>  - Change the default behavior to allow a user to delete their own subvolumes
>  - Add 2 new non-root ioctls to get subvolume/quota info for accessible subvolumes
> ==========
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

[1] https://www.spinics.net/lists/linux-btrfs/msg69564.html
[2] https://www.spinics.net/lists/linux-btrfs/msg69566.html

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
