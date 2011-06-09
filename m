From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v2] btrfs: scrub: errors in tree enumeration
Date: Thu, 09 Jun 2011 08:46:47 +0200
Message-ID: <4DF06C57.1010203@gmx.net>
References: <1307522322-20381-1-git-send-email-sensille@gmx.net> <4DEF7DB3.2090902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DEF7DB3.2090902@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08.06.2011 15:48, Josef Bacik wrote:
> On 06/08/2011 04:38 AM, Arne Jansen wrote:
>> due to the semantics of btrfs_search_slot the path can point to an
>> invalid slot when ret > 0. This condition went unnoticed, which in
>> turn could have led to an incomplete scrubbing.
>>
>> Signed-off-by: Arne Jansen <sensille@gmx.net>
>> ---
>>
>> Change in v2:
>> fix return value of scrub_enumerate_chunks
>>
>> ---
>>  fs/btrfs/scrub.c |   29 ++++++++++++++++++-----------
>>  1 files changed, 18 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>> index df50fd1..c4f3a2b 100644
>> --- a/fs/btrfs/scrub.c
>> +++ b/fs/btrfs/scrub.c

>> @@ -1116,9 +1119,13 @@ int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
>>  		btrfs_release_path(path);
>>  	}
>>  
>> -out:
>>  	btrfs_free_path(path);
>> -	return ret;
>> +
>> +	/*
>> +	 * ret can still be 1 from search_slot or next_leaf,
>> +	 * that's not an error
>> +	 */
>> +	return ret < 0 ? ret : 0;
> 
> Why not just set ret to 0 if you have to do a btrfs_next_leaf?  Thanks,

I tried, but that looks stupid, to. I then have the same test, but only
after btrfs_next_leaf.

-Arne

> 
> Josef
