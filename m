Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18679 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750882AbcFQOal (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 10:30:41 -0400
Date: Fri, 17 Jun 2016 10:30:26 -0400
From: Chris Mason <clm@fb.com>
To: David Sterba <dsterba@suse.cz>
CC: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: [PATCH] Btrfs: track transid for delayed ref flushing
Message-ID: <20160617143024.GA68324@clm-mbp.thefacebook.com>
References: <1460410660-17430-1-git-send-email-jbacik@fb.com>
 <20160427135938.pczv7f4ulrvwehqp@floor.thefacebook.com>
 <20160427222951.GO29353@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <20160427222951.GO29353@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 28, 2016 at 12:29:52AM +0200, David Sterba wrote:
>On Wed, Apr 27, 2016 at 09:59:38AM -0400, Chris Mason wrote:
>> > @@ -2854,9 +2855,16 @@ static void delayed_ref_async_start(struct btrfs_work *work)
>> >
>> >  	async = container_of(work, struct async_delayed_refs, work);
>> >
>> > -	trans = btrfs_join_transaction(async->root);
>> > +	trans = btrfs_attach_transaction(async->root);
>> >  	if (IS_ERR(trans)) {
>> > -		async->error = PTR_ERR(trans);
>> > +		if (PTR_ERR(trans) != -ENOENT)
>> > +			async->error = PTR_ERR(trans);
>> > +		goto done;
>> > +	}
>>
>> This ends up deadlocking because btrfs_attach_transaction waits in ways
>> that join does not.  The differences between these two are really
>> subtle, and we manage to make this mistake every year or so.
>>
>> Subject: [PATCH] btrfs: fix deadlock in delayed_ref_async_start
>>
>> "Btrfs: track transid for delayed ref flushing" was deadlocking on
>> btrfs_attach_transaction because its not safe to call from the async
>> delayed ref start code.  This commit brings back btrfs_join_transaction
>> instead and checks for a blocked commit.
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>> Signed-off-by: Chris Mason <clm@fb.com>
>
>This patch seems to be an incremental but I don't see the original patch
>from Josef merged anywhere (I haven't picked it to for-next yet), are
>you going to commit both?

Yeah, I'll pull both in.  Thanks!

-chris
