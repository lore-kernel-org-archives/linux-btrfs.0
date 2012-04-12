From: Jan Schmidt <mail@jan-o-sch.net>
Subject: Re: [PATCH 3/3] btrfs: extended inode refs
Date: Thu, 12 Apr 2012 20:38:18 +0200
Message-ID: <4F87211A.9070905@jan-o-sch.net>
References: <1333656543-4843-1-git-send-email-mfasheh@suse.de> <1333656543-4843-4-git-send-email-mfasheh@suse.de> <4F871808.3050309@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mark Fasheh <mfasheh@suse.de>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F871808.3050309@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 12.04.2012 19:59, Jan Schmidt wrote:
>> -static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
>> -				struct btrfs_path *path,
>> -				iterate_irefs_t *iterate, void *ctx)
>> +static int iterate_inode_refs(u64 inum, struct btrfs_root *fs_root,
>> +			      struct btrfs_path *path,
>> +			      iterate_irefs_t *iterate, void *ctx)
> 
> This function must not call free_extent_buffer(eb) in line 1306 after
> applying your patch set (immediately before the break). Second, I think
> we'd better add a blocking read lock on eb after incrementing it's
> refcount, because we need the current content to stay as it is. Both
> isn't part of your patches, but it might be easier if you make that
> bugfix change as a 3/4 patch within your set and turn this one into 4/4.
> If you don't like that, I'll send a separate patch for it. Don't miss
> the unlock if you do it ;-)

FYI: There are more read locks missing in the current version of
backref.c. So I made a bugfix patch myself which I'll test and send
tomorrow.

-Jan
