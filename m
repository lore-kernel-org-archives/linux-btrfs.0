From: Josef Bacik <josef@redhat.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:149!
Date: Mon, 23 May 2011 15:51:57 -0400
Message-ID: <4DDABADD.7090209@redhat.com>
References: <201105051954.48405.whirm@gmx.com> <201105161701.11645.truewhirm@yahoo.es> <4DD150C1.2090505@redhat.com> <201105231357.41588.whirm@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Elric Milon <whirm@gmx.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105231357.41588.whirm@gmx.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/23/2011 07:57 AM, Elric Milon wrote:
> On Monday 16 May 2011 18:28:49 you wrote:
>> On 05/16/2011 11:01 AM, Whirm wrote:
>>> On Monday 16 May 2011 16:11:19 Josef Bacik wrote:
> 
>>>
>>> Sorry yes, I meant this is how I managed to get the corrupted filesystem.
>>>
>>> Ill try to break it again.
>>
>> Oh ok perfect, yeah I will try and do the same sort of things and see if
>> I can get it to happen as well.  Thanks,
> 
> Great, btw, I tried to see if I can mount the corrupted filesystem with 
> the patch you told me about applied, and it fails, here's the log:
> 
> http://pastebin.com/raw.php?i=4Kfv927B
> 
> That happens using 2.6.39-rc7+ from git with the following patch applied (its 
> the debug patch and the possible fix you told me about):
> 

Ok so this is a different kind of corruption, wooo!  Can you apply this
debug patch and get me the output so we can try and fix this bit?  Thanks,

Josef


diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index cd5e82e..54a8df5 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -365,6 +365,9 @@ next_slot:
 			extent_end = key.offset +
 				btrfs_file_extent_inline_len(leaf, fi);
 		} else {
+			printk(KERN_ERR "Weird entry at slot=%d, type=%lu\n",
+			       path->slots[0], extent_type);
+			btrfs_print_leaf(root, leaf);
 			WARN_ON(1);
 			extent_end = search_start;
 		}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index dc8fb2b..f951053 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -145,6 +145,9 @@ static noinline int insert_inline_extent(struct
btrfs_trans_handle *trans,
 	inode_add_bytes(inode, size);
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
 				      datasize);
+	if (ret)
+		printk(KERN_ERR "ret=%d, inode=%d, start=%llu, size=%llu\n",
+		       ret, inode->i_ino, start, size);
 	BUG_ON(ret);
 	if (ret) {
 		err = ret;
