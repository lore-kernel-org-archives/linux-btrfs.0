Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:44225 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932834AbeF2NHW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 09:07:22 -0400
Subject: Re: [PATCH 3/4] btrfs: Rename EXTENT_BUFFER_DUMMY to
 EXTENT_BUFFER_PRIVATE
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1530106705-27186-1-git-send-email-nborisov@suse.com>
 <1530106705-27186-4-git-send-email-nborisov@suse.com>
 <20180629124633.GR2287@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <97349690-b129-1b5b-17c5-4363fe2a879d@gmx.com>
Date: Fri, 29 Jun 2018 21:07:12 +0800
MIME-Version: 1.0
In-Reply-To: <20180629124633.GR2287@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年06月29日 20:46, David Sterba wrote:
> On Wed, Jun 27, 2018 at 04:38:24PM +0300, Nikolay Borisov wrote:
>> EXTENT_BUFFER_DUMMY is an awful name for this flag. Buffers which have
>> this flag set are not in any way dummy. Rather, they are private in
>> the sense that are not linked to the global buffer tree. This flag has
>> subtle implications to the way free_extent_buffer work for example, as
>> well as controls whether page->mapping->private_lock is held during
>> extent_buffer release. Pages for a private buffer cannot be under io,
>> nor can they be written by a 3rd party so taking the lock is
>> unnecessary.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  fs/btrfs/disk-io.c   |  2 +-
>>  fs/btrfs/extent_io.c | 10 +++++-----
>>  fs/btrfs/extent_io.h |  2 +-
>>  3 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 8a469f70d5ee..1c655be92690 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -4093,7 +4093,7 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
>>  	 * enabled.  Normal people shouldn't be marking dummy buffers as dirty
>>  	 * outside of the sanity tests.
>>  	 */
>> -	if (unlikely(test_bit(EXTENT_BUFFER_DUMMY, &buf->bflags)))
>> +	if (unlikely(test_bit(EXTENT_BUFFER_PRIVATE, &buf->bflags)))
> 
> This is going to be confusing. There's page Private bit,
> PAGE_SET_PRIVATE2 and EXTENT_PAGE_PRIVATE, that are somehow logically
> connected.
> 
> I'd suggest EXTENT_BUFFER_CLONED or _UNMAPPED as it's created by
> btrfs_clone_extent_buffer or used in the disconnected way (ie. without
> the mapping).

UNMAPPED looks good to me.
(Or ANONYMOUS?)

> 
>>  		return;
>>  #endif
>>  	root = BTRFS_I(buf->pages[0]->mapping->host)->root;
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 6ac15804bab1..6611207e8e1f 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -4642,7 +4642,7 @@ int extent_buffer_under_io(struct extent_buffer *eb)
>>  static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
>>  {
>>  	int i;
>> -	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
>> +	int mapped = !test_bit(EXTENT_BUFFER_PRIVATE, &eb->bflags);
>>  
>>  	BUG_ON(extent_buffer_under_io(eb));
>>  
>> @@ -4755,7 +4755,7 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
>>  	}
>>  
>>  	set_bit(EXTENT_BUFFER_UPTODATE, &new->bflags);
>> -	set_bit(EXTENT_BUFFER_DUMMY, &new->bflags);
>> +	set_bit(EXTENT_BUFFER_PRIVATE, &new->bflags);
>>  
>>  	return new;
>>  }
>> @@ -4780,7 +4780,7 @@ struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
> 
> Would be good to sync the new name with the helpers:
> __alloc_dummy_extent_buffer and alloc_dummy_extent_buffer then.
> 
>>  	}
>>  	set_extent_buffer_uptodate(eb);
>>  	btrfs_set_header_nritems(eb, 0);
>> -	set_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
>> +	set_bit(EXTENT_BUFFER_PRIVATE, &eb->bflags);
>>  
>>  	return eb;
>>  err:
>> @@ -5086,7 +5086,7 @@ static int release_extent_buffer(struct extent_buffer *eb)
>>  		/* Should be safe to release our pages at this point */
>>  		btrfs_release_extent_buffer_page(eb);
>>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>> -		if (unlikely(test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags))) {
>> +		if (unlikely(test_bit(EXTENT_BUFFER_PRIVATE, &eb->bflags))) {
>>  			__free_extent_buffer(eb);
>>  			return 1;
>>  		}
>> @@ -5117,7 +5117,7 @@ void free_extent_buffer(struct extent_buffer *eb)
>>  
>>  	spin_lock(&eb->refs_lock);
>>  	if (atomic_read(&eb->refs) == 2 &&
>> -	    test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags))
>> +	    test_bit(EXTENT_BUFFER_PRIVATE, &eb->bflags))
>>  		atomic_dec(&eb->refs);

Also discussed in off list mail, this extra atomic_dec for cloned eb
looks confusing.
(That also explains why after cloning the eb, we call
extent_buffer_get() and only frees it once, and still no eb leaking)
What about just removing such special handling?

Thanks,
Qu

>>  
>>  	if (atomic_read(&eb->refs) == 2 &&
>> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
>> index 0bfd4aeb822d..bfccaec2c89a 100644
>> --- a/fs/btrfs/extent_io.h
>> +++ b/fs/btrfs/extent_io.h
>> @@ -46,7 +46,7 @@
>>  #define EXTENT_BUFFER_STALE 6
>>  #define EXTENT_BUFFER_WRITEBACK 7
>>  #define EXTENT_BUFFER_READ_ERR 8        /* read IO error */
>> -#define EXTENT_BUFFER_DUMMY 9
>> +#define EXTENT_BUFFER_PRIVATE 9
>>  #define EXTENT_BUFFER_IN_TREE 10
>>  #define EXTENT_BUFFER_WRITE_ERR 11    /* write IO error */
>>  
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
