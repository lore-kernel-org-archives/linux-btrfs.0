Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:33343 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbbLNRv3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 12:51:29 -0500
Received: by iow186 with SMTP id 186so34396904iow.0
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 09:51:29 -0800 (PST)
Subject: Re: [PATCH v3] btrfs: Introduce new mount option to disable tree log
 replay
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1449714846-18174-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151214173200.GO4227@twin.jikos.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <566F016D.8050403@gmail.com>
Date: Mon, 14 Dec 2015 12:50:37 -0500
MIME-Version: 1.0
In-Reply-To: <20151214173200.GO4227@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-14 12:32, David Sterba wrote:
> On Thu, Dec 10, 2015 at 10:34:06AM +0800, Qu Wenruo wrote:
>> Introduce a new mount option "nologreplay" to co-operate with "ro" mount
>> option to get real readonly mount, like "norecovery" in ext* and xfs.
>>
>> Since the new parse_options() need to check new flags at remount time,
>> so add a new parameter for parse_options().
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
>
> I've read the discussions around the change and from the user's POV I'd
> suggest to add another mount option that would be just an alias for any
> mount options that would implement the 'hard-ro' semantics.
>
> Say it's called 'nowr'. Now it would imply 'nologreplay', but may cover
> more options in the future.
It should also imply noatime.  I'm not sure how BTRFS handles atime when 
mounted RO, but I know a lot of old UNIX systems updated atime even on 
filesystems mounted RO, and I know that at least at one point Linux did too.
>
>   mount -o ro,nowr /dev/sdx /mnt
>
> would work when switching kernels.

I like this idea, but I think that having a name like true-ro or hard-ro 
and making it imply ro (and noatime) would probably be better (or at 
least, simpler to use from a user perspective).

