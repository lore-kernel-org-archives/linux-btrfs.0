Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8E1C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 08:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84F8720684
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 08:35:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84F8720684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbeI1O6E (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 10:58:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39900 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726586AbeI1O6E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 10:58:04 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8S8Y77g119866
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:35:25 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2msftwthh7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:35:24 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 28 Sep 2018 09:35:23 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 28 Sep 2018 09:35:20 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id w8S8ZJLv63045774
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Sep 2018 08:35:19 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3ADD711C04C;
        Fri, 28 Sep 2018 11:34:59 +0100 (BST)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0651511C050;
        Fri, 28 Sep 2018 11:34:59 +0100 (BST)
Received: from localhost.localdomain (unknown [9.124.35.177])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Sep 2018 11:34:58 +0100 (BST)
From:   Chandan Rajendra <chandan@linux.vnet.ibm.com>
To:     Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-mm@kvack.org
Cc:     Josef Bacik <josef@toxicpanda.com>, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 06/10] writeback: introduce super_operations->write_metadata
Date:   Fri, 28 Sep 2018 14:07:41 +0530
In-Reply-To: <2857272.fAFXmvyrml@dhcp-9-109-247-21>
References: <20171212180534.c5f7luqz5oyfe7c3@destiny> <20180103162922.rxs2jpvmpxa62usa@destiny> <2857272.fAFXmvyrml@dhcp-9-109-247-21>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 18092808-0012-0000-0000-000002AFB80F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 18092808-0013-0000-0000-000020E3DA0C
Message-Id: <139844049.hOcP8gZF7I@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-09-28_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=753 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1807170000 definitions=main-1809280090
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Monday, January 29, 2018 2:36:15 PM IST Chandan Rajendra wrote:
> On Wednesday, January 3, 2018 9:59:24 PM IST Josef Bacik wrote:
> > On Wed, Jan 03, 2018 at 05:26:03PM +0100, Jan Kara wrote:
> 
> > 
> > Oh ok well if that's the case then I'll fix this up to be a ratio, test
> > everything, and send it along probably early next week.  Thanks,
> > 
> 
> Hi Josef,
> 
> Did you get a chance to work on the next version of this patchset?
> 
> 
> 

Josef,  Any updates on this and the "Kill Btree inode" patchset?

-- 
chandan

