Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:50146 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759434AbcHEKag (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Aug 2016 06:30:36 -0400
Received: from tux.wizards.de (p579D0472.dip0.t-ipconnect.de [87.157.4.114])
	by mail02.iobjects.de (Postfix) with ESMTPSA id BCBA3416030A
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Aug 2016 12:29:01 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.wizards.de [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id 6025F11C01D7
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Aug 2016 12:29:01 +0200 (CEST)
Subject: Re: [PATCH] Btrfs: check btree node's nritems
To: linux-btrfs@vger.kernel.org
References: <1470254248-24041-1-git-send-email-bo.li.liu@oracle.com>
 <pan$98570$4794547a$be51fd77$d2061e3b@applied-asynchrony.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <57A46A6D.4060605@applied-asynchrony.com>
Date: Fri, 5 Aug 2016 12:29:01 +0200
MIME-Version: 1.0
In-Reply-To: <pan$98570$4794547a$be51fd77$d2061e3b@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/05/16 11:24, Holger Hoffstätte wrote:
> On Wed, 03 Aug 2016 12:57:28 -0700, Liu Bo wrote:
> 
>> When btree node (level = 1) has nritems which equals to zero,
>> we can end up with panic due to insert_ptr()'s
>>
>> BUG_ON(slot > nritems);
>>
>> where slot is 1 and nritems is 0, as copy_for_split() calls
>> insert_ptr(.., path->slots[1] + 1, ...);
>>
>> A invalid value results in the whole mess, this adds the check
>> for btree's node nritems so that we stop reading block when
>> when something is wrong.
>>
>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>> ---
>>  fs/btrfs/disk-io.c | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 37d1780..a5a22be 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -612,6 +612,20 @@ static noinline int check_leaf(struct btrfs_root *root,
>>  	return 0;
>>  }
>>  
>> +static noinline int check_node(struct btrfs_root *root,
>> +			       struct extent_buffer *node)
>> +{
>> +	unsigned long nr = btrfs_header_nritems(node);
>> +
>> +	if (nr <= 0 || nr >= BTRFS_NODEPTRS_PER_BLOCK(root)) {
>> +		btrfs_crit(root->fs_info,
>> +			   "corrupt node: block %llu root %llu nritems %lu\n",
> 
> I think the trailing \n can be dropped here, btrfs_crit() already provides
> a proper newline.

On top of that I get a whole bunch of false positives with this patch.
Files that are perfectly readable without it now error out, in which
case the logged nritems is always 493 - regardless of file or containing
subvolume. Something is fishy here.

-h

