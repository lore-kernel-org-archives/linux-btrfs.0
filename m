From: Yoshinori Sano <yoshinori.sano@gmail.com>
Subject: On Removing BUG_ON macros
Date: Sun, 7 Nov 2010 16:16:47 +0900
Message-ID: <AANLkTinQPUW3wRGU96mKA1DMHUoAQUrtKwqqQvvPoxB=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris.mason@oracle.com, josef@redhat.com,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a question I've posted on the #btrfs IRC channel today.
hyperair adviced me to contact with Josef Bacik or Chris Mason.
So, I post my question to this maling list.

Here are my post on the IRC:

Actually, I want to remove BUG_ON(ret) around the Btrfs code.
The motivation is to make the Btrfs code more robust.
First of all, is this meaningless?

For example, there are code like the following:

    struct btrfs_path *path;
    path = btrfs_alloc_path();
    BUG_ON(!path);

This is a frequenty used pattern of current Btrfs code.
A btrfs_alloc_path()'s caller has to deal with the allocation failure
instead of using BUG_ON.  However, (this is what most interesting
thing for me) can the caller do any proper error handlings here?
I mean, is this a critical situation where we cannot recover from?

-- 
Yoshinori Sano <yoshinori.sano@gmail.com>
