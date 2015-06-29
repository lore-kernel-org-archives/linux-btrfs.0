Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36830 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbbF2LQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 07:16:30 -0400
Received: by wguu7 with SMTP id u7so138413385wgu.3
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 04:16:29 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Subject: Re: [PATCH] check: check so offset is not bigger then the leaf
From: Trollkarlen Marklund <robbelibobban@gmail.com>
In-Reply-To: <20150618164443.GH6761@twin.jikos.cz>
Date: Mon, 29 Jun 2015 14:16:28 +0300
Cc: linux-btrfs@vger.kernel.org
Message-Id: <3FC07E8E-F789-4C2A-9099-F649EFADCD1F@gmail.com>
References: <1434585553-8697-1-git-send-email-robbelibobban@gmail.com> <20150618164443.GH6761@twin.jikos.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On 18 Jun 2015, at 19:44, David Sterba <dsterba@suse.cz> wrote:
> 
> On Thu, Jun 18, 2015 at 01:59:13AM +0200, Robert Marklund wrote:
>> This could crash before because of dangerous dangling
>> offset of pointer.
> 
> That's right, this can happen. There are more btrfs_item_ptr that would
> be good to validate that way, namely in the checker as it's most likely
> to see corrupted data.
> 
> I think it's worth to add a wrapper macro for that, that would be like
> 
> (int) btrfs_item_ptr_validate(ei, leaf, slot, struct ..., *optional_key)
> 
> and return 0 if it's ok, 1 if there's a problem and prints the details.
> 
>> Signed-off-by: Robert Marklund <robbelibobban@gmail.com>
>> ---
>> cmds-check.c | 10 ++++++++++
>> 1 file changed, 10 insertions(+)
>> 
>> diff --git a/cmds-check.c b/cmds-check.c
>> index 778f141..da36758 100644
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -8906,6 +8906,16 @@ static int build_roots_info_cache(struct btrfs_fs_info *info)
>> 			goto next;
>> 
>> 		ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
>> +
>> +		if ((long long)ei > info->extent_root->leafsize) {
>> +			 fprintf(stderr, "Bad leaf = %p, slot = %d\n", leaf, slot);
>> +			 fprintf(stderr, "item ptr = %p\n", ei);
>> +			 fprintf(stderr, "objectid = %llx\n", found_key.objectid);
>> +			 fprintf(stderr, "type     = %x\n", found_key.type);
>> +			 fprintf(stderr, "offset   = %llx\n", found_key.offset);
> 
> Hm, I'm not sure whether to continue or fail at this point.
> 

Im not either :)
But for me its better to keep trying until you hot the wall for real.


> Do you have a crafted filesystem image that can reproduce that or was
> that found by code inspection?

I have a failed filesystem caused by a failing disk that I tried to fix/recover.
Then i stumbled on this, and later on on some more places other then this.
Ill submit that also and in a nicer way when my filesystem is rescued. 
 

> 
>> +			 goto next;
>> +		}
>> +
>> 		flags = btrfs_extent_flags(leaf, ei);
>> 
>> 		if (found_key.type == BTRFS_EXTENT_ITEM_KEY &&

