Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:34340 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbcAXVH7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jan 2016 16:07:59 -0500
Received: by mail-ig0-f181.google.com with SMTP id ik10so22686205igb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jan 2016 13:07:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160124205832.GE908@breitenfeld.lan>
References: <20160124175258.GD908@breitenfeld.lan>
	<CAJCQCtTFwz3YxaYJSnq3M7fQQ152=1ka_Y1ecXT=9LurPSaRrw@mail.gmail.com>
	<20160124205832.GE908@breitenfeld.lan>
Date: Sun, 24 Jan 2016 14:07:58 -0700
Message-ID: <CAJCQCtQfpnis+m0QqSJ28wHidNCm2tAt8UXZuwrPg6fdrLohNw@mail.gmail.com>
Subject: Re: Chicken-egg: uncorrectable checksum error prevents RAID1 rebalancing
From: Chris Murphy <lists@colorremedies.com>
To: Tom Hunt <tomdicksonhunt@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 24, 2016 at 1:58 PM, Tom Hunt <tomdicksonhunt@gmail.com> wrote:
>> You delete the file and yet the scrub still says inode 515 exists and
>> has an error? Or there are no errors, but then after copying the same
>> file back to the volume, the problem reoccurs? Are there any snapshots
>> or subvolumes? Because if there are any subvolumes/snapshots, each is
>> its own fs tree with its own set of inodes. So an inode can be used
>> more than once for different files so I wonder off hand if you haven't
>> found the actual problematic file.
>>
>> Or possibly it's a directory, and not a file.
>
> There are no snapshots, but there are subvolumes. I did the same procedure on
> the file at inode 515 in each subvolume, which was:
>
> # cp $file ~
> # rm $file
> # mv ~/$file {old_file_path}
>
> This concluded without any errors. After doing this, the inode number is
> different, and 'find / -inum 515' no longer finds anything on either subvolume.
> However, initiating a scrub after this still shows the error at ino 515.

Try pointing the find command at the mountpoint, rather than at a subvolume.


-- 
Chris Murphy
