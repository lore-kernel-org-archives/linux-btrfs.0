Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA663C43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 05:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79784208E4
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 05:58:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DXMDExAa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfDBF6f (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 01:58:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38202 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfDBF6f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 01:58:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x325wW7Y124711;
        Tue, 2 Apr 2019 05:58:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=34NPOdSMuShiCJI1uPXGvsLNfIBrT9wf3dtON29s44I=;
 b=DXMDExAa6k4iXtb6qu0CEqpa7KdUeuhlb30DxEdkozDZL3u9iekt9hnvC/c0ZuTrSnVW
 eap6qqEkTIprWYlxFtk1kYT6khPmWCta75oxOnZAGE2SOSqq5JdHt90UKm/waWI9AeFp
 3pAJjDBsJrfDURaFecoNx+zzjIkrLldNjjidlHOOcIxtqfg2S5WhlDHpPLkkaqksYzZX
 Mn8RqQh3Ok1miSnap01e+obTF+qHDh/9+ngwhglPlxHXwvNGbm01GiG5bNXNow1INQRd
 BkMgeYwF6nky6mUPkuTxx+HJKXLgpowV55BP6Pki8PGd5cy15YEM4rieVHp1Y9hovyzP 6g== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2rj13q2tq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Apr 2019 05:58:32 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x325wTlo015739
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Apr 2019 05:58:29 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x325wSbP010677;
        Tue, 2 Apr 2019 05:58:28 GMT
Received: from [10.190.130.106] (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Apr 2019 22:58:28 -0700
Subject: Re: [PATCH v3] fstests: btrfs verify hardening agaist duplicate fsid
To:     guaneryu@gmail.com
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <1540571900-24768-1-git-send-email-anand.jain@oracle.com>
From:   Anand Jain <Anand.Jain@oracle.com>
Message-ID: <799893ab-763e-7aa7-9e2b-2f1218d29b13@oracle.com>
Date:   Tue, 2 Apr 2019 13:58:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1540571900-24768-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9214 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904020044
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Eryu,

  This patch isn't integrated yet.

Thanks, Anand

On 27/10/18 12:38 AM, Anand Jain wrote:
> We have a known bug in btrfs, that we let the device path be changed
> after the device has been mounted. So using this loop hole the new
> copied device would appears as if its mounted immediately after its
> been copied. So this test case reproduces this issue.
> 
> For example:
> 
> Initially.. /dev/mmcblk0p4 is mounted as /
> 
> lsblk
> NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> mmcblk0     179:0    0 29.2G  0 disk
> |-mmcblk0p4 179:4    0    4G  0 part /
> |-mmcblk0p2 179:2    0  500M  0 part /boot
> |-mmcblk0p3 179:3    0  256M  0 part [SWAP]
> `-mmcblk0p1 179:1    0  256M  0 part /boot/efi
> 
> btrfs fi show
> Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
>      Total devices 1 FS bytes used 1.40GiB
>      devid    1 size 4.00GiB used 3.00GiB path /dev/mmcblk0p4
> 
> Copy mmcblk0 to sda
> dd if=/dev/mmcblk0 of=/dev/sda
> 
> And immediately after the copy completes the change in the device
> superblock is notified which the automount scans using
> btrfs device scan and the new device sda becomes the mounted root
> device.
> 
> lsblk
> NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> sda           8:0    1 14.9G  0 disk
> |-sda4        8:4    1    4G  0 part /
> |-sda2        8:2    1  500M  0 part
> |-sda3        8:3    1  256M  0 part
> `-sda1        8:1    1  256M  0 part
> mmcblk0     179:0    0 29.2G  0 disk
> |-mmcblk0p4 179:4    0    4G  0 part
> |-mmcblk0p2 179:2    0  500M  0 part /boot
> |-mmcblk0p3 179:3    0  256M  0 part [SWAP]
> `-mmcblk0p1 179:1    0  256M  0 part /boot/efi
> btrfs fi show /
> Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
>      Total devices 1 FS bytes used 1.40GiB
>      devid    1 size 4.00GiB used 3.00GiB path /dev/sda4
> 
> The bug is quite nasty that you can't either unmount /dev/sda4 or
> /dev/mmcblk0p4. And the problem does not get solved until you take
> the sda out of the system on to another system to change its fsid using
> the 'btrfstune -u' command.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v2->v3:
>    Check the return code and use _fail to verify and accordingly fix golden
>      output.
>    Rename dev_foo(bar) to device_1(2)
>    Don't log dd retun to $seqres.full
>   
> v1->v2:
>    dont play around with dev patch use it as it is.
>    do not use SCRATCH_MNT instead create it at the TEST_DIR and its related
>     changes.
>    golden out changes
> 
>   tests/btrfs/173     | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/173.out |  2 ++
>   tests/btrfs/group   |  1 +
>   3 files changed, 85 insertions(+)
>   create mode 100755 tests/btrfs/173
>   create mode 100644 tests/btrfs/173.out
> 
> diff --git a/tests/btrfs/173 b/tests/btrfs/173
> new file mode 100755
> index 000000000000..342ae92b4781
> --- /dev/null
> +++ b/tests/btrfs/173
> @@ -0,0 +1,82 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Oracle. All Rights Reserved.
> +#
> +# FS QA Test 173
> +#
> +# Fuzzy test for FS image duplication.
> +#  Could be fixed by
> +#    [patch] btrfs: harden agaist duplicate fsid
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +mnt=$TEST_DIR/$seq.mnt
> +_cleanup()
> +{
> +	rm -rf $mnt > /dev/null 2>&1
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch_dev_pool 2
> +_scratch_dev_pool_get 2
> +
> +device_1=$(echo $SCRATCH_DEV_POOL | awk '{print $1}')
> +device_2=$(echo $SCRATCH_DEV_POOL | awk '{print $2}')
> +
> +echo device_1=$device_1 device_2=$device_2 >> $seqres.full
> +
> +rm -rf $mnt > /dev/null 2>&1
> +mkdir $mnt
> +_mkfs_dev $device_1
> +_mount $device_1 $mnt
> +
> +[[ $(findmnt $mnt | grep -v TARGET | awk '{print $2}') != $device_1 ]] && \
> +						_fail "mounted device changed"
> +
> +for sb_bytenr in 65536 67108864
> +do
> +	echo -n "dd status=none if=$dev_foo of=$dev_bar bs=1 "\
> +		"seek=$sb_bytenr skip=$sb_bytenr count=4096" >> $seqres.full
> +	dd status=none if=$device_1 of=$device_2 bs=1 seek=$sb_bytenr \
> +				skip=$sb_bytenr count=4096 > /dev/null 2>&1
> +	echo ..:$? >> $seqres.full
> +done
> +
> +#Original device is mounted, scan of its clone should fail
> +$BTRFS_UTIL_PROG device scan $device_2 >> $seqres.full 2>&1
> +[[ $? != 1 ]] && _fail "cloned device scan should fail"
> +
> +[[ $(findmnt $mnt | grep -v TARGET | awk '{print $2}') != $device_1 ]] && \
> +						_fail "mounted device changed"
> +
> +#Original device scan should be successful
> +$BTRFS_UTIL_PROG device scan $device_1 >> $seqres.full 2>&1
> +[[ $? != 0 ]] && \
> +	_fail "if it fails here, then it means subvolume mount at boot may fail "\
> +	      "in some configs."
> +
> +umount $mnt > /dev/null 2>&1
> +_scratch_dev_pool_put
> +
> +# success, all done
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/btrfs/173.out b/tests/btrfs/173.out
> new file mode 100644
> index 000000000000..2c57ea508748
> --- /dev/null
> +++ b/tests/btrfs/173.out
> @@ -0,0 +1,2 @@
> +QA output created by 173
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 45782565c3b7..b2f1393f3e97 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -175,3 +175,4 @@
>   170 auto quick snapshot
>   171 auto quick qgroup
>   172 auto quick punch
> +173 volume
> 

