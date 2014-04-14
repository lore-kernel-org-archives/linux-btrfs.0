Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14049 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750770AbaDNDfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Apr 2014 23:35:54 -0400
Message-ID: <534B57D5.9070901@cn.fujitsu.com>
Date: Mon, 14 Apr 2014 11:36:53 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Chris Mason <clm@fb.com>, <linux-btrfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC] odd thing in btrfs_file_aio_write()
References: <20140414002625.GQ18016@ZenIV.linux.org.uk> <534B495C.6060504@cn.fujitsu.com> <20140414024830.GR18016@ZenIV.linux.org.uk>
In-Reply-To: <20140414024830.GR18016@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [RFC] odd thing in btrfs_file_aio_write()
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年04月14日 10:48
> On Mon, Apr 14, 2014 at 10:35:08AM +0800, Qu Wenruo wrote:
>> Oh, that's my fault, I forgot that iov can be chained.
>>
>> I should use 'pos + count' instead.
> BTW, will there be any difference if 10Mb write starts one byte before EOF?
This will not be a problem, since btrfs will not update the inode size 
until the data is written.
So this behavior will not cause empty gap.
> IOW, is that if (start_pos > i_size_read(inode)) { in there correct
> these days?  And what'll happen if we hit e.g. an unmapped page in the
> middle of the data being written?  That will result in short write, but
> will it truncate what's left of that dummy range?
I'm very sorry for my poor that I could not understand the question well.
Would you please explain what does the "unmapped page" means?

Did you mean two noncontinuous iovecs?
If you did mean that, it seems that I should expand the end_pos to the 
end of the iovec...

Thanks,
Qu
