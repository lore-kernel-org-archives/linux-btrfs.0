From: "Yan Zheng" <yanzheng@21cn.com>
Subject: Re: Need some help with a backref problem
Date: Fri, 17 Oct 2008 09:48:58 +0800
Message-ID: <3d0408630810161848w294373a7ud0297274c9cde5c7@mail.gmail.com>
References: <20081016205412.GE2864@unused.rdu.redhat.com>
	 <20081017004323.GF2864@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Josef Bacik" <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081017004323.GF2864@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

2008/10/17 Josef Bacik <jbacik@redhat.com>:
> On Thu, Oct 16, 2008 at 04:54:12PM -0400, Josef Bacik wrote:
>> Hello,
>>
>> Its the end of the day here and I haven't figured this out, so hopefully Yan you
>> can figure this out and I can come in tomorrow and keep working on taking
>> alloc_mutex out :).  What is happening is I'm getting -ENOENT from
>> lookup_extent_backref in finish_current_insert() when extent_op->type ==
>> PENDING_BACKREF_UPDATE.  The way I have locking is that the only way this can
>> happen is if we delete the extent backref completely, and then do
>> btrfs_update_ref.  I put a lookup_extent_backref in __btrfs_update_extent_ref
>> and did a BUG_ON(ret), and it gave me this backtrace
>>

I guess there are two or more threads running finish_current_insert at the same
time. (find_first_extent_bit vs clear_extent_bits race)

>>  [<ffffffffa035ecac>] ? btrfs_update_ref+0x2ce/0x322 [btrfs]
>>  [<ffffffffa034f859>] ? insert_ptr+0x176/0x184 [btrfs]
>>  [<ffffffffa0354615>] ? split_node+0x54a/0x5b3 [btrfs]
>>  [<ffffffffa03555af>] ? btrfs_search_slot+0x4ef/0x7aa [btrfs]
>>  [<ffffffff8109a1ad>] ? check_bytes_and_report+0x37/0xc9
>>  [<ffffffff8109a1ad>] ? check_bytes_and_report+0x37/0xc9
>>  [<ffffffffa0355da7>] ? btrfs_insert_empty_items+0x7d/0x43b [btrfs]
>>  [<ffffffffa03561b4>] ? btrfs_insert_item+0x4f/0xa4 [btrfs]
>>  [<ffffffffa0358ef6>] ? finish_current_insert+0xfc/0x2b5 [btrfs]
>>  [<ffffffff8109a832>] ? init_object+0x27/0x6e
>>  [<ffffffffa035a77b>] ? __btrfs_alloc_reserved_extent+0x37d/0x3dc [btrfs]
>>  [<ffffffffa035aa26>] ? btrfs_alloc_reserved_extent+0x2b/0x5b [btrfs]
>>  [<ffffffffa036accf>] ? btrfs_finish_ordered_io+0x21b/0x344 [btrfs]
>>  [<ffffffffa037a782>] ? end_bio_extent_writepage+0x9b/0x172 [btrfs]
>>  [<ffffffffa037fe51>] ? worker_loop+0x42/0x125 [btrfs]
>>  [<ffffffffa037fe0f>] ? worker_loop+0x0/0x125 [btrfs]
>>  [<ffffffff81046721>] ? kthread+0x47/0x76
>>  [<ffffffff8100cd59>] ? child_rip+0xa/0x11
>>  [<ffffffff810466da>] ? kthread+0x0/0x76
>>  [<ffffffff8100cd4f>] ? child_rip+0x0/0x11
>>
>> And I also put in some printk's to figure out when exactly this was happening,
>> and it happens in split_node() when c == root->node, so we do an
>> insert_new_root.  My first reaction was to put a c = path->nodes[level] after
>> the insert_new_root, but looking at it thats just going to give me the same
>> thing back.  I can't figure out if I'm doing something wrong or if there is
>> something wonky with the backref stuff, and what is even more worriesome is that
>> I can't figure out why having alloc_mutex in there kept this problem from
>> happenign before, since the way this happens doesn't have anything to do with
>> alloc_mutex.  All help is appreciated, even random thinking outloud, hopefully
>> we can figure out what is going on and I can finish ripping alloc_mutex out.
>> Thanks,
>>
>
> Ok I think I figured it out, we need to have a
>
> c = root->node;
>
> after the insert_new_root, since we will have free'd the old extent buffer and
> replaced it with a new one.  Does that sound right?  Thanks,
>

I don't think so. If we do this, we will end up spliting the new root.

Regards
Yan Zheng
