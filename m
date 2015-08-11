Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:36788 "EHLO
	mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462AbbHKUzM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 16:55:12 -0400
Received: by vkbf67 with SMTP id f67so17972863vkb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2015 13:55:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK7bmU8wyeX6THM=UB4_D3u-9j8hSuaZAY0uSASBXgcfkjfSTg@mail.gmail.com>
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
	<CAJCQCtS=v+T-qGFLeaELn7Bt+Mb8ViK+8+YgontAE=1ucAnWZg@mail.gmail.com>
	<CAK7bmU_d3RTU4HZVHB9Z7ZAOpQ8C-wZn7WpvYsJaXiGDJki7fg@mail.gmail.com>
	<CAJCQCtQ9kxpuQD3k-rO84O+0jRpiWbCJAUdog+2_Da6EK5yGsQ@mail.gmail.com>
	<CAK7bmU9X8cvPs2sn3eZRaOowoT2H5jthpessWMQSVgvojjJ5EA@mail.gmail.com>
	<CAK7bmU_xV=2Mh0zj6c3Wj54HDi0vCWmon-Z9E6h14hGws2-YAg@mail.gmail.com>
	<CAJCQCtQ2L=s2KP8ttLkeA+pnOqePvToK-evsc9nA43Ewv3GgEw@mail.gmail.com>
	<CAK7bmU8wyeX6THM=UB4_D3u-9j8hSuaZAY0uSASBXgcfkjfSTg@mail.gmail.com>
Date: Tue, 11 Aug 2015 14:55:11 -0600
Message-ID: <CAJCQCtTwc4sZV+DjMPVaOkQmsNJe0=Rd7XVkDC_8kfs-_Eaqdg@mail.gmail.com>
Subject: Re: Damaged filesystem, can read, can't repair, error says to contact devs
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 11, 2015 at 2:32 PM, Timothy Normand Miller
<theosib@gmail.com> wrote:
> If I lose the array, I won't cry.  The backup appears to be complete.
> But it would be convenient to avoid having to restore from scratch,
> and I'm hoping this might help you guys too in some way.  I really
> like btrfs, and I would like provide you with whatever info might
> contribute something.

Well it seems fine if it mounts rw,degraded. Just do a 'btrfs replace
start...' with a new drive. Or if you're going to try the old drive
that's failing, good luck with that. You might want to at least zero
out all the superblocks. Check the wiki for their location, wipefs
only removes the signature of the 1st superblock. I don't know if
that's enough for the purposes of a btrfs replace start (probably is
but I haven't tested it).

But then you need to fix this nodatacow thing by not using it as a
mount option, and setting it as a subvolume or directory option with
chattr +C. That way everything else is checksummed. Then you will use
btrfs check --init-csum-tree to compute checksums for everything that
right now have none due to nodatacow.

-- 
Chris Murphy
