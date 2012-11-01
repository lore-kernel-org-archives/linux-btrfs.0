Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:25374 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab2KAL5E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 07:57:04 -0400
Message-ID: <5092638C.2070505@jan-o-sch.net>
Date: Thu, 01 Nov 2012 12:57:00 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: Franke <ttfranke@googlemail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Crashes in extent_io.c after "btrfs bad mapping eb" notice
References: <20121031005736.306fd86b@googlemail.com> <50907514.3060400@oracle.com> <20121031210032.303c1c36@googlemail.com> <5091E0E4.5080804@oracle.com>
In-Reply-To: <5091E0E4.5080804@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, November 01, 2012 at 03:39 (+0100), Liu Bo wrote:
> On 11/01/2012 04:00 AM, Franke wrote:
>> Hi,
>>
>> since yesterday I have run a balance while asleep/at work. Now I
>> experimented a bit, and the situation has changed.
>>
>> I am now getting hard hangs ( system is gone without even writing
>> anything to syslog ), some time ( minutes to an hour ) into running a
>> scrub.
>>
>> Those hangs happen with 3.6.2 , 3.6.4 and Jan's unstable version.
>> It hasn't hung yet without running a scrub.
>>
>> I have no idea if this is part of the same problem or something else.
>> Do you have any idea either way?
>>
> 
> Well, thanks for testing.
> 
> We may need your sysrq-w output(maybe screen output) to locate where we hard hangs.
> 
> Besides, I recommend you pick Jan's patches out, and apply them on the latest btrfs upstream
> and run another round to see if it get better, since there might be some fixes for the very hang
> already in the upstream.
> 
> Right now the latest btrfs upstream's top commit is
> 
> commit f46dbe3dee853f8a860f889cb2b7ff4c624f2a7a
> Author: Chris Mason <chris.mason@fusionio.com>
> Date:   Tue Oct 9 11:17:20 2012 -0400
> 
>     btrfs: init ref_index to zero in add_inode_ref
>     
>     Signed-off-by: Chris Mason <chris.mason@fusionio.com>

This is an old top commit. The current cmason/master state is

commit c37b2b6269ee4637fb7cdb5da0d1e47215d57ce2
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Mon Oct 22 15:51:44 2012 -0400

and includes my recent fixes. I don't really expect them to prevent getting
stuck anywhere. sysrq+w output would be really helpful. I'm trying to reproduce
the problems in the meantime.

-Jan
