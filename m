Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4EBAC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 15:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63FD02086B
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 15:42:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JREq+cT0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 63FD02086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731479AbeKNBlR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 20:41:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57598 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727188AbeKNBlR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 20:41:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wADFcduH088617;
        Tue, 13 Nov 2018 15:42:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=kZmcho/FCowMSHRE0UTtILvzeAs2NoEL/Fep8tVPEOk=;
 b=JREq+cT0JBhpJNy3DrHivttY9dAqK3orbsOLqxEcNes4/+zMhPy4lWUXlHMzrO+JEvjL
 7Rz70T0BDvv2iCg4khBaCfgJbU4Wkzrl5CkY0wSHGYMJyFSPiTS0Hcd1M574Jxpt66oL
 BW2Qqm0NdYogx0LwEsLtT83CId3w2chZX8D8Joy6kyywFtdoR79NHPeXnEcbVbGTsijw
 OwAOxDoiWl0ickAha89c+ds2fNVnivvbeSiVqj11rLiVL3xmMdA3UmdBrmDZlra9yck3
 EG/2wBMa2QS6l3J6o/hoFHq/yN3SQQoOgNST0zz6HsvtLKbIZztDLkFOf52+FdabKT0o bA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2nnw6ekhck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Nov 2018 15:42:34 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wADFgYBd002230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Nov 2018 15:42:34 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wADFgYxF031494;
        Tue, 13 Nov 2018 15:42:34 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Nov 2018 07:42:34 -0800
Subject: Re: [PATCH RFC RESEND] btrfs: harden agaist duplicate fsid
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1539571517-7900-1-git-send-email-anand.jain@oracle.com>
 <20181113152147.GC24115@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <c1cb3aa1-0961-a619-dc32-99e5487a635a@oracle.com>
Date:   Tue, 13 Nov 2018 23:42:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181113152147.GC24115@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9076 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811130142
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/13/2018 11:21 PM, David Sterba wrote:
> On Mon, Oct 15, 2018 at 10:45:17AM +0800, Anand Jain wrote:
>> (Thanks for the comments on requiring to warn_on if we fail the device change.)
>> (This fixes an ugly bug, I appreciate if you have any further comments).
>>
>> Its not that impossible to imagine that a device OR a btrfs image is
>> been copied just by using the dd or the cp command. Which in case both
>> the copies of the btrfs will have the same fsid. If on the system with
>> automount enabled, the copied FS gets scanned.
>>
>> We have a known bug in btrfs, that we let the device path be changed
>> after the device has been mounted. So using this loop hole the new
>> copied device would appears as if its mounted immediately after its
>> been copied.
>>
>> For example:
>>
>> Initially.. /dev/mmcblk0p4 is mounted as /
>>
>> lsblk
>> NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
>> mmcblk0     179:0    0 29.2G  0 disk
>> |-mmcblk0p4 179:4    0    4G  0 part /
>> |-mmcblk0p2 179:2    0  500M  0 part /boot
>> |-mmcblk0p3 179:3    0  256M  0 part [SWAP]
>> `-mmcblk0p1 179:1    0  256M  0 part /boot/efi
>>
>> btrfs fi show
>>     Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
>>     Total devices 1 FS bytes used 1.40GiB
>>     devid    1 size 4.00GiB used 3.00GiB path /dev/mmcblk0p4
>>
>> Copy mmcblk0 to sda
>>     dd if=/dev/mmcblk0 of=/dev/sda
>>
>> And immediately after the copy completes the change in the device
>> superblock is notified which the automount scans using
>> btrfs device scan and the new device sda becomes the mounted root
>> device.
>>
>> lsblk
>> NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
>> sda           8:0    1 14.9G  0 disk
>> |-sda4        8:4    1    4G  0 part /
>> |-sda2        8:2    1  500M  0 part
>> |-sda3        8:3    1  256M  0 part
>> `-sda1        8:1    1  256M  0 part
>> mmcblk0     179:0    0 29.2G  0 disk
>> |-mmcblk0p4 179:4    0    4G  0 part
>> |-mmcblk0p2 179:2    0  500M  0 part /boot
>> |-mmcblk0p3 179:3    0  256M  0 part [SWAP]
>> `-mmcblk0p1 179:1    0  256M  0 part /boot/efi
>>
>> btrfs fi show /
>>   Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
>>   Total devices 1 FS bytes used 1.40GiB
>>   devid    1 size 4.00GiB used 3.00GiB path /dev/sda4
>>
>> The bug is quite nasty that you can't either unmount /dev/sda4 or
>> /dev/mmcblk0p4. And the problem does not get solved until you take
>> sda out of the system on to another system to change its fsid
>> using the 'btrfstune -u' command.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> I'm adding the patch to misc-next now, with an update message that
> matches the format when a device is scanned.
> 
> "BTRFS: device fsid %pU devid %llu moved old:%s new:%s\n",
> 
> That way it should be possible to grep for all messages that are related
> to the scanning ioctl.

  Right. Looks fine to me. Thanks, Anand
