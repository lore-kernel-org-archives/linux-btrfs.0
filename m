Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5686CC43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 12:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DD87208E3
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 12:09:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qr8M8Bpb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfADMJ2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 07:09:28 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44008 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfADMJ2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jan 2019 07:09:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x04C4YSX185967;
        Fri, 4 Jan 2019 12:09:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=56WiL/P8wXDEWNn1ETVHSmjTMEAmCTekaDU8dwHBXSE=;
 b=Qr8M8BpbGn67q7w35ZrfqwppeHS7GD1hmWawvUTIVuvolmTf6HprZA9w5Sz2cwwEEcXn
 Vy9OFMvhCR3seDYWzWrDQoa0mh+96xiqn5fzgsdm6UUmkPlaaHaqEmMe9wfkrYvRNJUp
 EwV5AlcMBFzYTDCvLj5xqtlFumlmq8x3TiztmNlzA1wVQulX0Ad5GrjsidBN5518PYEU
 YKYNieiAeGy+bK4mvCj2FeG9oZxzZZd8jlII2EV2ePUpt4A5oilJUpyQZFVdScC7nVSG
 ghtJXUzRMKD7MZNBqKaO+ijrKF/JdeKOoGqg8p4PwuuPocY7Ry5YWIkHvCcqaInHPloH wQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2pnxeebyap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jan 2019 12:09:20 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x04C9Jtp019984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Jan 2019 12:09:20 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x04C9JPG014355;
        Fri, 4 Jan 2019 12:09:19 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Jan 2019 04:09:19 -0800
Subject: Re: [PATCH 1/1] btrfs-progs: btrfstune: print seeding status
To:     David Disseldorp <ddiss@suse.de>
Cc:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20190103232239.11931-1-ddiss@suse.de>
 <20190103232239.11931-2-ddiss@suse.de>
 <5e76f1f9-27aa-c89c-861a-9d6a9f197482@suse.com>
 <20190104112645.2a39eca8@suse.de>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <d254c9ce-1c7f-5530-5dcb-a5ffedda0723@oracle.com>
Date:   Fri, 4 Jan 2019 20:09:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190104112645.2a39eca8@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9125 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901040109
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


I agree btrfstune should have ability to read the parameter. But none of 
the btrsftune parameter [1] which it sets, aren't readable using 
btrfstune. So can we first design how are going to do it for rest of 
the parameters in btrfstune then later this patch can just fix for seed.

[1]
usage: btrfstune [options] device
	-S value	positive value will enable seeding, zero to disable, negative 
is not allowed
	-r 		enable extended inode refs
	-x 		enable skinny metadata extent refs
	-n 		enable no-holes feature (more efficient sparse file representation)
	-f 		force to do dangerous operation, make sure that you are aware of 
the dangers
	-u 		change fsid, use a random one
	-U UUID		change fsid to UUID


One suggestion
    btrfstune read -<S|r|x|n|u> <dev>




On 01/04/2019 06:26 PM, David Disseldorp wrote:
> On Fri, 4 Jan 2019 09:05:00 +0200, Nikolay Borisov wrote:
> 
>> btrfs inspect-internal dump-super already supports showing seeding, why
>> do we need btrfstune support for that as well?
> 
> Ah, I wasn't aware of that. IMO the logical place to look is next to
> where the user enables seeding (btrfstune -S1).
> 
>> Also the way you've
>> phrased is a bit misleading, since checking the superflag doesn't mean
>> seeding for a particular _device_ is enabled but that the filesystem
>> itself is set as seeding.
> 
> Not quite sure I follow. For a multi-dev FS (one seeding), I see:
> 
> rapido1:/# btrfstune -s /dev/zram0
> Seeding flag is currently unset
> rapido1:/# btrfstune -S 1 /dev/zram0
> rapido1:/# btrfstune -s /dev/zram0
> Seeding flag is currently set
> rapido1:/# mount /dev/zram0 /mnt/test/
> mount: /dev/zram0 is write-protected, mounting read-only
> ....
> rapido1:/# btrfs device add -f /dev/zram1 /mnt/test/
> [   77.805374] BTRFS info (device zram0): disk added /dev/zram1
> rapido1:/# umount /mnt/test/
> rapido1:/# btrfstune -s /dev/zram1
> Seeding flag is currently unset
> rapido1:/# btrfstune -s /dev/zram0
> Seeding flag is currently set
> 
> Cheers, David
> 
