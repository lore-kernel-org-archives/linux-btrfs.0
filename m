From: Josef Bacik <josef@redhat.com>
Subject: Re: Btrfs bug with g38867a2 and a question
Date: Thu, 22 Sep 2011 10:12:12 -0400
Message-ID: <4E7B423C.2080007@redhat.com>
References: <20110921185350.GA6618@kashmir> <4E7A4695.9080106@redhat.com> <20110921231055.GN22205@twin.jikos.cz> <CALiWzOg8CQJF7OfMex1uJTa+doDZ8oufV1nAbos99Z4ev-+xKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mathieu Chouquet-Stringer <mathieu@csetco.com>, dave@jikos.cz,
	linux-btrfs@vger.kernel.org
To: Mathieu Chouquet-Stringer <mathieucs@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CALiWzOg8CQJF7OfMex1uJTa+doDZ8oufV1nAbos99Z4ev-+xKg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/22/2011 02:05 AM, Mathieu Chouquet-Stringer wrote:
> 
> On Sep 22, 2011 1:11 AM, "David Sterba" <dave@jikos.cz
> <mailto:dave@jikos.cz>> wrote:
>>
>> On Wed, Sep 21, 2011 at 04:18:29PM -0400, Josef Bacik wrote:
>> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> > index b128fa0..66ba0a7 100644
>> > --- a/fs/btrfs/inode.c
>> > +++ b/fs/btrfs/inode.c
>> > @@ -782,7 +782,12 @@ static noinline int cow_file_range(struct inode
> *inode,
>> >       struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
>> >       int ret = 0;
>> >
>> > -     BUG_ON(btrfs_is_free_space_inode(root, inode));
>> > +     if (btrfs_is_free_space_inode(root, inode)) {
>> > +             printk(KERN_ERR "trying to write to free space inode, "
>> > +                    "isize=%Lu, start=%Lu, end=%Lu\n",
> i_size_read(inode),
>> > +                    start, end);
>>
>> please prefix printk messages with "btrfs: "
> 
> Well this time it doesn't boot anymore...
> Bug at fs/btrfs/free-space-cache.c:1327
> 
> I had another crash before being able to reboot...
> 
> Is there a way to recover from that? How do I disable space cache?
> 

Well that is from the tree logging code, so give this a whirl.  It's
going to dump a lot of info so make sure you capture everything before
the --- cut here --- line.  Thanks,

Josef


diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 1bcbe76..236a938 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -417,6 +417,8 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 			}

 			if (entry->type == BTRFS_FREE_SPACE_EXTENT) {
+				printk(KERN_ERR "adding extent [%llu-%llu]\n",
+				       e->offset, e->bytes);
 				spin_lock(&block_group->tree_lock);
 				ret = link_free_space(block_group, e);
 				spin_unlock(&block_group->tree_lock);
@@ -431,6 +433,8 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 					page_cache_release(page);
 					goto free_cache;
 				}
+				printk(KERN_ERR "adding bitmap [%llu-%llu]\n",
+				       e->offset, e->bytes);
 				spin_lock(&block_group->tree_lock);
 				ret = link_free_space(block_group, e);
 				block_group->total_bitmaps++;
