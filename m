Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:44775 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab2EVRRS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 May 2012 13:17:18 -0400
Message-ID: <4FBBCA21.9080504@libero.it>
Date: Tue, 22 May 2012 19:17:21 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Christian Robert <christian.robert@polymtl.ca>
Subject: Which is the maximum files size in BTRFS ? [was Re: btrfs: Probably
 the larger filesystem I will see for a long time]
References: <4FB70D80.4030300@polymtl.ca>
In-Reply-To: <4FB70D80.4030300@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

>From the specification [1] the btrfs maximum file size limit should be
1<<64 bytes. However I was never able to create a file >= 1<<63 bytes.


ghigo@venice:/mnt/old-btrfs/home/ghigo/gianfile$ ls -l giantfile2
-rw-r--r-- 1 ghigo ghigo 9223372036854775807 May 22 18:55 giantfile2
ghigo@venice:/mnt/old-btrfs/home/ghigo/gianfile$ ls -lh giantfile2
-rw-r--r-- 1 ghigo ghigo 8.0E May 22 18:55 giantfile2
ghigo@venice:/mnt/old-btrfs/home/ghigo/gianfile$ echo -n x >>giantfile2
bash: echo: write error: File too large
ghigo@venice:/mnt/old-btrfs/home/ghigo/gianfile$ python -c "print 1<<63"
9223372036854775808

Could be a kernel limit ?

Goffredo

[1] https://btrfs.wiki.kernel.org/index.php/Main_Page

P.S.
I am asking about this un-useful question because I want to create a
loop based btrfs filesystem on a file greater than 8E. But I was unable
to create a such big file. I got success up to 8E-1



On 05/19/2012 05:03 AM, Christian Robert wrote:
> Probably the larger filesystem I will ever see. Tryed 8 Exabytes but it
> failed.
> 
> [root@CentOS6-A:/root] # df
> Filesystem                    1K-blocks      Used         Available 
> Use%  Mounted
> /dev/mapper/vg01-root          17915884  11533392           5513572  
> 68%  /
> /dev/sda1                        508745    140314            342831  
> 30%  /boot
> /dev/mapper/data_0             66993872   1644372          61994060   
> 3%  /mnt/data_0
> /dev/mapper/data_1     7881299347898368    508360  7881248224091896   
> 1%  /mnt/data_1
> 
> [root@CentOS6-A:/root] # df -h
> Filesystem             Size  Used  Avail  Use%  Mounted
> /dev/mapper/vg01-root   18G   11G   5.3G   68%  /
> /dev/sda1              497M  138M   335M   30%  /boot
> /dev/mapper/data_0      64G  1.6G    60G    3%  /mnt/data_0
> /dev/mapper/data_1     7.0E  497M   7.0E    1%  /mnt/data_1
> 
> [root@CentOS6-A:/root] # df -Th
> Filesystem              Type  Size  Used  Avail  Use%
> /dev/mapper/vg01-root   ext4   18G   11G   5.3G  68%
> /dev/sda1               ext4  497M  138M   335M  30%
> /dev/mapper/data_0      ext4   64G  1.6G    60G  3%
> /dev/mapper/data_1     btrfs  7.0E  499M   7.0E  1%
> [root@CentOS6-A:/root] #
> 
> 
> [root@CentOS6-A:/root] # uname -rv
> 3.4.0-rc7+ #23 SMP Wed May 16 20:20:47 EDT 2012
> 
> 
> made with a dm-thin device sitting on a device pair composed of
> (metadata 256Megs and data 23 Gigs)
> 
> running on my laptop at home.
> 
> yes, this is 7 Exabytes or 7,168 Petabytes or ( 7,340,032 Terabytes ) or
> 7,516,192,768 Gigabytes.
> 
> 
> please do not answer, it is just a statement of a fact at 3.4-rc7 (was
> not working at 3.4-rc3 if I remember).
> 
> 
> Xtian.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

