Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f179.google.com ([209.85.210.179]:62868 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab2LaTCH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Dec 2012 14:02:07 -0500
Received: by mail-ia0-f179.google.com with SMTP id o25so10830024iad.10
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Dec 2012 11:02:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOcd+r3c7ct3qS396=nXdhyN_7Ku5cpbog4zLZEdXK=TjfHn0w@mail.gmail.com>
References: <CAFhuFEdxHxdiAutfxxsQ9i0OJj_CfRwWD-0LuhvoJYGHkTsG4A@mail.gmail.com>
	<CAOcd+r1LnMP=CU37mUSxZGuksTY4kYo+Y5vg9n3BV-E=ye=-Yg@mail.gmail.com>
	<CANTVtNqzGmK2fb3EEXtjAanNBGxBCN2T44wnMw9xLTYSyPV3vA@mail.gmail.com>
	<CAOcd+r2fS-=dCU-v8ZLUNGrS3ojfhLXYAtBek-JGvvOJLOar3Q@mail.gmail.com>
	<CANTVtNqB_C+srL9DsL2b7QC1rUT4m5-6RHR6CqQbajQm2NCy0w@mail.gmail.com>
	<CAOcd+r05VgvOrW-_X89OyVd-AgJuyXt0O4ZhJ=ZisaZDJkxuhg@mail.gmail.com>
	<CAFhuFEeV-NpkGTdV+yh0K3vWj-1ntQNSkwtg1r=SyZ04dSkHaA@mail.gmail.com>
	<CAFhuFEc9YRhP1aN_1-JG7VRfC0_pNA2nwK7-nzR6kj7bbNoX4g@mail.gmail.com>
	<CAFhuFEc==AeTi8cjHHCZDiP-xN6XLJDJmW4pVtnhr2rcWVEoag@mail.gmail.com>
	<CAOcd+r3c7ct3qS396=nXdhyN_7Ku5cpbog4zLZEdXK=TjfHn0w@mail.gmail.com>
Date: Mon, 31 Dec 2012 21:02:06 +0200
Message-ID: <CAOcd+r2YoqWbPFSi+kt4indZvaP_XkRzqkTOL8FwiXEYzzmSmg@mail.gmail.com>
Subject: Re: Snapper snapshot comparison algorithm
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: nafisa mandliwala <nafisa.mandliwala@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Alexander Block <ablock84@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Small correction,I was just hit by this:

> # The tuple (inode_number, inode generation) is unique within a
> particular btrfs subvolume. Inode numbers can be reused via
> "inode_cache" mount option if it is set, however, same inode number
> (after deletion of previous one) will have another inode generation if
> it is reused. The changed_inode function determines this case by
> setting cur_inode_new_gen flag. In that case it knows, that this is
> not the same inode that was just changed, so it needs to delete the
> old inode and create a new one. If you ignore this case at first (say
> you don't use inode_cache), then this function becomes pretty simple.

Even if "inode_cache" mount option is not used, inode number still can
be reused!
Looking at btrfs_find_free_objectid():
	if (unlikely(root->highest_objectid < BTRFS_FIRST_FREE_OBJECTID)) {
		ret = btrfs_find_highest_objectid(root,
						  &root->highest_objectid);
		if (ret)
			goto out;
	}

So after mount root->highest_objectid is set to 0, and later
initialized on-demand. So the scenario to reuse the inode number is as
follows:
# mount the filesystem
# delete the file that has the highest inode number
# create a new file

At this point the new file will get the same inode number. Amazing!


Alex.
