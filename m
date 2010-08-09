From: "K. Richard Pixley" <rich@noir.com>
Subject: Code bug or data bug?
Date: Mon, 09 Aug 2010 15:20:53 -0700
Message-ID: <4C607F45.3020901@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

  I've just gotten:

rich@diamonds:~$ time sudo /sbin/btrfsck /dev/sda7
btrfsck: btrfsck.c:585: splice_shared_node: Assertion `!(src == 
&src_node->root_cache)' failed.
Aborted

Does this indicate a coding error in btrfsck or a data error in my file 
system?

--rich

rich@diamonds:~$ dpkg -l | grep btrfs
ii  btrfs-tools                                
0.19+20100601-3                                 Checksumming Copy on 
Write Filesystem utilit
rich@diamonds:~$ uname -a
Linux diamonds 2.6.32-24-generic-pae #38-Ubuntu SMP Mon Jul 5 10:54:21 
UTC 2010 i686 GNU/Linux
rich@diamonds:~$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 10.04.1 LTS
Release:        10.04
Codename:       lucid

