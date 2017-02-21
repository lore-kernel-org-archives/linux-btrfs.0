Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-03.prod.phx3.secureserver.net ([184.168.200.142]:38344
        "EHLO p3nlsmtpcp01-03.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751099AbdBUJYI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Feb 2017 04:24:08 -0500
Date: Tue, 21 Feb 2017 14:52:15 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Large no.of extents for a single small file with a fresh RAID5
 setup
Message-ID: <20170221092215.GA5217@giis.co.in>
References: <20170218020711.GA23608@giis.co.in>
 <678a9608-8f42-119c-7fd3-69fbae31bfab@cn.fujitsu.com>
 <20170220140737.GA27535@giis.co.in>
 <af2aba3e-467d-6546-e9a0-e8bcc460fbd2@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <af2aba3e-467d-6546-e9a0-e8bcc460fbd2@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> >>How did you create the 2m file?
> >
> >Yes,this is the problem. script invokes 'dd' with 'notrunc' for each
> >byte. If the file is 1kb, 'dd' invoked 1024 times with notrunc.
> >This seems to be creating the issue.
> 
> IIRC that's not the direct cause though.
> 
> Since kernel is using delayed allocation, each time we trigger buffered
> write, kernel just info fs to do accounting and copy the data into page
> cache, no real write is triggered.
> 
> Only sync/fsync and memory pressure will make us to write pages into disc,
> and until then we allocate space for them.
> 
> So unless you're trying such operation on a busy server which triggered
> several sync/fsync/memory pressure during the several seconds of dd, it
> won't cause so many fragments.
> 
> I also tried your dd bs=1 method, no problem and still one single extent.
> 
> Thanks,
> Qu
I'm using Ubuntu(16.04) desktop version (not server) running Xorg and others. May be its possible its
flushing data to disk at constant time. If you like to give it a try again with servers, below is the
exact script along with its timing & multiextent output.

one more curious thing, is it fine to have extents with size 4096 on RAID5 setup?

Cheers.
Lakshmipathi.G

#time /root/check_extents.sh f2MB 32
real	1m30.284s
user	1m22.796s
sys	0m39.324s

laks/btrfs-progs# ./btrfs-debugfs -f tests/mnt/f2MB
(263 0): ram 110592 disk 151015424 disk_size 114688
(263 110592): ram 4096 disk 147103744 disk_size 4096
(263 114688): ram 110592 disk 151130112 disk_size 114688
(263 225280): ram 696320 disk 151257088 disk_size 700416
(263 921600): ram 4096 disk 147107840 disk_size 4096
(263 925696): ram 700416 disk 152043520 disk_size 704512
(263 1626112): ram 4096 disk 147111936 disk_size 4096
(263 1630208): ram 344064 disk 153223168 disk_size 348160
(263 1974272): ram 4096 disk 147116032 disk_size 4096
(263 1978368): ram 118784 disk 152748032 disk_size 118784
file: tests/mnt/f2MB extents 10 disk size 2117632 logical size 2097152 ratio 0.99

--
$cat /root/check_extents.sh 
#!/bin/bash
#$1 Filename
#$2 Expected no.of data stripes for the file.

create_layout(){
        fname=$1
        size=$(( $2 * 65536 ))
        n=0
        bs_value=1
        stripe=0
        while (( $n < $size ))
        do
                if [ $(( $n % 65536 )) -eq 0 ]; then
                        val='D'$stripe
                        echo -n $val
                        stripe=$(( $stripe+1 ))
                        # ensure proper value           
                        bs_value=`echo "${#val}"` 
                else
                        echo -n 'x'
                        bs_value=1
                fi
        n=$(( $n+$bs_value ))
        done | dd of="/home/laks/btrfs-progs/tests/mnt/$fname" bs=$bs_value conv=notrunc &> /dev/null
	##EDIT above hard-coded path
}
create_layout $1 $2
--
