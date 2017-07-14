Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:34913 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbdGNGxL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 02:53:11 -0400
Received: by mail-it0-f49.google.com with SMTP id v202so13520674itb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 23:53:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170713164359.GE12913@lim.localdomain>
References: <CAK78SMnGpVx5dEOGnq75fSgfKnKbVr3FPEfAKecfVbHZ0F8+Uw@mail.gmail.com>
 <20170713164359.GE12913@lim.localdomain>
From: =?UTF-8?B?QWxla3NhbmRhciDEjGVrcmxpxIc=?= <pathlidge.ann@gmail.com>
Date: Fri, 14 Jul 2017 08:53:09 +0200
Message-ID: <CAK78SM=fmRexVaZtf3WArDirMc+joc8b=VCer=qLAFfmQ2Wp+A@mail.gmail.com>
Subject: Re: BTRFS file I/O with O_DIRECT
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,

indeed setting the address alignment and read chunk to 4k did the
trick, everything worked as expected. I expected in the case of the
wrong alignment read() would fail with errno == EINVAL like for some
other file systems, not to fallback to buffered read.

Thanks a lot for the help!

BR,
Aleksandar

On Thu, Jul 13, 2017 at 6:43 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Thu, Jul 13, 2017 at 04:16:44PM +0200, Aleksandar Čekrlić wrote:
>> Hi all,
>>
>> I am currently working on a file system related code where user can
>> opt to use direct I/O for file reads / writes. Code seems to be
>> working and operational, and on majority of the file systems I/O is
>> not using the page cache, but on BTRFS even though file is opened with
>> O_DIRECT file is cached, and subsequent reads are quite faster,
>> indicating that file read is not actually read from disk. I have
>> checked both with a separate binary (basically just open() with
>> O_DIRECT and read()) and with dd, and I get the same results.
>>
>> dd reading a 200 MB file:
>> =================================
>> [root@lepton btrfs_mail]# linux-fincore /btrfs/smallfiles/dfile
>> filename
>>                         size        total_pages    min_cached page
>>   cached_pages        cached_size        cached_perc
>> --------
>>                         ----        -----------    ---------------
>>   ------------        -----------        -----------
>> /btrfs/smallfiles/dfile
>>                  209,715,200             51,200                 -1
>>              0                  0               0.00
>> ---
>> total cached size: 0
>> [root@lepton btrfs_mail]# dd if=/btrfs/smallfiles/dfile iflag=direct
>> of=/dev/null
>> 409600+0 records in
>> 409600+0 records out
>> 209715200 bytes (210 MB) copied, 2.32787 s, 90.1 MB/s
>> [root@lepton btrfs_mail]# linux-fincore /btrfs/smallfiles/dfile
>> filename
>>                         size        total_pages    min_cached page
>>   cached_pages        cached_size        cached_perc
>> --------
>>                         ----        -----------    ---------------
>>   ------------        -----------        -----------
>> /btrfs/smallfiles/dfile
>>                  209,715,200             51,200                  0
>>         51,200        209,715,200             100.00
>> ---
>> total cached size: 209,715,200
>> [root@lepton btrfs_mail]# dd if=/btrfs/smallfiles/dfile iflag=direct
>> of=/dev/null
>> 409600+0 records in
>> 409600+0 records out
>> 209715200 bytes (210 MB) copied, 0.460326 s, 456 MB/s
>> =================================
>>
>> I know in case the file system does not support O_DIRECT it will
>> ignore it, but I thought BTRFS does support it, so I'm kinda confused
>> by the behaviour.
>>
>
> Btrfs does support O_DIRECT, it is using 4K as its direct IO alignment
> (at least on x86_64), so the above dd may just use 512 and btrfs dio
> read falls back to buffered read then.
>
> thank,
> -liubo
>
>> System information (dmesg.log is attached) :
>> =================================
>> uname -a:
>> Linux lepton 2.6.32-642.el6.x86_64 #1 SMP Wed Apr 13 00:51:26 EDT 2016
>> x86_64 x86_64 x86_64 GNU/Linux
>> =================================
>> btrfs --version
>> Btrfs Btrfs v0.20-rc1
>> =================================
>> btrfs fi show
>> failed to stat /dev/VxDMP2
>> failed to stat /dev/VxDMP2p1
>> failed to stat /dev/VxDMP2p2
>> failed to stat /dev/VxDMP3
>> failed to stat /dev/VxDMP3p3
>> failed to stat /dev/VxDMP3p8
>> failed to stat /dev/VxDMP4
>> failed to stat /dev/VxDMP4p1
>> failed to stat /dev/VxDMP4p2
>> failed to stat /dev/VxDMP4p3
>> failed to stat /dev/VxDMP5
>> failed to stat /dev/VxDMP5p1
>> failed to stat /dev/VxDMP5p2
>> failed to stat /dev/VxDMP5p3
>> failed to stat /dev/VxVM21000
>> Label: none  uuid: 903217cd-80e3-497e-8724-6e697d6c5d3e
>>         Total devices 1 FS bytes used 620.84MB
>>         devid    1 size 50.00GB used 6.04GB path /dev/cciss/c0d1p1
>>
>> Btrfs Btrfs v0.20-rc1
>> =================================
>> btrfs fi df /btrfs
>> Data: total=2.01GB, used=619.95MB
>> System, DUP: total=8.00MB, used=4.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, DUP: total=2.00GB, used=900.00KB
>> Metadata: total=8.00MB, used=0.00
>> =================================
>>
>> Thanks and best regards,
>> Aleksandar
>
>
