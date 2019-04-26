Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D52EC43218
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 06:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 717142077B
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 06:20:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BZn2Kzoc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfDZGUZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Apr 2019 02:20:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40556 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfDZGUZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Apr 2019 02:20:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3Q6Idbo110983;
        Fri, 26 Apr 2019 06:20:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : cc : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=dBuJV6r/yPwJ0bU8FCbkF1i91sxOJVLxH7uw6QWWgng=;
 b=BZn2Kzoc62SSfmEEQscDkvaPbWyIsINIoeCMkhrdHJEQwJM346qw9f6bqHvugRpds0Cs
 Ft2fdfd/T07pJ2phSY0UWFq84vLWKrVvhvTltDS9EpI1nLh7N3TgkPGSPtinGJWzLuh4
 zGBKTSh8QrQ51xNfFW4H3lujT5M3sucm52W2kKnacQzgx+J29QYRgz4465+GUsddN9E+
 CwuTNWObJDTD7S+j6giXNMtAtloDAgdXwcKAIz5m3YBoAD4b3JF1U1JiQsR5p0jo3EZ2
 1mX/xSoDNMCf78wO3lV2IR/vw7wptLz0Eh/+463YS9P+7cwmPcyiXHwY3TcBKy0VsxYo Dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2rytutc82f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Apr 2019 06:20:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3Q6Jdq2103914;
        Fri, 26 Apr 2019 06:20:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ryrhtnsm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Apr 2019 06:20:20 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3Q6KHPQ015179;
        Fri, 26 Apr 2019 06:20:17 GMT
Received: from mb.local (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Apr 2019 23:20:17 -0700
Subject: Re: [PATCH 00/10] cleanup btrfs_ioctl_setflags and btrfs_set_prop
To:     dsterba@suse.cz
References: <20190420114900.15472-1-anand.jain@oracle.com>
 <20190424151432.GX20156@twin.jikos.cz>
Cc:     linux-btrfs@vger.kernel.org
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <e2c545dd-3339-05b4-66d9-5408f97f69da@oracle.com>
Date:   Fri, 26 Apr 2019 14:20:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190424151432.GX20156@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9238 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=787
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904260045
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9238 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=811 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904260045
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 24/4/19 11:14 PM, David Sterba wrote:
> On Sat, Apr 20, 2019 at 07:48:50PM +0800, Anand Jain wrote:
>> A set of pathes to clean up btrfs_ioctl_setflags(), btrfs_set_prop_trans()
>> and btrfs_set_prop(). So as to avoidi duplicate code in
>> btrfs_ioctl_setflags() and killing of btrfs_set_prop_trans().
>>
>> Anand Jain (10):
>>    btrfs: refactor btrfs_set_props to validate externally
>>    btrfs: export btrfs_set_prop
>>    btrfs: start transaction in btrfs_ioctl_setflags()
>>    btrfs: drop useless inode i_flags copy and restore
>>    btrfs: make a local copy of btrfs_inode flags before update
>>    btrfs: drop old_fsflags in btrfs_ioctl_setflags
>>    btrfs: drop local copy of inode i_mode
>>    btrfs: start transaction in xattr_handler_set_prop
>>    btrfs: delete unused function btrfs_set_prop_trans
>>    btrfs: btrfs_set_prop trans is never null
> 
> Looks good to me, I'll add it to misc-next as it's only a cleanup
> series, now that we're getting close to 5.2 code freeze.
> 
Thanks.
I thought I will take a look, looks like its not yet pushed?
Which is the most updated? repo gitlab/github?
-Anand
