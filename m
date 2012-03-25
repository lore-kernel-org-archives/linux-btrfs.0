From: Waxhead <waxhead@online.no>
Subject: Is btrfsck really required?
Date: Sun, 25 Mar 2012 18:36:34 +0200
Message-ID: <4F6F4992.9030100@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

After playing around with btrfs for a while, reading about it and also 
watching Avi Miller's presentation on youtube I am starting to wonder 
why one would need btrfsck at all. I am no expert in filesystems so I 
apologize if any of these questions may sound a bit stupid.

1. How "self-healing" is btrfs really?! According to Miller's talk btrfs 
is making a (circular?) backup of the root tree every 30 seconds.
If I remember correctly the root tree is also mirrored several places on 
disk and on rotational media all those are updated in tandem. This is 
leading me to believe that there should be no problem in recovering from 
a corruption.

2. Also in addition to question 1. Is there some sanity checking when 
writing the root tree? e.g. if you write garbage to the root tree by 
accident will there be some recovery mechanism there to protect you as well?

3. What is the point with the mount -o recovery ? If there already is a 
corruption there is there any reason btrfs should not recover 
automatically by itself?

4. If a disk responds slowly, Will btrfs throw it out of a raid 
configuration and if so will a btrfsck be less strict about timeouts and 
will it automatically rebalance the data from the bad disk over to other 
good disks?!

