Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33378 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751362AbeDFP6N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Apr 2018 11:58:13 -0400
Subject: Re: Bad magic on superblock on /dev/sda at 65536
To: Ben Parsons <9parsonsb@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAAGPGf9+y_BXj=jQ1aY3xSPzMTjOTWPPO2avBODSYem5pyRXGQ@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c0fd5e71-7daa-3301-a72d-c3075c8e453e@suse.com>
Date: Fri, 6 Apr 2018 18:58:10 +0300
MIME-Version: 1.0
In-Reply-To: <CAAGPGf9+y_BXj=jQ1aY3xSPzMTjOTWPPO2avBODSYem5pyRXGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  6.04.2018 16:32, Ben Parsons wrote:
> Hi,
> 
> I just had an unexpected restart and now my btrfs pool wont mount.
> The error on mount is:
> 
>     "ERROR: unsupported checksum algorithm 41700"
> 
> and when running
> 
>     btrfs inspect-internal dump-super /dev/sda
>     ERROR: bad magic on superblock on /dev/sda at 65536
> 
> I saw a thread in the mailing list about it:
> https://www.spinics.net/lists/linux-btrfs/msg75326.html
> However I am told on IRC that Qu fixed it using magic.
> 
> Any help would be much appreciated.

Try recovering the super block from one of the backup copies via
"btrfs rescue super-recover /dev/sda"

> 
> Thanks,
> Ben
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
