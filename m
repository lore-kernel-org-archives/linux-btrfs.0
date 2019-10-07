Return-Path: <SRS0=vnEf=YA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F7EC47404
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Oct 2019 09:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C94EC21655
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Oct 2019 09:42:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZxT9wJNL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfJGJmm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 05:42:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55834 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbfJGJml (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2019 05:42:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x979d081022856;
        Mon, 7 Oct 2019 09:42:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=3Y0oRfD/fgSA3DSMHRUk1afFPLN52fxaca2xl6lM4Aw=;
 b=ZxT9wJNLZJIWI26QV3LbOJqbK3aORSXo4i1Qqe6dQIV2yI/aKpF+DdTBLyPKzwK69Gvf
 dgVSrsCD9iTccFjE6zlPvMKI4clRyy9h54/36bWoTnfWhJCxiDCu7s/2H9LX2WRjOmH8
 FUNS1OKRpmQatmqKk0UK5IebsYX3YXv5jUx97/nllk/tqx+Hk0BcLgEjzipBaRyxLv0O
 u+U9r1zbJ73vLsMw+Z3MIez2TOEhclk5jPRDgcWiQ7wTQJ8Nm3pVsow5jsWLyDvXSzC6
 fx0EXQS9WkzKXoNp6hHHOR6kctKPPH/3vUlXoBgiqTQo3Wv7R8becV97weYlI+MeP2mu 7Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vek4q5n0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Oct 2019 09:42:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x979cQqL077651;
        Mon, 7 Oct 2019 09:42:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vg1ytjpw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Oct 2019 09:42:37 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x979gbAc020857;
        Mon, 7 Oct 2019 09:42:37 GMT
Received: from [192.168.1.119] (/39.109.145.141)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Oct 2019 02:42:36 -0700
Subject: Re: [PATCH 0/4] btrfs: fix issues due to alien device
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1570175403-4073-1-git-send-email-anand.jain@oracle.com>
 <4fbd9d31-5813-6479-6b35-94baa7dc7e9a@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <c4762a3b-e155-d9e9-4f6a-b9beef85b5cb@oracle.com>
Date:   Mon, 7 Oct 2019 17:42:28 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <4fbd9d31-5813-6479-6b35-94baa7dc7e9a@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9402 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=954
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910070097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9402 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910070097
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 4/10/19 4:19 PM, Nikolay Borisov wrote:
> 
> 
> On 4.10.19 г. 10:49 ч., Anand Jain wrote:
>> Alien device is a device in fs_devices list having a different fsid than
>> the expected fsid. This patch set fixes issues found due to the same.
> 
> Are you going to submit an fstests patch for this bug ?

  Yes. Done.

