Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55161 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757630AbcIHM66 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Sep 2016 08:58:58 -0400
Subject: Re: lockdep warning in btrfs in 4.8-rc3
To: Christian Borntraeger <borntraeger@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20160826233624.jao5mztbxhjikm7e@floor.thefacebook.com>
 <6a3eed93-fb4d-817a-6a59-7e7f91c8ea6d@de.ibm.com>
 <624b2c3a-5030-3f7f-70d6-4507308d785b@de.ibm.com>
From: Chris Mason <clm@fb.com>
Message-ID: <d42383bb-399f-1794-3574-dc83c959b02b@fb.com>
Date: Thu, 8 Sep 2016 08:58:48 -0400
MIME-Version: 1.0
In-Reply-To: <624b2c3a-5030-3f7f-70d6-4507308d785b@de.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/08/2016 07:50 AM, Christian Borntraeger wrote:
> On 09/08/2016 01:48 PM, Christian Borntraeger wrote:
>> Chris,
>>
>> with 4.8-rc3 I get the following on an s390 box:
>
> Sorry for the noise, just saw the fix in your pull request.
>

The lockdep splat is still there, we'll need to annotate this one a little.

-chris
