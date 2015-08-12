Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9630 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752850AbbHLQTB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 12:19:01 -0400
Message-ID: <55CB71E5.1070302@fb.com>
Date: Wed, 12 Aug 2015 12:18:45 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: <dsterba@suse.com>, <clm@fb.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:8113! (4.1.3 kernel)
References: <20150706212156.GY17274@merlins.org> <20150710134348.GB15535@suse.cz> <20150712010229.GA5284@merlins.org> <20150723115558.GQ6306@suse.cz> <20150724162446.GH30815@merlins.org> <20150803035130.GL24824@merlins.org> <20150811050758.GF29259@merlins.org> <55CA177D.1050004@fb.com> <20150812144749.GY24824@merlins.org> <55CB631B.2080404@fb.com> <20150812160936.GK29259@merlins.org>
In-Reply-To: <20150812160936.GK29259@merlins.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/12/2015 12:09 PM, Marc MERLIN wrote:
> On Wed, Aug 12, 2015 at 11:15:39AM -0400, Josef Bacik wrote:
>> On 08/12/2015 10:47 AM, Marc MERLIN wrote:
>>> On Tue, Aug 11, 2015 at 11:40:45AM -0400, Josef Bacik wrote:
>>>>  From a48cf7a9ae44a17d927df5542c8b0be287aee9ed Mon Sep 17 00:00:00 2001
>>>> From: Josef Bacik <jbacik@fb.com>
>>>> Date: Tue, 11 Aug 2015 11:39:37 -0400
>>>> Subject: [PATCH] Btrfs: kill BUG_ON() in btrfs_lookup_extent_info()
>>>>
>>>> Replace it with an ASSERT(0) for the developers and an error for not the
>>>> developers.
>>>
>>> Thanks. We knocked one down and now another BUG has been triggered :)
>>>
>>> 	if (unlikely(wc->refs[level - 1] == 0)) {
>>> 		btrfs_err(root->fs_info, "Missing references.");
>>> 		BUG();
>>> 	}
>>>
>>
>> This is why you got your own branch, it's never just one.  Here's
>> the next bit
>
> Yes, I figured there might be a few more :)
> Thanks for this patch, it definitely made things better:
>
> [  165.656408] BTRFS info (device dm-0): disk space caching is enabled
> [  205.528199] BTRFS error (device dm-0): Missing references.
> [  205.528216] BTRFS: error (device dm-0) in btrfs_drop_snapshot:8652: errno=-5 IO failure
> [  205.528225] BTRFS info (device dm-0): forced readonly
>
> That's perfect, thanks much for that.
>
> Now, back to check --repair, does it make sense to fix it too so that it doesn't crash either?
>
> myth:~#  btrfs check --repair /dev/mapper/crypt_sdd1
> enabling repair mode
> Checking filesystem on /dev/mapper/crypt_sdd1
> UUID: 024ba4d0-dacb-438d-9f1b-eeb34083fe49
> checking extents
> cmds-check.c:4486: add_data_backref: Assertion `back->bytes != max_size` failed.
> btrfs[0x8066a73]
> btrfs[0x8066aa4]
> btrfs[0x8067991]
> btrfs[0x806b4ab]
> btrfs[0x806b9a3]
> btrfs[0x806c5b2]
> btrfs(cmd_check+0x1088)[0x806eddf]
> btrfs(main+0x153)[0x80557c6]
> /lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xf3)[0xb75784d3]
> btrfs[0x80557ec]
>

Going to need more info to figure this one out


 From d77cd13f94fae6d995f753f3de3728c4ef4f8e75 Mon Sep 17 00:00:00 2001
From: Josef Bacik <jbacik@fb.com>
Date: Wed, 12 Aug 2015 12:18:01 -0400
Subject: [PATCH] some debugging

---
  cmds-check.c | 2 ++
  1 file changed, 2 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index dd2fce3..8f668d7 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4524,6 +4524,8 @@ static int add_data_backref(struct cache_tree 
*extent_cache, u64 bytenr,
  	if (found_ref) {
  		BUG_ON(num_refs != 1);
  		if (back->node.found_ref)
+			if (back->bytes != max_size)
+				fprintf(stderr, "wtf, parent %llu\n", (unsigned long long)parent);
  			BUG_ON(back->bytes != max_size);
  		back->node.found_ref = 1;
  		back->found_ref += 1;
-- 
2.1.0

