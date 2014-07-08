Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52209 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755902AbaGHBTd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jul 2014 21:19:33 -0400
Message-ID: <53BB470D.9000604@cn.fujitsu.com>
Date: Tue, 8 Jul 2014 09:19:09 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: Re: [PATCH 2/2] btrfs-progs: Add mount point check for 'btrfs fi
 df' command
References: <1404463129-28350-1-git-send-email-quwenruo@cn.fujitsu.com> <1404463129-28350-2-git-send-email-quwenruo@cn.fujitsu.com> <20140704135226.GO1553@twin.jikos.cz> <20140707095140.GA7732@mail2.smcindiaonline.com>
In-Reply-To: <20140707095140.GA7732@mail2.smcindiaonline.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 2/2] btrfs-progs: Add mount point check for 'btrfs 
fi df' command
From: Vikram Goyal <vikigoyal@gmail.com>
To: linux-btrfs@vger.kernel.org
Date: 2014年07月07日 17:51
> On Fri, Jul 04, 2014 at 03:52:26PM +0200, David Sterba wrote:
>> On Fri, Jul 04, 2014 at 04:38:49PM +0800, Qu Wenruo wrote:
>>> 'btrfs fi df' command is currently able to be executed on any file/dir
>>> inside btrfs since it uses btrfs ioctl to get disk usage info.
>>>
>>> However it is somewhat confusing for some end users since normally such
>>> command should only be executed on a mount point.
>>
>> I disagree here, it's much more convenient to run 'fi df' anywhere and
>> get the output. The system 'df' command works the same way.
>
> Just to clarify, in case my earlier mail did not convey the idea
> properly.
>
> The basic difference between traditional df & btrfs fi df is that
> traditional df does not errors out when no arg is given & <without an
> arg> outputs all the mounted FSes with their mount points. So to be
> consistent, btrfs fi df should output all BTRFSes with mount points if
> no arg is given.
>
> Btrfs fi df insists for an arg <path> but does not clarifies in its
> output if the given arg is a path inside of a mount point or is the
> mount point itself, which can become transparent, if the mount point is
> also shown in the output.
IMO this is much better.

Cc David.
What about this idea? No extra warning but output the mount point?
Since if calling find_mount_root(), it will check whether the mount 
point is btrfs,
which can provide more meaningful error message than the original
"ERROR: couldn't get space info - Inappropriate ioctl for device" error 
message.

Thanks,
Qu
>
> This is a just a request & a pointer to an oversight/anomaly but if the
> developers do not feel in resonance with it right now then I just wish
> that they keep it in mind, think about it & remove this confusion caused
> by btrfs fi df as,when & how they feel fit.
>
>>
>> The 'fi df' command itself is not that user friendly and the numbers
>> need further interpretation. I'm using it heavily during debugging and
>> restricting it to the mountpoint seems too artifical, the tool can cope
>> with that.
>>
>> The 'fi usage' is supposed to give the user-friendly overview, but the
>> patchset is stuck because I found the numbers wrong or misleading under
>> some circumstances.
>>
>> I'll reread the thread that motivated this patch to see if there's
>> something to address.
>
> Thanks
>

