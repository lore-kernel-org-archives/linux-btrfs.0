Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30983 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752024AbaGGAny convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jul 2014 20:43:54 -0400
Message-ID: <53B9ED88.8020201@cn.fujitsu.com>
Date: Mon, 7 Jul 2014 08:44:56 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] btrfs-progs: Add mount point check for 'btrfs fi
 df' command
References: <1404463129-28350-1-git-send-email-quwenruo@cn.fujitsu.com> <1404463129-28350-2-git-send-email-quwenruo@cn.fujitsu.com> <20140704135226.GO1553@twin.jikos.cz>
In-Reply-To: <20140704135226.GO1553@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 2/2] btrfs-progs: Add mount point check for 'btrfs 
fi df' command
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年07月04日 21:52
> On Fri, Jul 04, 2014 at 04:38:49PM +0800, Qu Wenruo wrote:
>> 'btrfs fi df' command is currently able to be executed on any file/dir
>> inside btrfs since it uses btrfs ioctl to get disk usage info.
>>
>> However it is somewhat confusing for some end users since normally such
>> command should only be executed on a mount point.
> I disagree here, it's much more convenient to run 'fi df' anywhere and
> get the output. The system 'df' command works the same way.
>
> The 'fi df' command itself is not that user friendly and the numbers
> need further interpretation. I'm using it heavily during debugging and
> restricting it to the mountpoint seems too artifical, the tool can cope
> with that.
Oh, if 'fi df' is mainly for debug, then I am OK for not merging this 
patchset.
>
> The 'fi usage' is supposed to give the user-friendly overview, but the
> patchset is stuck because I found the numbers wrong or misleading under
> some circumstances.
Although these patchset may not be merged,  I'm curious about the wrong 
numbers.
Would you please provide some leads or hints?

BTW, the indent in cmd_filesystem_df is 7 space, which is not normal 1 
tab(8 space).

Thanks,
Qu
>
> I'll reread the thread that motivated this patch to see if there's
> something to address.

