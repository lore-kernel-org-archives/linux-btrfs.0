From: Josef Bacik <josef@redhat.com>
Subject: Re: PLEASE TEST: Everybody who is seeing weird and long hangs
Date: Mon, 01 Aug 2011 12:03:34 -0400
Message-ID: <4E36CE56.1060206@redhat.com>
References: <4E36C47E.70309@redhat.com> <1312213264-sup-9624@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312213264-sup-9624@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/01/2011 11:45 AM, Chris Mason wrote:
> Excerpts from Josef Bacik's message of 2011-08-01 11:21:34 -0400:
>> Hello,
>>
>> We've seen a lot of reports of people having these constant long pauses
>> when doing things like sync or such.  The stack traces usually all look
>> the same, one is btrfs-transaction stuck in btrfs_wait_marked_extents
>> and one is btrfs-submit-# stuck in get_request_wait.  I had originally
>> thought this was due to the new plugging stuff, but I think it just
>> makes the problem happen more quickly as we've seen that 2.6.38 which we
>> thought was ok will still have the problem happen if given enough time.
>>
>> I _think_ this is because of the way we write out metadata in the
>> transaction commit phase.  We're doing write_on_page for every dirty
>> page in the btree during the commit.  This sucks because basically we
>> end up with one bio per page, which makes us blow out our nr_requests
>> constantly, which is why btrfs-submit-# is always stuck in
>> get_request_wait.  What we need to do instead is use filemap_fdatawrite
>> which will do a WB_SYNC_ALL but will do it via writepages, so hopefully
>> we will get less bios and this problem will go away.  Please try this
>> very hastily put together patch if you are experiencing this problem and
>> let me know if it fixes it for you.  Thanks,
> 
> I'm definitely curious to hear if this helps, but I think it might cause
> a different set of problems.  It writes everything that is dirty on the
> btree, which includes a lot of things we've cow'd in the current
> transaction and marked dirty.  They will have to go through COW again
> if someone wants to modify them again.
> 

But this is happening in the commit after we've done all of our work, we
shouldn't be dirtying anything else at this point right?

> The btrfs writepage code does this:
> 
>         ret = __extent_writepage(page, wbc, &epd);
> 
>         extent_write_cache_pages(tree, mapping, &wbc_writepages,
>                                  __extent_writepage, &epd, flush_write_bio);
>         flush_epd_write_bio(&epd);
> 

Yeah but nr_to_write is 1, so after the __extent_writepage it will be 0
and extent_write_cache_pages will just return since there's nothing to
write, so we'll still end up with 1 page at a time being written out.
Thanks,

Josef
