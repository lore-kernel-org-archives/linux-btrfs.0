Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:51675 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965321AbcKXOAb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Nov 2016 09:00:31 -0500
Received: from localhost (unknown [192.168.1.156])
        by mail.linuxsystems.it (Postfix) with ESMTPSA id 8E052A9AF2
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Nov 2016 15:00:28 +0100 (CET)
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: <linux-btrfs@vger.kernel.org>
Subject: Increased disk usage after deduplication and system running out of =?iso-8859-1?Q?memory?=
Date: Thu, 24 Nov 2016 15:00:26 +0100
MIME-Version: 1.0
Message-ID: <51c36f62-739b-425c-9252-8f7dcf9d016c@linuxsystems.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I use snapper, so I have plenty of snapshots in my btrfs partition and most 
of my data is already deduplicated because of that.
Since long time ago I run offline defragmentation once (because I didn't 
know extents get unshared) I wanted to run offline deduplication to free a 
couple of GBs.

This is the script I use to stop snapper, set snapshots to rw, balance, 
deduplicate, etc: https://paste.pound-python.org/show/vPUGVNjPQbDvr4HbtMgs/

$ cat after_balance 
Overall:
    Device size:                 152.36GiB                                  
                                                                            
                                                                            
                         
    Device allocated:            136.00GiB                                  
                                                                            
                                                                            
                         
    Device unallocated:           16.35GiB                                  
                                                                            
                                                                            
                         
    Device missing:                  0.00B                                  
                                                                            
                                                                            
                         
    Used:                        133.97GiB                                  
                                                                            
                                                                            
                         
    Free (estimated):             17.17GiB      (min: 17.17GiB)             
                                                                            
                                                                            
                         
    Data ratio:                       1.00                                  
                                                                            
                                                                            
                         
    Metadata ratio:                   1.00                                  
                                                                            
                                                                            
                         
    Global reserve:              239.94MiB      (used: 0.00B)               
                                                                            
                                                                            
                         
                                                                            
                                                                            
                                                                            
                         
Data,single: Size:133.00GiB, Used:132.18GiB                                 
                                                                            
                                                                            
                         
   /dev/mapper/cryptroot         133.00GiB                                  
                                                                            
                                                                            
                         
                                                                            
                                                                            
                                                                            
                         
Metadata,single: Size:3.00GiB, Used:1.79GiB                                 
                                                                            
                                                                            
                         
   /dev/mapper/cryptroot           3.00GiB                                  
                                                                            
                                                                            
                         
                                                                            
                                                                            
                                                                            
                         
System,single: Size:3.00MiB, Used:16.00KiB                                  
                                                                            
                                                                            
                         
   /dev/mapper/cryptroot           3.00MiB                                  
                                                                            
                                                                            
                         
                                                                            
                                                                            
                                                                            
                         
Unallocated:                                                                
                                                                            
                                                                            
                         
   /dev/mapper/cryptroot          16.35GiB                                  
                                                                            
                                                                            
                         


$ cat after_duperemove_and_balance                                          
                                                                            
                                                                            
   
Overall:                                                                    
                                                                            
                                                                            
                         
    Device size:                 152.36GiB                                  
                                                                            
                                                                            
                         
    Device allocated:            136.03GiB                                  
                                                                            
                                                                            
                         
    Device unallocated:           16.33GiB                                  
                                                                            
                                                                            
                         
    Device missing:                  0.00B                                  
                                                                            
                                                                            
                         
    Used:                        133.81GiB                                  
                                                                            
                                                                            
                         
    Free (estimated):             16.55GiB      (min: 16.55GiB)             
                                                                            
                                                                            
                         
    Data ratio:                       1.00                                  
                                                                            
                                                                            
                         
    Metadata ratio:                   1.00                                  
                                                                            
                                                                            
                         
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:127.00GiB, Used:126.77GiB
   /dev/mapper/cryptroot         127.00GiB

Metadata,single: Size:9.00GiB, Used:7.03GiB
   /dev/mapper/cryptroot           9.00GiB

System,single: Size:32.00MiB, Used:16.00KiB
   /dev/mapper/cryptroot          32.00MiB

Unallocated:
   /dev/mapper/cryptroot          16.33GiB


As you can see it freed 5.41 GB of data, but it also added 5.24 GB of 
metadata. The estimated free space is now 16.55 GB, while before the 
deduplication it was higher: 17.17 GB.

This is when running duperemove git with noblock, but almost nothing 
changes if I omitt it (it defaults to block).
Why did my metadata increase by a 4x factor? 99% of my data already had 
shared extents because of snapshots, so why such a huge increase?

Deduplication didn't finish up to 100%, because duperemove got killed by 
OOM killer at 99%: 
https://paste.pound-python.org/show/yUcIOSzXcrfNPkF9rV2L/

As you can see from dmesg 
(https://paste.pound-python.org/show/eZIkpxUU6QR9ij6Rn1Oq/) there is no 
process stealing so much memory (my system has 8GB): the biggest one takes 
as much as 700MB of vm.

Another strange thing that you can see from the previous log is that it 
tries to deduplicate /home/niko/nosnap/rootfs/@images/fedora25.qcow2 which 
is a UNIQUE file. Such image is stored in a separate subvolume because I 
don't want it to be snapshotted, so I'm pretty sure there are no other 
copies of this image, but still it tries to deduplicate it.

Niccolò Belli
