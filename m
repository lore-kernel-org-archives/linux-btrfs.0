Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C67C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 12:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 271A8217D9
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 12:42:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=cam.ac.uk header.i=@cam.ac.uk header.b="Lw1EcaSF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbfBSMm1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 07:42:27 -0500
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:47214 "EHLO
        ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfBSMm0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 07:42:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cam.ac.uk;
         s=20180806.ppsw; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=evPUHOI53IhgZ5Cgf9U5FRADOrgsyf8kzi/Pqm/Vf9I=; b=Lw1EcaSFs1Iw83XZwC2uqiKNZu
        BDuu0mDTXAbJcPMI0kvYFOXJLwgWB/zqNypD4lEmgUQf4AjVX/zmnriWSMiF07NpMlvw860dewA1W
        Z4ltGTHXR6gitmFC9pIwIGUHy/2zCn8sckTm8xU1YNP3cTb4YJ6FcnjXzab7GTzjUOGs=;
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://help.uis.cam.ac.uk/email-scanner-virus
Received: from casxb.ast.cam.ac.uk ([131.111.68.80]:34810)
        by ppsw-32.csi.cam.ac.uk (ppsw.cam.ac.uk [131.111.8.138]:25)
        with esmtps (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        id 1gw4jB-000bZm-0v (Exim 4.91)
        (return-path <rmj@ast.cam.ac.uk>); Tue, 19 Feb 2019 12:42:25 +0000
Received: from xserv1.ast.cam.ac.uk (xserv1.ast.cam.ac.uk [131.111.69.235])
        by casxb.ast.cam.ac.uk (8.15.1+Sun/8.15.1) with ESMTP id x1JCgOKf016270;
        Tue, 19 Feb 2019 12:42:25 GMT
Received: from xpc16.ast.cam.ac.uk (xpc16.ast.cam.ac.uk [131.111.69.117])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmj@xserv1.ast.cam.ac.uk)
        by xserv1.ast.cam.ac.uk (Postfix) with ESMTPSA id DF9E120688;
        Tue, 19 Feb 2019 12:42:24 +0000 (GMT)
Subject: Re: Broken filesystem
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <4d1be873-541a-96dd-0795-16a4fb2d4556@ast.cam.ac.uk>
 <0d7012d4-0274-aa8b-1a49-9c269f3cfdf1@gmx.com>
From:   Roderick Johnstone <rmj@ast.cam.ac.uk>
Message-ID: <fda02e91-aa41-0c9b-d25d-4a348e88e9f0@ast.cam.ac.uk>
Date:   Tue, 19 Feb 2019 12:42:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <0d7012d4-0274-aa8b-1a49-9c269f3cfdf1@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 19/02/2019 12:34, Qu Wenruo wrote:
> 
> 
> On 2019/2/19 下午6:24, Roderick Johnstone wrote:
>> Hi
>>
>> This is on Fedora 28:
>>
>> # uname -a
>> Linux mysystem.mydomain 4.20.7-100.fc28.x86_64 #1 SMP Wed Feb 6 19:17:09
>> UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
>>
>> # btrfs --version
>> btrfs-progs v4.17.1
>>
>> #   btrfs fi show
>> Label: none  uuid: 56d0171a-440d-47ff-ad0f-f7f97df31f7b
>>          Total devices 1 FS bytes used 7.39TiB
>>          devid    1 size 9.10TiB used 7.50TiB path /dev/md2
>>
>>
>> My btrfs filesystem is in a bad state after a partial disk failure on
>> the md device (raid 6 array) the file system was on.
>>
>> One of the disks had bad blocks, but instead of being ejected from the
>> array, the array hung up.
> 
> I'm a little interested why RAID6 hung up.

I'm not sure but I think it was due to the failure more of the hardware.

> 
>> After rebooting to regain access and remove
>> the bad disk I am in the following situation:
>>
>> # mount -t btrfs -o compress-force=zlib,noatime /dev/md2 /mnt/rmj
>> mount: /mnt/rmj: wrong fs type, bad option, bad superblock on /dev/md2,
>> missing codepage or helper program, or other error.
>> # dmesg
>> ...
>>    264.527647] BTRFS info (device md2): force zlib compression, level 3
>> [  264.955360] BTRFS error (device md2): parent transid verify failed on
>> 5568287064064 wanted 254988 found 94122
> 
> It's 99% some extent tree blocks get corrupted.
> 
>> [  264.964273] BTRFS error (device md2): open_ctree failed
>>
>> I can mount and access the filesystem with the usebackuproot option:
>>
>> # mount -t btrfs -o usebackuproot,compress-force=zlib,noatime /dev/md2
>> /mnt/rmj
>> [  307.542761] BTRFS info (device md2): trying to use backup root at
>> mount time
>> [  307.542768] BTRFS info (device md2): force zlib compression, level 3
>> [  307.570897] BTRFS error (device md2): parent transid verify failed on
>> 5568287064064 wanted 254988 found 94122
>> [  307.570979] BTRFS error (device md2): parent transid verify failed on
>> 5568287064064 wanted 254988 found 94122
>> [  431.167149] BTRFS info (device md2): checking UUID tree
>>
>> But later after a umount there are these messages.
>>
>> # umount /mnt/rmj
>> 2205.778998] BTRFS error (device md2): parent transid verify failed on
>> 5568276393984 wanted 254986 found 94117
>> [ 2205.779008] BTRFS: error (device md2) in __btrfs_free_extent:6831:
>> errno=-5 IO failure
>> [ 2205.779082] BTRFS info (device md2): forced readonly
>> [ 2205.779087] BTRFS: error (device md2) in btrfs_run_delayed_refs:2978:
>> errno=-5 IO failure
>> [ 2205.779192] BTRFS warning (device md2): btrfs_uuid_scan_kthread
>> failed -30
> Of course it's extent tree corrupted.
> 
>>
>> and a subsequent mount without the userbackuproot fails in the same way
>> as before.
>>
>> I have a copy of the important directories, but would like to be able to
>> repair the filesystem if possible,
> 
> You could mostly salvage the data, either use 'usebackuproot' mount
> option + RO mount or btrfs-restore.
> 
> For full rw recovery, I don't think there is a good tool right now.
> Extent tree repair is pretty trikcy, under most case, the only method is
> --init-extent-tree, but that functionality isn't tried by many users.
> And it only makes sense if all other trees are OK.
> 
> So in short, RW recovery is near impossible.
> 
>>
>> Any advise around repairing the filesystem would be appreciated.
> 
> It's better to salvage your data first and if you like adventure, try
> --init-extent-tree.
> If not, just rebuild the array.


ok, thanks.

Roderick
> 
> Thanks,
> Qu
> 
>>
>> Thanks.
>>
>> Roderick Johnstone
> 
