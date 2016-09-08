Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47251 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755717AbcIHLvA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Sep 2016 07:51:00 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u88BhUl3055493
        for <linux-btrfs@vger.kernel.org>; Thu, 8 Sep 2016 07:51:00 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 25atay75b9-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Sep 2016 07:50:59 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 8 Sep 2016 12:50:58 +0100
Subject: Re: lockdep warning in btrfs in 4.8-rc3
To: Chris Mason <clm@fb.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20160826233624.jao5mztbxhjikm7e@floor.thefacebook.com>
 <6a3eed93-fb4d-817a-6a59-7e7f91c8ea6d@de.ibm.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Date: Thu, 8 Sep 2016 13:50:53 +0200
MIME-Version: 1.0
In-Reply-To: <6a3eed93-fb4d-817a-6a59-7e7f91c8ea6d@de.ibm.com>
Content-Type: text/plain; charset=windows-1252
Message-Id: <624b2c3a-5030-3f7f-70d6-4507308d785b@de.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/08/2016 01:48 PM, Christian Borntraeger wrote:
> Chris,
> 
> with 4.8-rc3 I get the following on an s390 box:

Sorry for the noise, just saw the fix in your pull request.

