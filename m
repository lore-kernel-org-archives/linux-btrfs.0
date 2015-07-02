Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33457 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbbGBSy3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jul 2015 14:54:29 -0400
Received: by oiyy130 with SMTP id y130so62858890oiy.0
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2015 11:54:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC=t97Dc9hqQauXb8VqAua-ppZ5J33Ak+VKUtNUSEAct2=r+Lw@mail.gmail.com>
References: <CAC=t97D=Dmq3cu-z2PNjREQn5690+R9NBQsjr5KZ4grYnYr4WA@mail.gmail.com>
 <CAJCQCtSjxs2ZZUgUfrp9q5y+x0fFA7fSnQPgeEXTjsLKZ6DPKw@mail.gmail.com>
 <CAC=t97BiPjTf7yjWoSaoTgjvPZFgyEHdEJzFCG1Mu+nnJGoNoA@mail.gmail.com>
 <CAC=t97Bg3STrTn86HBNYJJm-FT7aiR6tc51tjVnPiArpPgd9XQ@mail.gmail.com>
 <CAC=t97CS5As+3SqZy-sHM4U2JZ0bi_AEq=34bNXu0yBmh8QRjg@mail.gmail.com>
 <CAC=t97AQaDTRinVg9crdAG8zaoj_--L_PLDY3M4_HKHZotnVVg@mail.gmail.com>
 <CAJCQCtRpRg=XdMtAerHfxCWXO74s34=b9LLuk9mvfRhKz8hjFQ@mail.gmail.com>
 <CAC=t97AERgJ06P_Q8vbz=-yC=H3ODUkTt7ZD1Zpimr_jft+S6g@mail.gmail.com>
 <CAJCQCtSB+29V-UdL5JZAHu3Zv3-XH0SyL8E5MwHgyeoVQ46Wvg@mail.gmail.com>
 <CAC=t97BOYQJAanPc_EFzxwwakFrY4ALd0sX-n9w_e9JHodU27Q@mail.gmail.com>
 <CAJCQCtTE2QKQij5ziq_wWM=M0bhVKcxAbWVGOPD=R_1ZkvqWPA@mail.gmail.com>
 <CAC=t97A4JtSzXpn9Yr3vhe6Z5JCfKEFB1GfwSLsfYPOWhZ+Zrw@mail.gmail.com>
 <CAJCQCtTPGDmbACtNpXgF-bFbbkLwuNMJyDzP72BsgOL=aREmWQ@mail.gmail.com>
 <CAC=t97BtoARcnda7aS0QBAerVgYb5z1boXAaJv6CEr9KTkj1ug@mail.gmail.com>
 <CAJCQCtRFdeOJFn_Ree1dRL04L5SHDOBL87QXZ0beidUhwJCLLQ@mail.gmail.com> <CAC=t97Dc9hqQauXb8VqAua-ppZ5J33Ak+VKUtNUSEAct2=r+Lw@mail.gmail.com>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Thu, 2 Jul 2015 13:54:08 -0500
Message-ID: <CAC=t97C8SfqyKTDv_mVTr6MR+ZpLqjmVMd3aFhC3SiRapig_qw@mail.gmail.com>
Subject: Re: Any hope of pool recovery?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes it works with raid6 as well.

[root@san01 btrfs-progs]# ./btrfs fi show
Label: 'rockstor_rockstor'  uuid: 08d14b6f-18df-4b1b-a91e-4b33e7c90c29
        Total devices 1 FS bytes used 19.25GiB
        devid    1 size 457.40GiB used 457.40GiB path /dev/sdt3

warning, device 4 is missing
warning, device 2 is missing
warning devid 2 not found already
warning devid 4 not found already
checksum verify failed on 21364736 found 925303CE wanted 09150E74
checksum verify failed on 21364736 found 925303CE wanted 09150E74
bytenr mismatch, want=21364736, have=1065943040
Couldn't read chunk tree
Label: 'backup'  uuid: 68be4632-93ba-4478-9098-2ecb23ee6c94
        Total devices 5 FS bytes used 978.72MiB
        devid    1 size 2.73TiB used 1.62GiB path /dev/sdb
        devid    3 size 2.73TiB used 1.62GiB path /dev/sdi
        devid    4 size 2.73TiB used 1.62GiB path /dev/sdj
        devid    5 size 2.73TiB used 1.62GiB path /dev/sdn
        devid    6 size 2.73TiB used 1.62GiB path /dev/sdq

Label: 'tank'  uuid: 8a03f8e8-8b84-4d1b-b27d-e23ef8ebe21d
        Total devices 10 FS bytes used 5.67TiB
        devid    1 size 1.36TiB used 792.67GiB path /dev/sdc
        devid    3 size 1.82TiB used 792.65GiB path /dev/sdf
        devid    5 size 1.36TiB used 792.65GiB path /dev/sdg
        devid    6 size 1.36TiB used 792.65GiB path /dev/sdh
        devid    7 size 1.82TiB used 792.65GiB path /dev/sdk
        devid    8 size 1.82TiB used 792.65GiB path /dev/sdl
        devid    9 size 1.82TiB used 792.65GiB path /dev/sdm
        devid   10 size 1.82TiB used 792.65GiB path /dev/sdp
        *** Some devices missing

btrfs-progs v4.1
[root@san01 btrfs-progs]# mount /dev/sdb /mnt2/backup
[root@san01 btrfs-progs]# ./btrfs fi df /mnt2/backup
Data, RAID6: total=3.00GiB, used=977.56MiB
System, RAID6: total=96.00MiB, used=16.00KiB
Metadata, RAID6: total=1.03GiB, used=1.14MiB
GlobalReserve, single: total=16.00MiB, used=0.00B
[root@san01 btrfs-progs]# ll /mnt2/backup
total 1000000
-rw-r--r-- 1 root root 1024000000 Jul  2 13:48 test_file_1gb
[root@san01 btrfs-progs]# umount /mnt2/backup
[root@san01 btrfs-progs]# ./btrfs restore -xmv /dev/sdb ~
Restoring /root/test_file_1gb
Done searching
[root@san01 btrfs-progs]# ll ~
total 1000004
-rw-------. 1 root root       1101 Jun 20 23:18 anaconda-ks.cfg
drwxr-xr-x  1 root root         22 Jul  1 09:48 git
-rw-r--r--  1 root root 1024000000 Jul  2 13:48 test_file_1gb
[root@san01 btrfs-progs]#

On Thu, Jul 2, 2015 at 1:45 PM, Donald Pearson
<donaldwhpearson@gmail.com> wrote:
> That is correct.  I'm going to rebalance my raid5 pool as raid6 and
> re-test just because.
>
> On Thu, Jul 2, 2015 at 1:37 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> On Thu, Jul 2, 2015 at 12:32 PM, Donald Pearson
>> <donaldwhpearson@gmail.com> wrote:
>>> I think it is.  I have another raid5 pool that I've created to test
>>> the restore function on, and it worked.
>>
>> So you have all devices for this raid6 available, and yet when you use
>> restore, you get missing device message for all devices except the one
>> specified? But that doesn't happen with the raid5 volume?
>>
>>
>> --
>> Chris Murphy
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
