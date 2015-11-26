Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59810 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbbKZKNR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 05:13:17 -0500
Subject: Re: [PATCH 00/25] Btrfs-convert rework to support native separate
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, jeffm@suse.com
References: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151123173330.GH31035@twin.jikos.cz> <565424B8.3020502@cn.fujitsu.com>
 <20151125124235.GO31035@suse.cz> <5656547F.5050900@cn.fujitsu.com>
 <20151126093028.GP31035@suse.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5656DB29.2030708@gmx.com>
Date: Thu, 26 Nov 2015 18:12:57 +0800
MIME-Version: 1.0
In-Reply-To: <20151126093028.GP31035@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/26/2015 05:30 PM, David Sterba wrote:
> On Thu, Nov 26, 2015 at 08:38:23AM +0800, Qu Wenruo wrote:
>>> As far as the conversion support stays, it's not a problem of course. I
>>> don't have a complete picture of all the actual merging conflicts, but
>>> the idea is to provide the callback abstraction v2 to allow ext2 and
>>> reiser plus allow all the changes of this pathcset.
>>>
>> Glad to hear that.
>>
>> BTW, which reiserfs progs headers are you using?
>
> Sorry I forgot to mention it, it's the latest git version,
> https://git.kernel.org/cgit/linux/kernel/git/jeffm/reiserfsprogs.git/
>
> Jeff hasn't released v3.6.25 yet. We have the git version in SUSE
> distros so it works for me here.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Thanks, now it should be OK to continue the rebase.

But I'm a little concerned about the unstable headers, unlike ext2 its 
headers is almost stable but reiserfs seems not.

What about rebasing my patch to your abstract patch (btrfs-progs: 
convert: add context and operations struct to allow different file 
systems) first and add back your reiserfs patch?

Your abstract patch is quite nice, although need some modification to 
work with new convert.
I hope to add stable things first and don't want another reiserfs change 
breaks the compile.

Thanks,
Qu
