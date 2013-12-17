Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60540 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab3LQBKR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 20:10:17 -0500
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 46B1B3EE1E4
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 10:10:16 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 01C1745DEC7
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 10:10:16 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.nic.fujitsu.com [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 73C9345DEBA
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 10:10:15 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 28B48E18035
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 10:10:15 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id CE5C1E18039
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 10:10:14 +0900 (JST)
Message-ID: <52AFA469.1070800@jp.fujitsu.com>
Date: Tue, 17 Dec 2013 10:10:01 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix error check of btrfs_lookup_dentry()
References: <201312130051.AA00031@FM-323941448.jp.fujitsu.com> <20131216152730.GI6498@twin.jikos.cz>
In-Reply-To: <20131216152730.GI6498@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David,

On 2013/12/17 0:27, David Sterba wrote:
> On Fri, Dec 13, 2013 at 09:51:42AM +0900, Tsutomu Itoh wrote:
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -4974,10 +4974,17 @@ static void btrfs_dentry_release(struct dentry *dentry)
>>   static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
>>   				   unsigned int flags)
>>   {
>> -	struct dentry *ret;
>> +	struct inode *inode;
>>
>> -	ret = d_splice_alias(btrfs_lookup_dentry(dir, dentry), dentry);
>> -	return ret;
>> +	inode = btrfs_lookup_dentry(dir, dentry);
>> +	if (IS_ERR(inode)) {
>> +		if (PTR_ERR(inode) == -ENOENT)
>> +			inode = NULL;
>> +		else
>> +			return ERR_CAST(inode);
>> +	}
>> +
>> +	return d_splice_alias(inode, dentry);
>
> btrfs_lookup used to be a simple d_splice_alias(btrfs_lookup_dentry ...)
> and the expanded back and forth with the DCACHE_NEED_LOOKUP flag.
>
> a66e7cc626f42de6c745963fe0d807518fa49d39 added
> 39e3c9553f34381a1b664c27b0c696a266a5735e removed
>
> d_splice_alias has been made robust in
> a9049376ee05bf966bfe2b081b5071326856890a
> "make d_splice_alias(ERR_PTR(err), dentry) = ERR_PTR(err)"
>
> you can drop the error handling from btrfs_lookup completely.

d_splice_alias() is called by the following formats if btrfs_lookup_dentry()
returns NULL before my patch is applied.
   d_splice_alias(NULL, dentry);
However, d_splice_alias() is called by the following formats when
becoming the same situation after my patch is applied.
   d_splice_alias(-ENOENT, dentry);

Therefore, I added the following error handling code.
+       if (IS_ERR(inode)) {
+               if (PTR_ERR(inode) == -ENOENT)
+                       inode = NULL;
+               else
+                       return ERR_CAST(inode);
+       }

Thanks,
Tsutomu

>
> The rest looks ok.
>
>


