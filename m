Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59565 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758257AbaJaMKr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 08:10:47 -0400
Received: by mail-pa0-f50.google.com with SMTP id eu11so7673613pac.9
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Oct 2014 05:10:47 -0700 (PDT)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: request for info on the list of parameters to tweak for PCIe SSDs
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <6891C2FAE3B0F342A5B80AFBDCFB579713AACD334A@BLRX7MCDC204.AMER.DELL.COM>
Date: Fri, 31 Oct 2014 20:10:32 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <18D94FDC-34F7-405E-A35D-AE1A3C993E90@gmail.com>
References: <6891C2FAE3B0F342A5B80AFBDCFB579713AACD334A@BLRX7MCDC204.AMER.DELL.COM>
To: Lakshmi_Narayanan_Du@Dell.com
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Lakshmi,

Personally, i haven¡¯t done many benchmarks about performance tuning, but
there are some info you could refer to:

If you feel intrested, you could take a look at following url which offers btrfs mount options:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/filesystems/btrfs.txt

And for Wiki, there are many information which might help you:
https://btrfs.wiki.kernel.org/index.php/Main_Page

There are also some options that you could tune for mkfs, see detailed info
by ¡®man mkfs.btrfs¡¯.I supposed for example different ¡¯nodesize/leafsize¡¯ 
will have effects for performance. Also there are some new features Btrfs,
like skinny_metadata, no_holes etc, you could clone a Latest btrfs-progs tools from:
http://git.kernel.org/cgit/linux/kernel/git/kdave/btrfs-progs.git/

Some features are not enabled by default(skinny_medata,no_holes etc),
but for benchmarking, you could turn on them and using latest kernel with latest btrfs-progs:

root@localhost autotest]# mkfs.btrfs -O list-all
Filesystem features available at mkfs time:
mixed-bg            - mixed data and metadata block groups (0x4)
extref              - increased hardlink limit per file to 65536 (0x40, default)
raid56              - raid56 extended format (0x80)
skinny-metadata     - reduced-size metadata extent refs (0x100)
no-holes            - no explicit hole extents for files (0x200)

It will be good that you could do some benchmarks for Btrfs with different parameters, and feel
free to let others know your results(i am also curious).^_^

Best Regards,
Wang Shilong

> Hi,
> 
> Could you kindly help us with the list of all the btrfs  file system parameters , that can be tweaked for the best performance of the PCIe based SSDs ?
> 
> Thanks,
> Lakshmi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Best Regards,
Wang Shilong

