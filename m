From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: set no_trans_join after trying to expand the transaction
Date: Wed, 15 Jun 2011 10:40:17 -0400
Message-ID: <4DF8C451.4060000@redhat.com>
References: <1308083139-23734-1-git-send-email-josef@redhat.com> <4DF8C353.9090301@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Jim Schutt <jaschut@sandia.gov>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DF8C353.9090301@sandia.gov>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/15/2011 10:36 AM, Jim Schutt wrote:
> 
> Josef Bacik wrote:
>> We can lockup if we try to allow new writers join the transaction and
>> we have
>> flushoncommit set or have a pending snapshot.  This is because we set
>> no_trans_join and then loop around and try to wait for ordered extents
>> again.
>> The problem is the ordered endio stuff needs to join the transaction,
>> which it
>> can't do because no_trans_join is set.  So instead wait until after
>> this loop to
>> set no_trans_join and then make sure to wait for num_writers == 1 in case
>> anybody got started in between us exiting the loop and setting
>> no_trans_join.
>> This could easily be reproduced by mounting -o flushoncommit and
>> running xfstest
>> 13.  It cannot be reproduced with this patch.  Thanks,
> 
> FWIW, this version of the patch works fine for me
> as well.
> 

Great, thanks for testing.

Josef
