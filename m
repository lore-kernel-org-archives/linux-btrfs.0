Return-Path: <SRS0=ilb6=O5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 426EAC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Dec 2018 00:53:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 095BA20873
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Dec 2018 00:53:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gtSpIfDa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbeLTAxY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Dec 2018 19:53:24 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45866 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729611AbeLTAxY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Dec 2018 19:53:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wBK0UA8k176605;
        Thu, 20 Dec 2018 00:53:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : cc : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Z/ySGJGZPedvHSWF61yWPOR45nlvQWQ3myGwSJUyBQU=;
 b=gtSpIfDabDsj4Gwz5i5VTbf2wgvGIoNfvAtUPpNNTyTFn0rFv9M8YuNexkkAe7QrGyJy
 sp32OWpUMKAU1fB9zspbOZ3KK5YT0xxxpYQQnENQQrJ7EoWXgs/1vTs0sO6beywWjub+
 lkTBPnn5HC4/jfHisS38G3uoojhAc5AKoDys2jzRdijkbEiUKIpMt14Kyvk3USZ71bjL
 5yAufYjvfkuT+TNf9iTvZRLFnzRfVI+9e2InqUcGgQvu6agVTf3zt2tuPACDuMJ+L4se
 bQpDVEhIj9h8OQvm5cjeKOulIB+mzAS7sFKbgIqQU+dO9DWkNGX0xWQxViX8JjQ9ftEL pA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2pfn1yuhtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Dec 2018 00:53:22 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wBK0rMRt003546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Dec 2018 00:53:22 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wBK0rL9t027101;
        Thu, 20 Dec 2018 00:53:21 GMT
Received: from [172.20.10.4] (/157.49.164.188)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Dec 2018 16:53:21 -0800
Subject: Re: compress-force not really forcing compression?
To:     devzero@web.de
References: <trinity-138fb9ef-e164-4c58-8ba8-04eaa9813254-1545234086993@3c-app-webde-bs26>
From:   Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Message-ID: <e6525c31-66fa-136f-9719-9f77ba6ba6cd@oracle.com>
Date:   Thu, 20 Dec 2018 08:53:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <trinity-138fb9ef-e164-4c58-8ba8-04eaa9813254-1545234086993@3c-app-webde-bs26>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9112 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=960
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1812200002
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 12/19/2018 11:41 PM, devzero@web.de wrote:
> does compress-force really force compression?
> 
> for me (found via compsize - see https://github.com/kilobyte/compsize/issues/24 )  it looks it is problably forcing compression check for every block of a file (while compress= makes btrfs skip compression check after first block) and if some block is incompressible, apparently it's being stored uncompressed.
> 
> so, the documentation is probably telling misleading information and should be fixed!?

  A slight correction is needed to the documentation..
   The difference between the -o compress and -o compress-force is that 
the latter tries to compress every extent of the file (that is it never 
gives-up), whereas the former gives up (on an inode) at the first 
non-compressible extent. In both the cases compressed-extents are saved 
only if there is a space benefit otherwise it shall write the regular 
(uncompressed) extent.

HTH

> roland
> 
> 
> 
> https://btrfs.wiki.kernel.org/index.php/Compression#What_happens_to_incompressible_files.3F
> 
> What happens to incompressible files?
> 
> There is a simple decision logic: if the first portion of data being compressed is not smaller than the original, the compression of the file is disabled -- unless the filesystem is mounted with -o compress-force. In that case it'll be compressed always regardless of the compressibility of the file. This is not optimal and subject to optimizations and further development.
> 
> 
> 
