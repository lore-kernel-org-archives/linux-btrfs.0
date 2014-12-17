Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 189-19-234-109.dsl.telesp.net.br ([189.19.234.109]:42508 "EHLO
	anthem.async.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750932AbaLQB0b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 20:26:31 -0500
Received: from anthem.async.com.br (kiko@localhost [127.0.0.1])
	by anthem.async.com.br (8.14.4/8.14.4/Debian-2ubuntu2.1) with ESMTP id sBH1FcfZ001655
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 23:15:38 -0200
Received: (from kiko@localhost)
	by anthem.async.com.br (8.14.4/8.14.4/Submit) id sBH1Fb2p001654
	for linux-btrfs@vger.kernel.org; Tue, 16 Dec 2014 23:15:37 -0200
Date: Tue, 16 Dec 2014 23:15:37 -0200
From: Christian Robottom Reis <kiko@async.com.br>
To: linux-btrfs@vger.kernel.org
Subject: Quota limit question
Message-ID: <20141217011537.GA1114@anthem.async.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello there,

    I'm trying out btrfs on a machine we use to host a number of
containers. After a misbehaved process filled the partition allocated to
the containers, I decided to experiment with quotas to isolate the
containers from each other. But I've now run into an oddity with one of
the containers, which reports being out of space:

    # btrfs qgroup limit 2000m 0/261 . && touch x
    touch: cannot touch ‘x’: Disk quota exceeded

The strange thing is that it doesn't seem to be actually out of space:

    # btrfs qgroup show -p -r -e /var | grep 261
    0/261    1111810048  391114752   2097152000  0          ---   

which pretty-printed is 1.04G rfer and 0.36G excl (perhaps the qgroup
show command could take an option to display in other units?)

I can only get it to allow me to start using it again if I go over 5808M:

    # btrfs qgroup limit 5807m 0/261 . && rm -f x && touch x
    rm: cannot remove ‘x’: Disk quota exceeded
    # btrfs qgroup limit 5808m 0/261 . && rm -f x && touch x
    #

Why specifically 5808 I'm not sure, but I binary searched until I got to
that number. Does anyone have a clue as to why that might be happening,
and perhaps what I'm missing?

For completeness, some details on the filesystem and system:

    # btrfs fi show /var
    Label: var  uuid: 815b3280-e90f-483a-b244-1d2dfe9b6e67
            Total devices 2 FS bytes used 31.48GiB
            devid    1 size 80.00GiB used 55.91GiB path /dev/sda3
            devid    2 size 80.00GiB used 55.91GiB path /dev/sdb3

    root@riff:/var/lib/lxc/async-local-machine-2/rootfs# btrfs fi df /var
    Data, RAID1: total=53.88GiB, used=30.45GiB
    System, RAID1: total=32.00MiB, used=16.00KiB
    Metadata, RAID1: total=2.00GiB, used=1.03GiB

    # btrfs qgroup show -p -r -e /var
    qgroupid rfer        excl        max_rfer    max_excl   parent  
    -------- ----        ----        --------    --------   ------  
    0/5      1486852096  1252569088  0           0          ---     
    0/259    727175168   104947712   0           5368709120 ---     
    0/261    1111810048  391114752   2097152000  0          ---   
    0/265    1255923712  442871808   0           5368709120 ---     
    0/271    831856640   333189120   0           5368709120 ---     
    0/274    498761728   22827008    0           5368709120 ---     
    0/283    7666098176  6691426304  10737418240 0          ---     
    0/288    1118441472  348901376   0           5368709120 ---     
    0/289    11134029824 10498187264 16106127360 0          ---     
    0/290    1412505600  694210560   10737418240 0          ---     
    0/292    1131053056  333373440   0           5368709120 ---     
    0/293    1258176512  401141760   0           5368709120 ---     
    0/306    1430532096  656773120   0           5368709120 ---     
    0/318    9309212672  8509857792  10737418240 0          ---     
    0/320    860209152   837406720   0           5368709120 ---     
    0/323    1167962112  469741568   0           5368709120 ---     

    # btrfs --version
    Btrfs v3.12

    # uname -a
    Linux riff 3.13.0-43-generic #72-Ubuntu SMP Mon Dec 8 19:35:06 UTC 2014
    x86_64 x86_64 x86_64 GNU/Linux

Thanks,
-- 
Christian Robottom Reis | [+55 16] 3376 0125   | http://async.com.br/~kiko
Async Open Source       | [+55 16] 9 9112 6430 | http://launchpad.net/~kiko
