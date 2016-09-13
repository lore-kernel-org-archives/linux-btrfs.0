Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35661 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755062AbcIMQmt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 12:42:49 -0400
Received: by mail-wm0-f65.google.com with SMTP id c131so3808495wmh.2
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Sep 2016 09:42:48 -0700 (PDT)
From: Wilson Meier <wilson.meier@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC] Preliminary BTRFS Encryption
In-Reply-To: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
Date: Tue, 13 Sep 2016 18:42:44 +0200
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "clm@fb.com" <clm@fb.com>, "dsterba@suse.cz" <dsterba@suse.cz>
Message-Id: <D92920CA-256D-4E11-A08C-2EF775701670@googlemail.com>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
To: Anand Jain <anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand,

these are great news! Thanks for yor work. I'm looking forward to use the encryption.

I would like to ask a few question regarding the feature set.

1. is encryption of an existing, filled and unencrypted subvolume without manually moving the data possible?

2. What about encrypting the root and boot subvolume? Will it work with grub2?

3. How does btrfs rescue handle the encrypted subvolume to recover data in case of an emergency? 

4. Is it possible to unlock a subvolume using a keyfile?

Thanks in advance,

Wilson


> Am 13.09.2016 um 15:39 schrieb Anand Jain <anand.jain@oracle.com>:
> 
> 
> This patchset adds btrfs encryption support.
> 
> The main objective of this series is to have bugs fixed and stability.
> I have verified with fstests to confirm that there is no regression.
> 
> A design write-up is coming next, however here below is the quick example
> on the cli usage. Please try out, let me know if I have missed something.
> 
> Also would like to mention that a review from the security experts is due,
> which is important and I believe those review comments can be accommodated
> without major changes from here.
> 
> Also yes, thanks for the emails, I hear, per file encryption and inline
> with vfs layer is also important, which is wip among other things in the
> list.
> 
> As of now these patch set supports encryption on per subvolume, as
> managing properties on per subvolume is a kind of core to btrfs, which is
> easier for data center solution-ing, seamlessly persistent and easy to
> manage.
> 
> 
> Steps:
> -----
> 
> Make sure following kernel TFMs are compiled in.
> # cat /proc/crypto | egrep 'cbc\(aes\)|ctr\(aes\)'
> name         : ctr(aes)
> name         : cbc(aes)
> 
> Create encrypted subvolume.
> # btrfs su create -e 'ctr(aes)' /btrfs/e1
> Create subvolume '/btrfs/e1'
> Passphrase: 
> Again passphrase: 
> 
> A key is created and its hash is updated into the subvolume item,
> and then added to the system keyctl.
> # btrfs su show /btrfs/e1 | egrep -i encrypt
>    Encryption:        ctr(aes)@btrfs:75197c8e (594790215)
> 
> # keyctl show 594790215
> Keyring
> 594790215 --alsw-v      0     0  logon: btrfs:75197c8e
> 
> 
> Now any file data extents under the subvol /btrfs/e1 will be
> encrypted.
> 
> You may revoke key using keyctl or btrfs(8) as below.
> # btrfs su encrypt -k out /btrfs/e1
> 
> # btrfs su show /btrfs/e1 | egrep -i encrypt
>    Encryption:        ctr(aes)@btrfs:75197c8e (Required key not available)
> 
> # keyctl show 594790215
> Keyring
> Unable to dump key: Key has been revoked
> 
> As the key hash is updated, If you provide wrong passphrase in the next
> key in, it won't add key to the system. So we have key verification
> from the day1.
> 
> # btrfs su encrypt -k in /btrfs/e1
> Passphrase: 
> Again passphrase: 
> ERROR: failed to set attribute 'btrfs.encrypt' to 'ctr(aes)@btrfs:75197c8e' : Key was rejected by service
> 
> ERROR: key set failed: Key was rejected by service
> 
> # btrfs su encrypt -k in /btrfs/e1
> Passphrase: 
> Again passphrase: 
> key for '/btrfs/e1' has  logged in with keytag 'btrfs:75197c8e'
> 
> Now if you revoke the key the read / write fails with key error.
> 
> # md5sum /btrfs/e1/2k-test-file 
> 8c9fbc69125ebe84569a5c1ca088cb14  /btrfs/e1/2k-test-file
> 
> # btrfs su encrypt -k out /btrfs/e1
> 
> # md5sum /btrfs/e1/2k-test-file 
> md5sum: /btrfs/e1/2k-test-file: Key has been revoked
> 
> # cp /tfs/1k-test-file /btrfs/e1/
> cp: cannot create regular file ‘/btrfs/e1/1k-test-file’: Key has been revoked
> 
> Plain text memory scratches for security reason is pending. As there are some
> key revoke notification challenges to coincide with encryption context switch,
> which I do believe should be fixed in the due course, but is not a roadblock
> at this stage.
> 
> Thanks, Anand
> 
> 
> Anand Jain (1):
>  btrfs: Encryption: Add btrfs encryption support
> 
> fs/btrfs/Makefile               |   4 +-
> fs/btrfs/btrfs_inode.h          |   6 +
> fs/btrfs/compression.c          |  30 +-
> fs/btrfs/compression.h          |  10 +-
> fs/btrfs/ctree.h                |   4 +
> fs/btrfs/disk-io.c              |   3 +
> fs/btrfs/encrypt.c              | 807 ++++++++++++++++++++++++++++++++++++++++
> fs/btrfs/encrypt.h              |  94 +++++
> fs/btrfs/inode.c                | 255 ++++++++++++-
> fs/btrfs/ioctl.c                |  67 ++++
> fs/btrfs/lzo.c                  |   2 +-
> fs/btrfs/props.c                | 331 +++++++++++++++-
> fs/btrfs/super.c                |  27 +-
> fs/btrfs/tests/crypto-tests.c   | 376 +++++++++++++++++++
> fs/btrfs/tests/crypto-tests.h   |  38 ++
> fs/btrfs/zlib.c                 |   2 +-
> include/uapi/linux/btrfs_tree.h |   6 +-
> 17 files changed, 2027 insertions(+), 35 deletions(-)
> create mode 100644 fs/btrfs/encrypt.c
> create mode 100644 fs/btrfs/encrypt.h
> create mode 100755 fs/btrfs/tests/crypto-tests.c
> create mode 100755 fs/btrfs/tests/crypto-tests.h
> 
> Anand Jain (2):
>  btrfs-progs: make wait_for_commit non static
>  btrfs-progs: add encryption support
> 
> Makefile.in       |   5 +-
> btrfs-list.c      |  33 ++++
> cmds-filesystem.c |   4 +-
> cmds-restore.c    |  16 ++
> cmds-subvolume.c  | 112 ++++++++++++--
> commands.h        |   1 +
> ctree.h           |   5 +-
> encrypt.c         | 455 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> encrypt.h         |  46 ++++++
> props.c           |   4 +
> utils.h           |   2 +
> 11 files changed, 665 insertions(+), 18 deletions(-)
> create mode 100644 encrypt.c
> create mode 100644 encrypt.h
> 
> Anand Jain (1):
>  fstests: btrfs: support encryption
> 
> common/filter.btrfs |   2 +-
> common/rc           |   2 +-
> tests/btrfs/041     |   2 +
> tests/btrfs/041.out |  13 ++++
> tests/btrfs/052     |  12 +++
> tests/btrfs/052.out | 214 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> tests/btrfs/079     |   2 +
> tests/btrfs/125     |   2 +-
> tests/generic/297   |   6 +-
> tests/generic/298   |   2 +-
> 10 files changed, 251 insertions(+), 6 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
