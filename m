Return-Path: <SRS0=6oD6=QX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF75C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 08:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18BBB222D9
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 08:16:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kvSGaqaO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfBPIQ1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Feb 2019 03:16:27 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36650 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbfBPIQ1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Feb 2019 03:16:27 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1G8FQJl121099;
        Sat, 16 Feb 2019 08:16:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=rVac246B1RmfZmhxW/6km/K6xp8ZFbRMUyweMBZZHSc=;
 b=kvSGaqaOnNTsnGYOQiD150XlG0NKoHJdKIqq7LMZorl3s3E4AVldi5L5eT9+tUDrR+Zr
 dTLanMlGznmKC9NBzycnyEcU1JiylJpCEXLW2DNxmcy+Ki3hzc2WmPMGj6hCxJnYZwpE
 Ju6hSY/qgtMm48QpnrVbDgOALIgilXMBc3ZeiniWYrw9viiaOxKGwBErnHnlBXsedsfe
 1HJL+1n4v7rpP3vP2b/sbFBs042+5ng2gLRxIfigptuRV14CDBP5nqA7UZ2Tq0EIpCUW
 ufuue30Xkq8Mxd5g/Vfx0IRREEXu1BdarolhUrddbuZlEjSIrnIGBBQPSGFUUv6WPYi+ Vw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2qp81drkxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Feb 2019 08:16:19 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1G8GIT9010072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Feb 2019 08:16:18 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1G8GHq7001141;
        Sat, 16 Feb 2019 08:16:17 GMT
Received: from [192.168.1.12] (/116.239.187.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 16 Feb 2019 00:16:17 -0800
Subject: Re: [LSF/MM TOPIC] Software RAID Support for NV-DIMM
To:     Dave Chinner <david@fromorbit.com>,
        Johannes Thumshirn <jthumshirn@suse.de>
Cc:     lsf-pc@lists.linux-foundation.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-btrfs@vger.kernel.org, hare@suse.de
References: <20190215095710.GA12279@linux-x5ow.site>
 <20190216053133.GT20493@dastard> <20190216053957.GU20493@dastard>
From:   Bob Liu <bob.liu@oracle.com>
Message-ID: <a8350a49-f81d-aeaf-e8a7-96170c68e4b9@oracle.com>
Date:   Sat, 16 Feb 2019 16:16:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190216053957.GU20493@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9168 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902160062
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2/16/19 1:39 PM, Dave Chinner wrote:
> On Sat, Feb 16, 2019 at 04:31:33PM +1100, Dave Chinner wrote:
>> On Fri, Feb 15, 2019 at 10:57:12AM +0100, Johannes Thumshirn wrote:
>>> (This is a joint proposal with Hannes Reinecke)
>>>
>>> Servers with NV-DIMM are slowly emerging in data centers but one key feature
>>> for reliability of these systems hasn't been addressed up to now, data
>>> redundancy.
>>>
>>> While it would be best to solve this issue in the memory controller of the CPU
>>> itself, I don't see this coming in the next few years. This puts us as the OS
>>> in the burden to create the redundant copies of data for the users.
>>>
>>> If we leave of the DAX support Linux' software RAID implementations (MD,
>>> device-mapper and BTRFS RAID) do already work on top of pmem devices, but they
>>> are incompatible with DAX.
>>>
>>> In this session Hannes and I would like to discuss eventual ways how we as an
>>> operating system can mitigate these issues for our users.
>>
>> We've supported this since mid 2018 and commit ba23cba9b3bd ("fs:
>> allow per-device dax status checking for filesystems"). That is,
>> we can have DAX on the XFS RT device indepently of the data device.
>>
>> That is, you set up pmem in three segments - two small identical
>> segments start get mirrored with RAID1 as the data device, and
>> the remainder as a block device that is dax capable set up as the
>> XFS realtime device. Set the RTINHERIT bit on the root directory at
>> mkfs time ("-d rtinherit=1") and then all the data goes to the DAX
>> capable realtime device, and all the metadata goes to the software
>> raided pmem block devices that aren't DAX capable.
>>
>> Problem already solved, yes?
> 
> Sorry, this was meant to be a reply to Dan's email commenting about
> some people needing mirrored metadata, not the parent that was
> talking about whole device RAID...
> 
> i.e. mirrored metadata w/ FS-DAX for data should already be a solved
> problem...
> 

Indeed, here is the v2 version about mirrored metadata retry.
https://marc.info/?l=linux-block&m=155005161104512&w=2
Appreciate any reviews, thank you!

- Bob

