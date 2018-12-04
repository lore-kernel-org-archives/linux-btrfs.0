Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D04C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 09:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA8832082B
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 09:58:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA8832082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=duckstad.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbeLDJ6y convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 04:58:54 -0500
Received: from smtp-out1.caiw.net ([62.45.45.125]:48800 "EHLO
        smtp-out1.caiw.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbeLDJ6y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Dec 2018 04:58:54 -0500
Received: from barracuda-out-1.caiw.net (barracuda-out.caiw.net [62.45.59.17])
        by smtp-out1.caiw.net (Postfix) with ESMTP id A75F640A09
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Dec 2018 10:58:51 +0100 (CET)
X-ASG-Debug-ID: 1543917530-08d68a765ba76e0001-6jHSXT
Received: from smtp-out2.caiw.net (smtp-out2.caiw.net [62.45.45.126]) by barracuda-out-1.caiw.net with ESMTP id mRMjVuDOGhKoraUv; Tue, 04 Dec 2018 10:58:50 +0100 (CET)
X-Barracuda-Envelope-From: bolderbast@duckstad.net
X-Barracuda-RBL-Trusted-Forwarder: 62.45.45.126
Received: from katrien.duckstad.net (200-228-045-062.dynamic.caiway.nl [62.45.228.200])
        by smtp-out2.caiw.net (Postfix) with ESMTP id 8EAF6C0021;
        Tue,  4 Dec 2018 10:58:50 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by katrien.duckstad.net (Postfix) with ESMTP id 7F3D43802F;
        Tue,  4 Dec 2018 10:58:50 +0100 (CET)
X-Barracuda-RBL-IP: 62.45.228.200
X-Barracuda-Effective-Source-IP: 200-228-045-062.dynamic.caiway.nl[62.45.228.200]
X-Barracuda-Apparent-Source-IP: 62.45.228.200
Received: from katrien.duckstad.net ([127.0.0.1])
        by localhost (katrien.duckstad.net [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 1u0yzQB2w4fS; Tue,  4 Dec 2018 10:58:48 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by katrien.duckstad.net (Postfix) with ESMTP id 84C9D38030;
        Tue,  4 Dec 2018 10:58:48 +0100 (CET)
X-Virus-Scanned: amavisd-new at katrien.duckstad.net
Received: from katrien.duckstad.net ([127.0.0.1])
        by localhost (katrien.duckstad.net [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Xkbr08oZx9sl; Tue,  4 Dec 2018 10:58:48 +0100 (CET)
Received: from bolderbast (unknown [10.4.2.1])
        by katrien.duckstad.net (Postfix) with ESMTPSA id C77783802F;
        Tue,  4 Dec 2018 10:58:47 +0100 (CET)
Message-ID: <10cf1cd081ef7ea933af84d061363f68954edb0e.camel@duckstad.net>
Subject: Re: Need help with potential ~45TB dataloss
From:   Patrick Dijkgraaf <bolderbast@duckstad.net>
X-ASG-Orig-Subj: Re: Need help with potential ~45TB dataloss
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Date:   Tue, 04 Dec 2018 10:58:47 +0100
In-Reply-To: <19cde2a5-6a07-4c14-6e84-9496f91422d7@gmx.com>
References: <8bc37755da04dffae1a34cea2a06bcffdf2c75d7.camel@duckstad.net>
         <6ce9cd01-960f-af3d-0273-0b9abfa1d4f8@gmx.com>
         <c723ab8e8e99e54c6f93dc70f897725525f0db29.camel@duckstad.net>
         <19cde2a5-6a07-4c14-6e84-9496f91422d7@gmx.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-Barracuda-Connect: smtp-out2.caiw.net[62.45.45.126]
X-Barracuda-Start-Time: 1543917530
X-Barracuda-URL: https://62.45.59.17:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at caiw.net
X-Barracuda-Scan-Msg-Size: 13609
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.5000 1.0000 0.0100
X-Barracuda-Spam-Score: 0.51
X-Barracuda-Spam-Status: No, SCORE=0.51 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=7.0 KILL_LEVEL=1000.0 tests=BSF_RULE7568M
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.63027
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
        0.50 BSF_RULE7568M          Custom Rule 7568M
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi, thanks again.
Please see answers inline.

-- 
Groet / Cheers,
Patrick Dijkgraaf



On Mon, 2018-12-03 at 08:35 +0800, Qu Wenruo wrote:
> 
> On 2018/12/2 下午5:03, Patrick Dijkgraaf wrote:
> > Hi Qu,
> > 
> > Thanks for helping me!
> > 
> > Please see the reponses in-line.
> > Any suggestions based on this?
> > 
> > Thanks!
> > 
> > 
> > On Sat, 2018-12-01 at 07:57 +0800, Qu Wenruo wrote:
> > > On 2018/11/30 下午9:53, Patrick Dijkgraaf wrote:
> > > > Hi all,
> > > > 
> > > > I have been a happy BTRFS user for quite some time. But now I'm
> > > > facing
> > > > a potential ~45TB dataloss... :-(
> > > > I hope someone can help!
> > > > 
> > > > I have Server A and Server B. Both having a 20-devices BTRFS
> > > > RAID6
> > > > filesystem. Because of known RAID5/6 risks, Server B was a
> > > > backup
> > > > of
> > > > Server A.
> > > > After applying updates to server B and reboot, the FS would not
> > > > mount
> > > > anymore. Because it was "just" a backup. I decided to recreate
> > > > the
> > > > FS
> > > > and perform a new backup. Later, I discovered that the FS was
> > > > not
> > > > broken, but I faced this issue: 
> > > > https://patchwork.kernel.org/patch/10694997/
> > > > 
> > > > 
> > > 
> > > Sorry for the inconvenience.
> > > 
> > > I didn't realize the max_chunk_size limit isn't reliable at that
> > > timing.
> > 
> > No problem, I should not have jumped to the conclusion to recreate
> > the
> > backup volume.
> > 
> > > > Anyway, the FS was already recreated, so I needed to do a new
> > > > backup.
> > > > During the backup (using rsync -vah), Server A (the source)
> > > > encountered
> > > > an I/O error and my rsync failed. In an attempt to "quick fix"
> > > > the
> > > > issue, I rebooted Server A after which the FS would not mount
> > > > anymore.
> > > 
> > > Did you have any dmesg about that IO error?
> > 
> > Yes there was. But I omitted capturing it... The system is now
> > rebooted
> > and I can't retrieve it anymore. :-(
> > 
> > > And how is the reboot scheduled? Forced power off or normal
> > > reboot
> > > command?
> > 
> > The system was rebooted using a normal reboot command.
> 
> Then the problem is pretty serious.
> 
> Possibly already corrupted before.
> 
> > > > I documented what I have tried, below. I have not yet tried
> > > > anything
> > > > except what is shown, because I am afraid of causing more harm
> > > > to
> > > > the FS.
> > > 
> > > Pretty clever, no btrfs check --repair is a pretty good move.
> > > 
> > > > I hope somebody here can give me advice on how to (hopefully)
> > > > retrieve my data...
> > > > 
> > > > Thanks in advance!
> > > > 
> > > > ==========================================
> > > > 
> > > > [root@cornelis ~]# btrfs fi show
> > > > Label: 'cornelis-btrfs'  uuid: ac643516-670e-40f3-aa4c-
> > > > f329fc3795fd
> > > > 	Total devices 1 FS bytes used 463.92GiB
> > > > 	devid    1 size 800.00GiB used 493.02GiB path
> > > > /dev/mapper/cornelis-cornelis--btrfs
> > > > 
> > > > Label: 'data'  uuid: 4c66fa8b-8fc6-4bba-9d83-02a2a1d69ad5
> > > > 	Total devices 20 FS bytes used 44.85TiB
> > > > 	devid    1 size 3.64TiB used 3.64TiB path /dev/sdn2
> > > > 	devid    2 size 3.64TiB used 3.64TiB path /dev/sdp2
> > > > 	devid    3 size 3.64TiB used 3.64TiB path /dev/sdu2
> > > > 	devid    4 size 3.64TiB used 3.64TiB path /dev/sdx2
> > > > 	devid    5 size 3.64TiB used 3.64TiB path /dev/sdh2
> > > > 	devid    6 size 3.64TiB used 3.64TiB path /dev/sdg2
> > > > 	devid    7 size 3.64TiB used 3.64TiB path /dev/sdm2
> > > > 	devid    8 size 3.64TiB used 3.64TiB path /dev/sdw2
> > > > 	devid    9 size 3.64TiB used 3.64TiB path /dev/sdj2
> > > > 	devid   10 size 3.64TiB used 3.64TiB path /dev/sdt2
> > > > 	devid   11 size 3.64TiB used 3.64TiB path /dev/sdk2
> > > > 	devid   12 size 3.64TiB used 3.64TiB path /dev/sdq2
> > > > 	devid   13 size 3.64TiB used 3.64TiB path /dev/sds2
> > > > 	devid   14 size 3.64TiB used 3.64TiB path /dev/sdf2
> > > > 	devid   15 size 7.28TiB used 588.80GiB path /dev/sdr2
> > > > 	devid   16 size 7.28TiB used 588.80GiB path /dev/sdo2
> > > > 	devid   17 size 7.28TiB used 588.80GiB path /dev/sdv2
> > > > 	devid   18 size 7.28TiB used 588.80GiB path /dev/sdi2
> > > > 	devid   19 size 7.28TiB used 588.80GiB path /dev/sdl2
> > > > 	devid   20 size 7.28TiB used 588.80GiB path /dev/sde2
> > > > 
> > > > [root@cornelis ~]# mount /dev/sdn2 /mnt/data
> > > > mount: /mnt/data: wrong fs type, bad option, bad superblock on
> > > > /dev/sdn2, missing codepage or helper program, or other error.
> > > 
> > > What is the dmesg of the mount failure?
> > 
> > [Sun Dec  2 09:41:08 2018] BTRFS info (device sdn2): disk space
> > caching
> > is enabled
> > [Sun Dec  2 09:41:08 2018] BTRFS info (device sdn2): has skinny
> > extents
> > [Sun Dec  2 09:41:08 2018] BTRFS error (device sdn2): parent
> > transid
> > verify failed on 46451963543552 wanted 114401 found 114173
> > [Sun Dec  2 09:41:08 2018] BTRFS critical (device sdn2): corrupt
> > leaf:
> > root=2 block=46451963543552 slot=0, unexpected item end, have
> > 1387359977 expect 16283
> 
> OK, this shows that one of the copy has mismatched generation while
> the
> other copy is completely corrupted.
> 
> > [Sun Dec  2 09:41:08 2018] BTRFS warning (device sdn2): failed to
> > read
> > tree root
> > [Sun Dec  2 09:41:08 2018] BTRFS error (device sdn2): open_ctree
> > failed
> > 
> > > And have you tried -o ro,degraded ?
> > 
> > Tried it just now, gives the exact same error.
> > 
> > > > [root@cornelis ~]# btrfs check /dev/sdn2
> > > > Opening filesystem to check...
> > > > parent transid verify failed on 46451963543552 wanted 114401
> > > > found
> > > > 114173
> > > > parent transid verify failed on 46451963543552 wanted 114401
> > > > found
> > > > 114173
> > > > checksum verify failed on 46451963543552 found A8F2A769 wanted
> > > > 4C111ADF
> > > > checksum verify failed on 46451963543552 found 32153BE8 wanted
> > > > 8B07ABE4
> > > > checksum verify failed on 46451963543552 found 32153BE8 wanted
> > > > 8B07ABE4
> > > > bad tree block 46451963543552, bytenr mismatch,
> > > > want=46451963543552,
> > > > have=75208089814272
> > > > Couldn't read tree root
> > > 
> > > Would you please also paste the output of "btrfs ins dump-super
> > > /dev/sdn2" ?
> > 
> > [root@cornelis ~]# btrfs ins dump-super /dev/sdn2
> > superblock: bytenr=65536, device=/dev/sdn2
> > ---------------------------------------------------------
> > csum_type		0 (crc32c)
> > csum_size		4
> > csum			0x51725c39 [match]
> > bytenr			65536
> > flags			0x1
> > 			( WRITTEN )
> > magic			_BHRfS_M [match]
> > fsid			4c66fa8b-8fc6-4bba-9d83-02a2a1d69ad5
> > label			data
> > generation		114401
> > root			46451963543552
> 
> The bytenr matches with the dmesg, so it's tree root node corrupted.
> 
> > sys_array_size		513
> > chunk_root_generation	112769
> > root_level		1
> > chunk_root		22085632
> > chunk_root_level	1
> > log_root		46451935461376
> > log_root_transid	0
> > log_root_level		0
> > total_bytes		104020314161152
> > bytes_used		49308554543104
> > sectorsize		4096
> > nodesize		16384
> > leafsize (deprecated)		16384
> > stripesize		4096
> > root_dir		6
> > num_devices		20
> > compat_flags		0x0
> > compat_ro_flags		0x0
> > incompat_flags		0x1e1
> > 			( MIXED_BACKREF |
> > 			  BIG_METADATA |
> > 			  EXTENDED_IREF |
> > 			  RAID56 |
> > 			  SKINNY_METADATA )
> > cache_generation	114401
> > uuid_tree_generation	114401
> > dev_item.uuid		c6b44903-e849-4403-98c4-f3ba4d0b3fc3
> > dev_item.fsid		4c66fa8b-8fc6-4bba-9d83-02a2a1d69ad5
> > [match]
> > dev_item.type		0
> > dev_item.total_bytes	4000783007744
> > dev_item.bytes_used	4000781959168
> > dev_item.io_align	4096
> > dev_item.io_width	4096
> > dev_item.sector_size	4096
> > dev_item.devid		1
> > dev_item.dev_group	0
> > dev_item.seek_speed	0
> > dev_item.bandwidth	0
> > dev_item.generation	0
> > 
> > > It looks like your tree root (or at least some tree root
> > > nodes/leaves
> > > get corrupted)
> > > 
> > > > ERROR: cannot open file system
> > > 
> > > And since it's your tree root corrupted, you could also try
> > > "btrfs-find-root <device>" to try to get a good old copy of your
> > > tree
> > > root.
> > 
> > The output is rather long. I pasted it here: 
> > https://pastebin.com/FkyBLgj9
> > 
> > I'm unsure what to look for in this output?
> 
> This shows all the candidates of the older tree root bytenr.
> 
> We could use it to try to recover.
> 
> You could then try the following command and see if btrfs check can
> go
> further.
> 
>  # btrfs check -r 45462239363072 <device>

This gives the following output (remember, I removed the disk that
caused the IO errors, so the RAID is still degraded):

[root@cornelis ~]# btrfs check -r 45462239363072 /dev/sdn2
Opening filesystem to check...
warning, device 6 is missing
checksum verify failed on 22544384 found ED96FBF2 wanted 09754644
checksum verify failed on 22544384 found 5630EA32 wanted 1AA6FFF0
checksum verify failed on 22544384 found 5630EA32 wanted 1AA6FFF0
bad tree block 22544384, bytenr mismatch, want=22544384,
have=1147797504
Couldn't read chunk tree
ERROR: cannot open file system


> And the following dump could also help:
> 
>  # btrfs ins dump-tree -b 45462239363072 --follow

This outputs:

[root@cornelis ~]# btrfs ins dump-tree -b 45462239363072 --follow
/dev/sdn2
btrfs-progs v4.19 
warning, device 6 is missing
checksum verify failed on 22544384 found ED96FBF2 wanted 09754644
checksum verify failed on 22544384 found 5630EA32 wanted 1AA6FFF0
checksum verify failed on 22544384 found 5630EA32 wanted 1AA6FFF0
bad tree block 22544384, bytenr mismatch, want=22544384,
have=1147797504
Couldn't read chunk tree
ERROR: unable to open /dev/sdn2

> Thanks,
> Qu
> 
> > > But I suspect the corruption happens before you noticed, thus the
> > > old
> > > tree root may not help much.
> > > 
> > > Also, the output of "btrfs ins dump-tree -t root <device>" will
> > > help.
> > 
> > Here it is:
> > 
> > [root@cornelis ~]# btrfs ins dump-tree -t root /dev/sdn2
> > btrfs-progs v4.19 
> > parent transid verify failed on 46451963543552 wanted 114401 found
> > 114173
> > parent transid verify failed on 46451963543552 wanted 114401 found
> > 114173
> > checksum verify failed on 46451963543552 found A8F2A769 wanted
> > 4C111ADF
> > checksum verify failed on 46451963543552 found 32153BE8 wanted
> > 8B07ABE4
> > checksum verify failed on 46451963543552 found 32153BE8 wanted
> > 8B07ABE4
> > bad tree block 46451963543552, bytenr mismatch,
> > want=46451963543552,
> > have=75208089814272
> > Couldn't read tree root
> > ERROR: unable to open /dev/sdn2
> > 
> > > Thanks,
> > > Qu
> > 
> > No, thank YOU! :-)
> > 
> > > > [root@cornelis ~]# btrfs restore /dev/sdn2 /mnt/data/
> > > > parent transid verify failed on 46451963543552 wanted 114401
> > > > found
> > > > 114173
> > > > parent transid verify failed on 46451963543552 wanted 114401
> > > > found
> > > > 114173
> > > > checksum verify failed on 46451963543552 found A8F2A769 wanted
> > > > 4C111ADF
> > > > checksum verify failed on 46451963543552 found 32153BE8 wanted
> > > > 8B07ABE4
> > > > checksum verify failed on 46451963543552 found 32153BE8 wanted
> > > > 8B07ABE4
> > > > bad tree block 46451963543552, bytenr mismatch,
> > > > want=46451963543552,
> > > > have=75208089814272
> > > > Couldn't read tree root
> > > > Could not open root, trying backup super
> > > > warning, device 14 is missing
> > > > warning, device 13 is missing
> > > > warning, device 12 is missing
> > > > warning, device 11 is missing
> > > > warning, device 10 is missing
> > > > warning, device 9 is missing
> > > > warning, device 8 is missing
> > > > warning, device 7 is missing
> > > > warning, device 6 is missing
> > > > warning, device 5 is missing
> > > > warning, device 4 is missing
> > > > warning, device 3 is missing
> > > > warning, device 2 is missing
> > > > checksum verify failed on 22085632 found 5630EA32 wanted
> > > > 1AA6FFF0
> > > > checksum verify failed on 22085632 found 5630EA32 wanted
> > > > 1AA6FFF0
> > > > bad tree block 22085632, bytenr mismatch, want=22085632,
> > > > have=1147797504
> > > > ERROR: cannot read chunk root
> > > > Could not open root, trying backup super
> > > > warning, device 14 is missing
> > > > warning, device 13 is missing
> > > > warning, device 12 is missing
> > > > warning, device 11 is missing
> > > > warning, device 10 is missing
> > > > warning, device 9 is missing
> > > > warning, device 8 is missing
> > > > warning, device 7 is missing
> > > > warning, device 6 is missing
> > > > warning, device 5 is missing
> > > > warning, device 4 is missing
> > > > warning, device 3 is missing
> > > > warning, device 2 is missing
> > > > checksum verify failed on 22085632 found 5630EA32 wanted
> > > > 1AA6FFF0
> > > > checksum verify failed on 22085632 found 5630EA32 wanted
> > > > 1AA6FFF0
> > > > bad tree block 22085632, bytenr mismatch, want=22085632,
> > > > have=1147797504
> > > > ERROR: cannot read chunk root
> > > > Could not open root, trying backup super
> > > > 
> > > > [root@cornelis ~]# uname -r
> > > > 4.18.16-arch1-1-ARCH
> > > > 
> > > > [root@cornelis ~]# btrfs --version
> > > > btrfs-progs v4.19
> > > > 
> 
> 

