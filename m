Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i6.italiaonline.it ([212.48.14.166]:47361 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753297AbdHQU7h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 16:59:37 -0400
Reply-To: kreijack@inwind.it
Subject: Re: btrfs fi du -s gives Inappropriate ioctl for device
To: Chris Murphy <lists@colorremedies.com>
Cc: Piotr Szymaniak <szarpaj@grubelek.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20170814225740.GK19638@pontus.sran>
 <ac3d9310-9b88-dc18-56bf-3e02b15686df@libero.it>
 <CAJCQCtTU9EGhjeug-AzS0TDfySwTQi=dPrFLRDE1Go71E7+W+g@mail.gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <9d24b092-6b03-8d97-b4bd-feb36e00b9e0@inwind.it>
Date: Thu, 17 Aug 2017 22:59:33 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTU9EGhjeug-AzS0TDfySwTQi=dPrFLRDE1Go71E7+W+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 08/17/2017 08:43 PM, Chris Murphy wrote:
> # btrfs sub create test1
> Create subvolume './test1'
> # btrfs sub create test1/test2
> Create subvolume 'test1/test2'
> # btrfs sub snap test1 test1.snap
> Create a snapshot of 'test1' in './test1.snap'
> # btrfs fi du -s test1
>      Total   Exclusive  Set shared  Filename
>      0.00B       0.00B       0.00B  test1
> # btrfs fi du -s test1.snap
>      Total   Exclusive  Set shared  Filename
> ERROR: cannot check space of 'test1.snap': Inappropriate ioctl for device
> #
> 

tanks for the test case. Now I was able to reproduce the problem. The bug(s) are two:

1) to get the treeid of the files/directory, the function lookup_path_rootid() is used, which behaves strangely when it is called on a directory that is BTRFS_EMPTY_SUBVOL_DIR_OBJECTID. In fact this function is commented as following:
[....]
/*
 * For a given:
 * - file or directory return the containing tree root id
 * - subvolume return its own tree id
 * - BTRFS_EMPTY_SUBVOL_DIR_OBJECTID (directory with ino == 2) the result is
 *   undefined and function returns -1
 */
int lookup_path_rootid(int fd, u64 *rootid)
{
[....]

The caller (du_add_file()) doesn't consider this case.

2) in the function du_walk_dir(), an error returned by du_add_file() is ignored, but the return value is not reset. So if the last entry has ino BTRFS_EMPTY_SUBVOL_DIR_OBJECTID (directory with ino == 2) an error is returned. But if there is another directory item no error is returned !

See the following tests cases:

# btrfs sub create test1
# btrfs sub create test1/test2
# btrfs sub snap test1 test1.snap
# btrfs fi du -s test1
     Total   Exclusive  Set shared  Filename
     0.00B       0.00B       0.00B  test1
# btrfs fi du -s test1.snap
     Total   Exclusive  Set shared  Filename
ERROR: cannot check space of 'test1.snap': Inappropriate ioctl for device

But if you add *another* file/dir in test1.snap you got:

# mkdir test1.snap/dir
# btrfs fi du -s test1.snap
     Total   Exclusive  Set shared  Filename
     0.00B       0.00B       0.00B  test1.snap

The error disappear !

Patches will follow shortly

> 
> # uname -r
> 4.13.0-0.rc4.git1.1.fc27.x86_64
> # rpm -q btrfs-progs
> btrfs-progs-4.12-1.fc27.x86_64
> 
> 
> ----
> Chris Murphy
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
