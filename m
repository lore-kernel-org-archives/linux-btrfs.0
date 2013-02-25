Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:25063 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759579Ab3BYEWk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Feb 2013 23:22:40 -0500
Message-ID: <512AE727.2040800@cn.fujitsu.com>
Date: Mon, 25 Feb 2013 12:23:03 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: dsterba@suse.cz, Marios Titas <redneb8888@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: update inode flags when renaming
References: <1361520691-22665-1-git-send-email-bo.li.liu@oracle.com> <CAAdM645SGn=in2xq-Gv=DBCfpxJvynQEywr5tq7sh=jt-J197A@mail.gmail.com> <20130222084034.GC12835@liubo.cn.oracle.com> <51273BB7.60504@cn.fujitsu.com> <20130222220440.GL27541@twin.jikos.cz> <20130225034959.GA3480@liubo.jp.oracle.com>
In-Reply-To: <20130225034959.GA3480@liubo.jp.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	mon, 25 Feb 2013 11:50:01 +0800, Liu Bo wrote:
> On Fri, Feb 22, 2013 at 11:04:40PM +0100, David Sterba wrote:
>> On Fri, Feb 22, 2013 at 05:34:47PM +0800, Miao Xie wrote:
>>> On 	fri, 22 Feb 2013 16:40:35 +0800, Liu Bo wrote:
>>>> On Fri, Feb 22, 2013 at 03:32:50AM -0500, Marios Titas wrote:
>>>>> Sorry, but the bug persists even with the above patch.
>>>>>
>>>>> touch test
>>>>> chattr +C test
>>>>> lsattr test
>>>>> mv test test2
>>>>> lsattr test2
>>>>>
>>>>> In the above scenario test2 will not have the C flag.
>>>>
>>>> What do you expect?  IMO it's right that test2 does not have the C flag.
>>>
>>> No, it's not right.
>>> For the users, they expect the C flag is not lost because they just do
>>> a rename operation. but fixup_inode_flags() re-sets the flags by the
>>> parent directory's flag.
>>>
>>> I think we should inherit the flags from the parent just when we create
>>> a new file/directory, in the other cases, just give a option to the users.
>>> How do you think about?
>>
>> I agree with that. The COW status of a file should not be changed at all
>> when renamed. The typical users are database files and vm images, losing
>> the NOCOW flag just from moving here and back is quite unexpected.
>>
>> david
> 
> Yeah, I agree to remove this bad 'change in rename', will send a patch to
> address it.

I think we can add a mount option, if the option is set, when we move a file 
to a new directory, or create a new file, we will inherit the flags of the parent.
If not set, we inherit the flags only when create a new file.
How do you think about it?

Thanks
Miao

> 
> thanks,
> liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

