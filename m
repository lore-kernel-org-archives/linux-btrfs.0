Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37750 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752643AbcITAMv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 20:12:51 -0400
Subject: Re: [RFC] Preliminary BTRFS Encryption
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>,
        <dsterba@suse.cz>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160916084958.GA933@twin.jikos.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <a7612c6e-00cd-29cd-e843-a60586d6c408@fb.com>
Date: Mon, 19 Sep 2016 20:12:26 -0400
MIME-Version: 1.0
In-Reply-To: <20160916084958.GA933@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/16/2016 04:49 AM, David Sterba wrote:
> On Tue, Sep 13, 2016 at 09:39:46PM +0800, Anand Jain wrote:
>> This patchset adds btrfs encryption support.
>>
>> The main objective of this series is to have bugs fixed and stability.
>> I have verified with fstests to confirm that there is no regression.
>>
>> A design write-up is coming next,
>
> You're approaching it from the wrong side. The detailed specification
> must come first.

Hi Anand,

Thanks for sending these out.  It's an important feature and I'm glad to 
see it getting some love.

Right now, the design doc is really the most important part.  The 
encryption side of things requires a layer of extra verification that we 
can't get from reviewing the code alone.  We need to sit down with the 
use cases and the workflow and make sure it meets all the requirements 
of a secure system.

I'm the first to admit this needs a broader consensus than just 
linux-btrfs@, and we want our reviewers to be able to go through things 
without also having to understand every line of btrfs.

I do want to make sure that we can send/recv signed and encrypted 
subvolumes, and be able to send them again unmodified.  This will end up 
needing a revision of the send/recv protocol, but it adds a use case 
wrinkle that we need to iron out in the design docs.

I still prefer encryption at the subvolume level, but it's going to need 
to be a superset of what is already possible with the vfs interfaces. 
If we can do it with the existing interfaces, great.  If not we should 
be adding features into the generic code where it makes sense.

-chris
