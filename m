Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47980 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1948017AbdDYOaV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Apr 2017 10:30:21 -0400
Subject: Re: [PULL] Btrfs, qgroup message level adjustment, for 4.11-rc8
To: <dsterba@suse.cz>, David Sterba <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>
References: <cover.1492598707.git.dsterba@suse.com>
 <20170425142102.GP22319@twin.jikos.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <4f497028-e253-b0ce-9b4a-2c491ce5befe@fb.com>
Date: Tue, 25 Apr 2017 10:28:47 -0400
MIME-Version: 1.0
In-Reply-To: <20170425142102.GP22319@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/25/2017 10:21 AM, David Sterba wrote:
> On Wed, Apr 19, 2017 at 12:51:03PM +0200, David Sterba wrote:
>> Hi,
>>
>> a single-patch pull request, the qgroup use can trigger an underflow warning
>> frequently. The warning is for debugging and should not be in the final release
>> of 4.11 as we won't be able to fix it.

Sigh, I looked for this pull after you mentioned it last week, couldn't 
find it and assumed you held off.  Sorry, maybe Josef has the right idea 
ditching exchange.

I'll send today.

-chris

