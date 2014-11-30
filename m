Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17-i2.italiaonline.it ([212.48.25.196]:36909 "EHLO
	smtp-17.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751846AbaK3Hry (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 02:47:54 -0500
Message-ID: <547ACBE1.6080506@inwind.it>
Date: Sun, 30 Nov 2014 08:48:49 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: root subvol id is 0 or 5?
References: <CAH-HCWWVR=g6mZFZyu6wYRfP7Harr5bxokJi+_qW8QHsniFPFg@mail.gmail.com>
In-Reply-To: <CAH-HCWWVR=g6mZFZyu6wYRfP7Harr5bxokJi+_qW8QHsniFPFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/30/2014 04:31 AM, Shriramana Sharma wrote:
> I am confused with this: should I call it the "root subvol" or
> "top-level subvol" or "default subvol" or doesn't it matter? Are all
> subvols equal, or some are more equal than others [hark to Orwell's
> Animal Farm ;-)]?
> 
> And more importantly, is the ID of the root subvol 0 or 5?

IIRC the real ID is 5. But if you pass 0, this value is converted in 5

$ grep BTRFS_FS_TREE_OBJECTID *.h
ctree.h:#define BTRFS_FS_TREE_OBJECTID 5ULL
[...]

And in super.c:

[...]
                case Opt_subvolid:
                        num = match_strdup(&args[0]);
                        if (num) {
                                *subvol_objectid = memparse(num, NULL);
                                kfree(num);
                                /* we want the original fs_tree */
                                if (!*subvol_objectid)
                                        *subvol_objectid =
                                                BTRFS_FS_TREE_OBJECTID;

[...]


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
