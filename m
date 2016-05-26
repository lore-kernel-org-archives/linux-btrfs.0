Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:34676 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbcEZRzS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 13:55:18 -0400
Received: by mail-ig0-f193.google.com with SMTP id b4so2510713igl.1
        for <linux-btrfs@vger.kernel.org>; Thu, 26 May 2016 10:55:17 -0700 (PDT)
Received: from whitehead.beowulf.uwo.ca ([2620:123:7001:1:76d4:35ff:fee4:a114])
        by smtp.gmail.com with ESMTPSA id s1sm1399576igh.19.2016.05.26.10.55.16
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Thu, 26 May 2016 10:55:16 -0700 (PDT)
From: Tyson Whitehead <twhitehead@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Scrub aborts on newer kernels
Date: Thu, 26 May 2016 13:55:16 -0400
Message-ID: <1970914.zjZ5YKPDft@whitehead.beowulf.uwo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Under the last several kernels versions (4.6 and I believe 4.4 and, 4.5) btrfs scrub aborts before completing.

If I boot back into an older kernel (4.1 or 4.3, not sure about 4.2) then it runs to completion without any issues.

Steps to reproduce:

1 - make a raid1 system
2 - run with only one disk for awhile to introduce inconsistency
3 - add the other disk back and run btrfs scrub

The newer kernels will get part way through the scrub and then die.  For example, with 4.6

# btrfs scrub status -dR /
scrub status for 61267e7b-e8e3-43e1-99f3-40cb2b004a6a
scrub device /dev/sda3 (id 1) history
        scrub started at Thu May 26 10:59:31 2016 and was aborted after 00:02:23
        data_extents_scrubbed: 256140
        tree_extents_scrubbed: 35016
        data_bytes_scrubbed: 14865694720
        tree_bytes_scrubbed: 573702144
        read_errors: 0
        csum_errors: 0
        verify_errors: 0
        no_csum: 2032
        csum_discards: 0
        super_errors: 0
        malloc_errors: 0
        uncorrectable_errors: 0
        unverified_errors: 0
        corrected_errors: 0
        last_physical: 16004874240
scrub device /dev/sdb3 (id 2) history
        scrub started at Thu May 26 10:59:31 2016 and was aborted after 00:02:35
        data_extents_scrubbed: 256139
        tree_extents_scrubbed: 35016
        data_bytes_scrubbed: 14865690624
        tree_bytes_scrubbed: 573702144
        read_errors: 0
        csum_errors: 205
        verify_errors: 24
        no_csum: 2032
        csum_discards: 0
        super_errors: 0
        malloc_errors: 0
        uncorrectable_errors: 0
        unverified_errors: 0
        corrected_errors: 229
        last_physical: 15984951296

The kernel logs show nothing other than the standard "no csum found for inode ..." and "parent transid verify failed ..." messages

Then booting back into 4.3 and rerunning the scrub.

# btrfs scrub start -BdR /
scrub device /dev/sda3 (id 1) done
        scrub started at Thu May 26 11:43:00 2016 and finished after 00:56:25
        data_extents_scrubbed: 6939254
        tree_extents_scrubbed: 68269
        data_bytes_scrubbed: 426809974784
        tree_bytes_scrubbed: 1118519296
        read_errors: 0
        csum_errors: 0
        verify_errors: 0
        no_csum: 62895
        csum_discards: 0
        super_errors: 0
        malloc_errors: 0
        uncorrectable_errors: 0
        unverified_errors: 0
        corrected_errors: 0
        last_physical: 482390048768
scrub device /dev/sdb3 (id 2) done
        scrub started at Thu May 26 11:43:00 2016 and finished after 00:58:41
        data_extents_scrubbed: 6939240
        tree_extents_scrubbed: 68118                                                                                             
        data_bytes_scrubbed: 426809335808                                                                                        
        tree_bytes_scrubbed: 1116045312                                                                                          
        read_errors: 0                                                                                                           
        csum_errors: 1051510                                                                                                     
        verify_errors: 0                                                                                                         
        no_csum: 62767                                                                                                           
        csum_discards: 0                                                                                                         
        super_errors: 0                                                                                                          
        malloc_errors: 0                                                                                                         
        uncorrectable_errors: 0                                                                                                  
        unverified_errors: 0                                                                                                     
        corrected_errors: 1051510                                                                                                
        last_physical: 482390048768                                                                                              
WARNING: errors detected during scrubbing, corrected                                                                             

Cheers!  -Tyson

PS:  This is with version 4.4 of the btrfs progs and Debian kernel release 4.1, 4.3, 4.4, 4.5, and 4.6.

-- 
 Tyson Whitehead
 HPC Programming Specialist
 Compute Canada (SHARCNET)
