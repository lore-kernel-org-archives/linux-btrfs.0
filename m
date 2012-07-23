Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62515 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab2GWP2W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jul 2012 11:28:22 -0400
Received: by qcro28 with SMTP id o28so3283936qcr.19
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jul 2012 08:28:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <500D328F.7050904@gmx.net>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
	<1341409108-13567-8-git-send-email-ablock84@googlemail.com>
	<500D328F.7050904@gmx.net>
Date: Mon, 23 Jul 2012 18:28:21 +0300
Message-ID: <CAHf9xvbfUtAk5Di8CSSTv9kuOPTb8HZDxVWTiM-0ZExAhD7cHw@mail.gmail.com>
Subject: Re: [RFC PATCH 7/7] Btrfs: introduce BTRFS_IOC_SEND for btrfs
 send/receive (part 2)
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Arne Jansen <sensille@gmx.net>
Cc: Alexander Block <ablock84@googlemail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Arne,

(pls don't take this as if I pretend to have understood the code
better than you, because I have a list of questions for Alexander
too).

>> +/*
>> + * Helper function to generate a file name that is unique in the root of
>> + * send_root and parent_root. This is used to generate names for orphan inodes.
>> + */
>> +static int gen_unique_name(struct send_ctx *sctx,
>> +                        u64 ino, u64 gen,
>> +                        struct fs_path *dest)
>> +{
>> +     int ret = 0;
>> +     struct btrfs_path *path;
>> +     struct btrfs_dir_item *di;
>> +     char tmp[64];
>> +     int len;
>> +     u64 idx = 0;
>> +
>> +     path = alloc_path_for_send();
>> +     if (!path)
>> +             return -ENOMEM;
>> +
>> +     while (1) {
>> +             len = snprintf(tmp, sizeof(tmp) - 1, "o%llu-%llu-%llu",
>> +                             ino, gen, idx);
>
> wouldn't it be easier to just take a uuid? This would save you a lot
> of code and especially the need to verify that the name is really
> unique, saving seeks.

As far as I understand the logic of orphans, the unique name should
depend only on the send_root and parent_root contents, which are both
frozen. So when you re-generate this name for a particular (ino,gen),
you must receive the same exact name every time. If the user has kind
of oXXX-YY-Z file(s) in the top dir by accident, then they are the
same every time we recalculate the orhpan name, so we get the same
result every time. Does it make sense?
So did you mean to generate a uuid here, and save it somewhere
in-memory, and later look it up based on (ino,gen)? Or you mean some
other improvement?

Thanks,
Alex.
