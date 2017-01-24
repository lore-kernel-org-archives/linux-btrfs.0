Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49437 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750794AbdAXL1W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 06:27:22 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0OBO1uB144479
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 06:27:21 -0500
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28612wkvu0-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 06:27:21 -0500
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 24 Jan 2017 04:27:19 -0700
Subject: Re: [PATCH 0/1] btrfs lockdep annotation
To: fdmanana@gmail.com
References: <20161126134638.GA79987@clm-mbp.masoncoding.com>
 <1485248507-6079-1-git-send-email-borntraeger@de.ibm.com>
 <CAL3q7H4Y08K4fgBe3k3r_P+YikN_z=3H1H+T6zMYJ+pAS99wzw@mail.gmail.com>
Cc: Chris Mason <clm@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Date: Tue, 24 Jan 2017 12:27:14 +0100
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4Y08K4fgBe3k3r_P+YikN_z=3H1H+T6zMYJ+pAS99wzw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Message-Id: <73669801-4a2e-485e-1251-da8723666e22@de.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/24/2017 11:22 AM, Filipe Manana wrote:
> On Tue, Jan 24, 2017 at 9:01 AM, Christian Borntraeger
> <borntraeger@de.ibm.com> wrote:
>> Chris,
>>
>> since my bug report about this did not result in any fix and since
> 
> It was fixed and the fix landed in 4.10-rc4:

Thanks, I missed that last pull.

> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=781feef7e6befafd4d9787d1f7ada1f9ccd504e4
> 
>> this disables lockdep before the the code that I want to debug runs
>> here is my attempt to fix it.
>> Please double check if the subclass looks right. It seems to work
>> for me but I do not know enough about btrfs to decide if this is
>> right or not.
>>
>> Christian Borntraeger ():
>>   btrfs: add lockdep annotation for btrfs_log_inode
>>
>>  fs/btrfs/tree-log.c    | 2 +-
>>
>> --
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 

