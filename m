From: David Nicol <davidnicol@gmail.com>
Subject: thinking about deferred things
Date: Mon, 28 Feb 2011 14:50:15 -0600
Message-ID: <AANLkTi=7w-3_pC8+TX=hzVS0u4sBHiiV8E2wR+DenQ6J@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

What if there was a new structure, with two members, a list_head and
an atomic_t, that could replace the current list_head structures in
the file system info structure with a minimum of patch size, to
facilitate monitoring the completion of deferred actions? That way,
the new additional atomic_t elements would get bound with their lists,
and the fs_info member enumeration would not have to grow. Also, in
order to compile, all uses of a modified list_head member of a
btrfs_fs_info, like


        struct list_head delayed_iputs;

which would get changed to

        struct list_head_plus_atomic delayed_iputs;

would have to be changed from

     &fs_info->delayed_iputs

to

     &fs_info->delayed_iputs.lh



although there may not be any need to explicitly wait for those to complete.

The real question is, what must I do to get the ioctl#21 patch to pass
muster as something to include in the main source?
