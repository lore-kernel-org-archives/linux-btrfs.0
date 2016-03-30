Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59346 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbcC3WK1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 18:10:27 -0400
Message-ID: <56FC4EC8.9090700@osg.samsung.com>
Date: Wed, 30 Mar 2016 23:10:16 +0100
From: Luis de Bethencourt <luisbg@osg.samsung.com>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] btrfs: avoid overflowing f_bfree
References: <1459371219-1815-1-git-send-email-luisbg@osg.samsung.com> <1459371219-1815-2-git-send-email-luisbg@osg.samsung.com> <CAL3q7H7fFg0UNL_hR=rUpbGmFpM2QHK+ME4_NMn3zB4vuJYMcA@mail.gmail.com>
In-Reply-To: <CAL3q7H7fFg0UNL_hR=rUpbGmFpM2QHK+ME4_NMn3zB4vuJYMcA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 30/03/16 22:48, Filipe Manana wrote:
> On Wed, Mar 30, 2016 at 9:53 PM, Luis de Bethencourt
> <luisbg@osg.samsung.com> wrote:
>> Since mixed block groups accounting isn't byte-accurate and f_bree is an
>> unsigned integer, it could overflow. Avoid this.
>>
>> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
>> Suggested-by: David Sterba <dsterba@suse.com>
>> ---
>>  fs/btrfs/super.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index bdca79c..93376d0 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -2101,6 +2101,11 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>>         /* Account global block reserve as used, it's in logical size already */
>>         spin_lock(&block_rsv->lock);
>>         buf->f_bfree -= block_rsv->size >> bits;
> 
> You forgot to remove the line above, didn't you?
> 

Shoot! Indeed I did, sorry. Thanks for noticing.

Sending version 2.

Luis

>> +       /* Mixed block groups accounting is not byte-accurate, avoid overflow */
>> +       if (buf->f_bfree >= block_rsv->size >> bits)
>> +               buf->f_bfree -= block_rsv->size >> bits;
>> +       else
>> +               buf->f_bfree = 0;
>>         spin_unlock(&block_rsv->lock);
>>
>>         buf->f_bavail = div_u64(total_free_data, factor);
>> --
>> 2.5.3
>>
>> --

