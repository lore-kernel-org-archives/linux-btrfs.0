Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:58662 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaJIS67 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Oct 2014 14:58:59 -0400
Received: by mail-wg0-f41.google.com with SMTP id b13so2114008wgh.12
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Oct 2014 11:58:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAKzf7nLzh1ck7YK8z_E3fx1hK5zWLbKRh1NiG5oVpxuaGtO7Q@mail.gmail.com>
References: <CAAKzf7nLzh1ck7YK8z_E3fx1hK5zWLbKRh1NiG5oVpxuaGtO7Q@mail.gmail.com>
Date: Thu, 9 Oct 2014 13:58:58 -0500
Message-ID: <CAAKzf7=XxK0FXtSrMtFou-gZ9DDYJtuHFy4R5cdjQFjBm0urvg@mail.gmail.com>
Subject: Fwd: Confusion with newly converted filesystem
From: Tim Cuthbertson <ratcheer@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Never mind. I have stumbled my way into a solution.

I ran "btrfs subv delete /ext2_saved". Then I ran "btrfs balance start
/". That relocated 15 of 15 chunks. Now fi show shows 2.03 GB used on
each device and fi df shows 1 GB of metadata total.

Apparently, that saved ext4 subvolume was a real mess.

Tim

---------- Forwarded message ----------
From: Tim Cuthbertson <ratcheer@gmail.com>
Date: Thu, Oct 9, 2014 at 11:41 AM
Subject: Confusion with newly converted filesystem
To: linux-btrfs@vger.kernel.org


I will try to explain what I have done, but also try to keep it fairly
short. I installed a Linux distro that does not support installing to
btrfs to an ext4. I ran dist-upgrade to ensure that I have the latest
btrfs-tools. I upgraded the Debian kernel from 3.13 to 3.16.3. When
all this was completed, there was something like 900 MB used on a 40
GB partition.

Next, I booted to another distro (Arch Linux) which also has the
latest kernel and btrfs-progs. I ran "btrfs-convert /dev/sda6". When I
rebooted to the new Debian system, the btrfs was mounted read-only.
"btrfs fi show /" showed all 40 GB as used. I did some internet
research, then I remounted the filesystem as rw and added another 40
GB partition on a separate disk drive. Then I ran "btrfs balance start
-dusage=30". This seemed to stabilize the filesystem to the point that
it is usable.

I proceeded with my original plan, which was to make it a two-drive
RAID filesystem, using "-dconvert =raid0 -mconvert=raid1". This
succeeded, but the data and metadata usage stats still look all out of
whack. After several rebalance attempts, my usage stats look like the
following:

"btrfs fi show /" shows a total usage of 1.76 GB, with 40 GB allocated
and 14.03 GB used on each device. "btrfs fi df /" shows total data of
2 GB allocated with 1.69 GB used and metadata of 13 GB total with
72.41 MB used.

Why is 13 GB needed for 72 MB of metadata? Is there any understandable
way to fix this? I am not a newbie, but am by no means an expert with
btrfs

Thank you,
Tim
