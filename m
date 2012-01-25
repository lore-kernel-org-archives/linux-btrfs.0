From: Waxhead <waxhead@online.no>
Subject: How well does BTRFS manage different sized disks?
Date: Thu, 26 Jan 2012 00:43:23 +0100
Message-ID: <4F20939B.1030303@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Can someone shed some light on how BTRFS will manage a bunch of disks of 
varying size for the planned raid5/6. e.g. 3x 2TB disk and 1x 250GB 
disk? If using a raid5 setup will a 750GB of usable data automatically 
be used as a 4 disk raid5 while the rest is used as a 3 disk raid5?! If 
so; how do you control what files are on the "speedy" section of the volume?
