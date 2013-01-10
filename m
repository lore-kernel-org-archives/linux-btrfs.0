Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14297 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932720Ab3AJDXk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Jan 2013 22:23:40 -0500
Message-ID: <50EE345F.1090600@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 11:24:15 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: dsterba@suse.cz
CC: Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Kamal Mostafa <kamal@canonical.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH RESEND] vfs: re-implement writeback_inodes_sb(_nr)_if_idle()
 and rename them
References: <50D2E3DF.4010105@cn.fujitsu.com> <20121228143338.GW14116@twin.jikos.cz>
In-Reply-To: <20121228143338.GW14116@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 28 Dec 2012 15:33:38 +0100, David Sterba wrote:
> On Thu, Dec 20, 2012 at 06:09:35PM +0800, Miao Xie wrote:
>> --- a/fs/fs-writeback.c
>> +++ b/fs/fs-writeback.c
>> @@ -1314,7 +1314,6 @@ void writeback_inodes_sb_nr(struct super_block *sb,
>>  	bdi_queue_work(sb->s_bdi, &work);
>>  	wait_for_completion(&done);
>>  }
>> -EXPORT_SYMBOL(writeback_inodes_sb_nr);
> 
> Why do you remove the export? writeback_inodes_sb is exported as well.

As you said below, there is no user now.

> Originally the _nr variant has been introduced for btrfs
> (3259f8bed2f0f57c2fdcdac1b510c3fa319ef97e) and there are no other users
> now, so from that point it would make sense. From the other side, the
> change is not strictly necessary for this patch and keeps the writeback
> API a bit more flexible. I vote for keeping it.

Maybe you are right, I'll send out a new one.

> Otherwise (for the btrfs part),
> Tested-by: David Sterba <dsterba@suse.cz>

Thanks for your test and review.
Miao

