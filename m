Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:47881 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786Ab3CVLfD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 07:35:03 -0400
Received: by mail-pb0-f51.google.com with SMTP id rr4so333626pbb.38
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2013 04:35:02 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Adding a non-empty subvol to a qgroup
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <514C33A2.9050709@oracle.com>
Date: Fri, 22 Mar 2013 19:27:55 +0800
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <55A719DF-A566-40BC-99A6-B55BA05E72A1@gmail.com>
References: <514C33A2.9050709@oracle.com>
To: Koen De Wit <koen.de.wit@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> All,
> 
> When adding a subvolume to a qgroup, pre-existing files in that subvolume are not counted in the referenced/exclusive space of the qgroup. Is this intended behavior ?

Btrfs quota rescan has not been implemented yet. So until now, the pre-existing files are not counted.

> 
> I create a subvol with one file:
> 
>  # mkfs.btrfs /dev/sdg
>  # mount /dev/sdg /mnt/fulldisk
>  # cd /mnt/fulldisk
>  # btrfs quota enable ./
>  # btrfs sub create sub1
>  # dd if=/dev/zero of=sub1/file1 bs=100000 count=1
>  # sync
>  # btrfs qgroup show ./
>  0/257 106496 106496
> 
> Now I create a new qgroup on level 1 and add the qgroup of sub1 to it :
> 
>  # btrfs qgroup create 1/0 ./
>  # btrfs qgroup assign 0/257 1/0 ./
>  # sync
>  # btrfs fi sync ./
>  # btrfs quota rescan ./
>  # btrfs quota rescan ./sub1
>  # btrfs qgroup show ./
>  0/257 106496 106496
>  1/0 0 0
> 
> The pre-existing file does not contribute to the space numbers.
> 
> Let's create a new file:
> 
>  # dd if=/dev/zero of=sub1/file2 bs=50000 count=1
>  # sync
>  # btrfs qgroup show ./
>  0/257 159744 159744
>  1/0 53248 53248
> 
> We see that only the new file is included in the space numbers.
> 
> Now I remove the first file:
> 
>  # rm -f sub1/file1
>  # sync
>  # btrfs qgroup show ./
>  0/257 57344 57344
>  1/0 -49152 -49152
> 
> The space numbers go below zero. Even if the behavior above is intended, the removal of the pre-existing file should not result in negative space numbers.


Since rescan has not been implemented, the above case can not be avoided. but the referenced/exclusive value should not be negative because 
the type for referenced/exclusive is u64.  

if the overflow  happens, we may get a positive integer which is also wrong.
The problems come in btrfs-progs, i will correct it. thanks 

Maybe, we should have a check in the kernel and give a warning if overflow happens. 

Thanks,
Wang

 
> 
> Koen.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

