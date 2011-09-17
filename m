From: Michael Cronenworth <mike@cchtml.com>
Subject: long mount time
Date: Fri, 16 Sep 2011 19:10:50 -0500
Message-ID: <4E73E58A.1030607@cchtml.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

System info:
-I have a 2TB hard drive with a GPT and the entire drive is formatted as 
btrfs.
-It is 60% used.
-It is mounted as /home
-Kernel: 3.0.4
-Distro: Fedora 15 x86_64
-CPU: Xeon X3360 (quad core) 2.8ghz

The mount time of the drive is very long. Systemd records it as 7440ms. 
Basically 50% of my boot time is waiting on btrfs to mount. My system is 
plenty fast and ext4 or xfs mounts are extremely fast.

Is there anything that I can do to fix this or is this a btrfs feature?

