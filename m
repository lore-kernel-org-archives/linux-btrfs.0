Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33104 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726819AbeIMVBi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 17:01:38 -0400
Subject: Re: btrfs convert problem
To: Serhat Sevki Dincer <jfcgauss@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAPqC6xR1rbNqpPUUxU2OyvtCHoD2LOywE5cRDtNTbqJ2=5e_nQ@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e107e504-ee53-8879-23c2-9fc8cfe7c755@suse.com>
Date: Thu, 13 Sep 2018 18:51:27 +0300
MIME-Version: 1.0
In-Reply-To: <CAPqC6xR1rbNqpPUUxU2OyvtCHoD2LOywE5cRDtNTbqJ2=5e_nQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.09.2018 15:22, Serhat Sevki Dincer wrote:
> Hi,
> 
> I have an external usb HDD (WD my passport, just usb cable, no
> external power) with a single ext4 partition occupying the whole disk
> with 698 GiB capacity and 188 GiB empty space. The data on disk is not
> very important.
> 
> I also have a laptop with Manjaro 64-bit XFCE, kernel 4.14.68,
> btrfs-progs v4.17.1, all packages come with Manjaro.
> 
> I tried to convert my disk to btrfs with
> sudo btrfs-convert /dev/sdb1
> I have also tried -i, -n options, all failed with:
> 
> create btrfs filesystem:
>     blocksize: 4096
>     nodesize:  16384
>     features:  extref, skinny-metadata (default)
> creating ext2 image file
> ERROR: failed to create ext2_saved/image: -1

-1 seems to be EPERM, is your device write-protected, readonly or
something like that ?

> WARNING: an error occurred during conversion, filesystem is partially
> created but not finalized and not mountable
> 
> I could not find this error/warning combo on the net.
> ext4 partition seems intact and working after these attempts.
> How can I debug and complete this conversion?
> 
> Thanks..
> 
