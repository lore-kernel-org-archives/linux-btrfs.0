Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wmauth3.doit.wisc.edu ([144.92.197.226]:39103 "EHLO
        smtpauth3.wiscmail.wisc.edu" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S964841AbcLTQw3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2016 11:52:29 -0500
MIME-version: 1.0
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Received: from avs-daemon.smtpauth3.wiscmail.wisc.edu by
 smtpauth3.wiscmail.wisc.edu
 (Oracle Communications Messaging Server 8.0.1.1.0 64bit (built Jun 15 2016))
 id <0OIH00E00Q9HQE00@smtpauth3.wiscmail.wisc.edu> for
 linux-btrfs@vger.kernel.org; Tue, 20 Dec 2016 09:52:27 -0600 (CST)
Received: from Square-Circle-Consulting-LLC.local
 (97-88-43-202.dhcp.roch.mn.charter.com [97.88.43.202])
 by smtpauth3.wiscmail.wisc.edu
 (Oracle Communications Messaging Server 8.0.1.1.0 64bit (built Jun 15 2016))
 with ESMTPSA id <0OIH0025OQRDPT10@smtpauth3.wiscmail.wisc.edu> for
 linux-btrfs@vger.kernel.org; Tue, 20 Dec 2016 09:52:27 -0600 (CST)
From: David Hanke <hanke.list@ece.wisc.edu>
Subject: btrfs_log2phys: cannot lookup extent mapping
To: linux-btrfs@vger.kernel.org
Message-id: <89be6fee-5b18-7a9d-11ea-85abeab28022@ece.wisc.edu>
Date: Tue, 20 Dec 2016 09:52:25 -0600
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings!

I've been using a btrfs-based volume for backups, but lately the 
system's been filling the syslog with errors like "btrfs_log2phys: 
cannot lookup extent mapping for 7129125486592" at the rate of hundreds 
per second. (Please see output below for more details.) Despite the 
errors, the files I've looked at appear to be written and read successfully.

I'm wondering if the contents of the volume are trustworthy and whether 
this problem is resolvable without backing up, erasing and starting over?

Thank you!

David


# uname -a
Linux backup2 3.0.101.RNx86_64.3 #1 SMP Wed Apr 1 16:02:14 PDT 2015 
x86_64 GNU/Linux

# btrfs --version
Btrfs v3.17.3

#   btrfs fi show
Label: '43f66d40:root'  uuid: 6e546e1a-15a3-4e9d-97f7-9693659a5e7e
     Total devices 1 FS bytes used 571.47MiB
     devid    1 size 4.00GiB used 3.36GiB path /dev/md0

Label: '43f66d40:data'  uuid: 0900d3c7-fda1-463a-81e5-19c04e68a0cb
     Total devices 1 FS bytes used 27.61TiB
     devid    1 size 36.34TiB used 27.99TiB path /dev/md127

Btrfs v3.17.3

# dmesg | head
s_log2phys: cannot lookup extent mapping for 7168108658688
btrfs_log2phys: cannot lookup extent mapping for 7168108658688
btrfs_log2phys: cannot lookup extent mapping for 7168108658688
btrfs_log2phys: cannot lookup extent mapping for 7168108658688
btrfs_log2phys: cannot lookup extent mapping for 7168108658688
btrfs_log2phys: cannot lookup extent mapping for 7168108658688
btrfs_log2phys: cannot lookup extent mapping for 7168108658688
btrfs_log2phys: cannot lookup extent mapping for 7168108658688
btrfs_log2phys: cannot lookup extent mapping for 7168108658688
btrfs_log2phys: cannot lookup extent mapping for 7168108658688

# dmesg | tail
btrfs_log2phys: cannot lookup extent mapping for 7168110034944
btrfs_log2phys: cannot lookup extent mapping for 7168110034944
btrfs_log2phys: cannot lookup extent mapping for 7168110034944
btrfs_log2phys: cannot lookup extent mapping for 7168110034944
btrfs_log2phys: cannot lookup extent mapping for 7168110034944
btrfs_log2phys: cannot lookup extent mapping for 7168110034944
btrfs_log2phys: cannot lookup extent mapping for 7168110034944
btrfs_log2phys: cannot lookup extent mapping for 7168110034944
btrfs_log2phys: cannot lookup extent mapping for 7168110034944
btrfs_log2phys: cannot lookup extent mapping for 7168110034944

[dmesg.log is filled with 3951 lines of the same type of errors]

