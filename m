Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14343 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754185AbbFKRQv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 13:16:51 -0400
Message-ID: <5579C26A.4040203@fb.com>
Date: Thu, 11 Jun 2015 13:16:26 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: use received_uuid of parent during send
References: <1433452645-7904-1-git-send-email-jbacik@fb.com> <20150611170942.GK18226@carfax.org.uk>
In-Reply-To: <20150611170942.GK18226@carfax.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/11/2015 01:09 PM, Hugo Mills wrote:
> On Thu, Jun 04, 2015 at 05:17:25PM -0400, Josef Bacik wrote:
>> Neil Horman pointed out a problem where if he did something like this
>>
>> receive A
>> snap A B
>> change B
>> send -p A B
>>
>> and then on another box do
>>
>> recieve A
>> receive B
>>
>> the receive B would fail because we use the UUID of A for the clone sources for
>> B.  This makes sense most of the time because normally you are sending from the
>> original sources, not a received source.  However when you use a recieved subvol
>> its UUID is going to be something completely different, so if you then try to
>> receive the diff on a different volume it won't find the UUID because the new A
>> will be something else.  The only constant is the received uuid.  So instead
>> check to see if we have received_uuid set on the root, and if so use that as the
>> clone source, as btrfs receive looks for matches either in received_uuid or
>> uuid.  Thanks,
>
>     While this deals with Neil's problem, there's a few other use-cases
> that people have been asking for that (I think) it won't deal with.
>
>     I think ultimately we should be sending all three of the parent
> UUID, the parent's Received UUID (if it exists), and the parent's
> Parent UUID. That would have to go in the FARv2 update, though.
>
>     However, since this patch doesn't rule out the above happening at
> some future date, and I think it'll do the job as described above,
>

Yeah I'd like to send more information so we can better find the UUID 
we're looking for, but I think at least trying to keep a consistent UUID 
we carry around would be good.  Received UUID mostly accomplishes this, 
I'd like to know what other use cases aren't working so we can think 
about what we need to do for them.  Thanks,

Josef

