Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56402 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755538AbcCBBHN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 20:07:13 -0500
Subject: Re: [RFC] Experimental btrfs encryption
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
CC: <clm@fb.com>, <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56D63CB1.5070202@cn.fujitsu.com>
Date: Wed, 2 Mar 2016 09:06:57 +0800
MIME-Version: 1.0
In-Reply-To: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Anand Jain wrote on 2016/03/02 00:08 +0800:
> This patchset adds btrfs encryption support.
>
> Warning:
> The code is in prototype/experimental stage and is not suitable
> for the production data yet.
>
> Example usage:
> Create an encrypted subvolume:
>    btrfs subvol create -e /btrfs/sv1
>    Paraphrase: <-
>
> Review encryption status
>    btrfs subvol show /btrfs/sv1
>    btrfs/sv1
>      Name: sv1
>      UID: d8bf1718-56a7-da40-86d9-b8e87315f63f
>      Parent UUID: -
>      Received UUID: -
>      Creation time: 2016-03-01 17:11:58 +0800
>      Subvolume ID: 257
>      Generation: 13
>      Gen at creation:7
>      Parent ID: 5
>      Top level ID: 5
>      Flags: -
>      Encryption: aes@btrfs:d8bf1718 (188612608)
>                     ^ ^^^^^^^^^^^^^^ ^^^^^^^^^
>                     |        |               |
>                  Algorithm Key-Tag Key-serial-number
>
>    keyctl show
>    ::
>    188612608 --alswrv 0 0 \_ user: btrfs:d8bf1718
>
> Logout/revoke:
>    btrfs subvol encrypt -k out /btrfs/sv1
>    btrfs subvol show /btrfs/sv1 | egrep Encrypt
>    Encryption: aes@btrfs:d8bf1718 (Required key not available)
>
> sign in:
>    btrfs subvol encrypt -k in /btrfs/sv1
>
> Known issues / limitation / for future expansion:
> - Need to set FS incompatible feature.

Not a limitation at all.

>
> - No password verification yet.
>
> - Move of files across subvolume is not supported when both
>    or either one has encryption set.

Not only move, but also reflink/inband dedup.

>
> - No way to change the password.
>
> - Does not drop the cached pages when key is revoked.
>
> - Need to get password twice from the user.
>
> - No user permeable subvol info ioctl.
>
> - Provide a method to pass key using the mount option.
>
> - Provide a method to read the key from the file.
>
> - Current encryption method is symmetric (same key for both
>    encryption and decryption), however we could easily expand
>    this to other potentially useful methods like asymmetric
>    (private/public) encryption.
>
> - As of now uses "user" keytype, I am still considering/
>    evaluating other key type such as logon.

UI things can always be reconsidered later.
Never a big problem.

>
> - Evaluate other encryption algorithms,  as of now it is
>    using "cts(cbc(aes)".
>
> - Uses btrfs compression framework, so compression and then
>    encryption is not possible. However yet evaluate if there
>    are encryption algorithm which can compress as well.

Yes, but in fact, you can use another method, just like in-band de-dup, 
by adding new hook into async_cow_start() and async_cow_end(), allowing 
compression and encryption can be done at the same time.
(We are already testing the patch to allow dedup to cooperate with 
compression)

So no need to find a encryption with can compress.
(Never mix 2 different work together)


And maybe I just missed something, but the filename seems not touched, 
meaning it will leak a lot of information.
Just like default eCryptfs behavior.

I understand that's an easy design and it's not a high priority thing, 
but I hope we can encrypt the subvolume tree blocks too, if using 
per-subvolume policy.
To provide a feature near block-level encryption.

Thanks,
Qu
>
>
> Anand Jain (1):
>    btrfs: encryption
>
>   fs/btrfs/Makefile      |   2 +-
>   fs/btrfs/btrfs_inode.h |   2 +
>   fs/btrfs/compression.c |  53 ++++-
>   fs/btrfs/compression.h |   1 +
>   fs/btrfs/ctree.h       |  11 +-
>   fs/btrfs/encrypt.c     | 544 +++++++++++++++++++++++++++++++++++++++++++++++++
>   fs/btrfs/encrypt.h     |  21 ++
>   fs/btrfs/inode.c       |  37 +++-
>   fs/btrfs/ioctl.c       |   7 +
>   fs/btrfs/props.c       | 140 ++++++++++++-
>   fs/btrfs/super.c       |   5 +-
>   11 files changed, 812 insertions(+), 11 deletions(-)
>   create mode 100644 fs/btrfs/encrypt.c
>   create mode 100644 fs/btrfs/encrypt.h
>
> Anand Jain (2):
>    btrfs-progs: subvolume functions reorg
>    btrfs-progs: add encrypt as subvol sub-command
>
>   Makefile.in      |   5 +-
>   btrfs-list.c     |  33 +++++
>   cmds-qgroup.c    |   1 +
>   cmds-send.c      |  12 +-
>   cmds-subvolume.c | 209 +++++++++++++++--------------
>   commands.h       |   1 +
>   encrypt.c        | 397 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   encrypt.h        |  33 +++++
>   props.c          |   3 +
>   subvolume.c      | 152 +++++++++++++++++++++
>   subvolume.h      |  22 +++
>   11 files changed, 757 insertions(+), 111 deletions(-)
>   create mode 100644 encrypt.c
>   create mode 100644 encrypt.h
>   create mode 100644 subvolume.c
>   create mode 100644 subvolume.h
>


