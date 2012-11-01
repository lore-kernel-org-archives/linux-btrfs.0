Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39066 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab2KACjl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 22:39:41 -0400
Message-ID: <5091E0E4.5080804@oracle.com>
Date: Thu, 01 Nov 2012 10:39:32 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Franke <ttfranke@googlemail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Crashes in extent_io.c after "btrfs bad mapping eb" notice
References: <20121031005736.306fd86b@googlemail.com> <50907514.3060400@oracle.com> <20121031210032.303c1c36@googlemail.com>
In-Reply-To: <20121031210032.303c1c36@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/01/2012 04:00 AM, Franke wrote:
> Hi,
> 
> since yesterday I have run a balance while asleep/at work. Now I
> experimented a bit, and the situation has changed.
> 
> I am now getting hard hangs ( system is gone without even writing
> anything to syslog ), some time ( minutes to an hour ) into running a
> scrub.
> 
> Those hangs happen with 3.6.2 , 3.6.4 and Jan's unstable version.
> It hasn't hung yet without running a scrub.
> 
> I have no idea if this is part of the same problem or something else.
> Do you have any idea either way?
> 

Well, thanks for testing.

We may need your sysrq-w output(maybe screen output) to locate where we hard hangs.

Besides, I recommend you pick Jan's patches out, and apply them on the latest btrfs upstream
and run another round to see if it get better, since there might be some fixes for the very hang
already in the upstream.

Right now the latest btrfs upstream's top commit is

commit f46dbe3dee853f8a860f889cb2b7ff4c624f2a7a
Author: Chris Mason <chris.mason@fusionio.com>
Date:   Tue Oct 9 11:17:20 2012 -0400

    btrfs: init ref_index to zero in add_inode_ref
    
    Signed-off-by: Chris Mason <chris.mason@fusionio.com>

thanks,
liubo

> I will probably destroy my btrfs and create a new one over the weekend,
> unless you still need info for debugging.
> 
> thanks,
> Tobias
> 
> On Wed, 31 Oct 2012 08:47:16 +0800
> Liu Bo <bo.li.liu@oracle.com> wrote:
> 
>> On 10/31/2012 07:57 AM, Franke wrote:
>>> Hello,
>>>
>>> I have been having some crashes like this. Since I upgraded to
>>> 3.6.4 they have become common. The crashes happen pretty randomly
>>> during normal system usage. After the syslog messages the system
>>> stays semi usable for a minute, but when I run any new program it
>>> hangs. I had to downgrade to 3.6.2 to get my system usable again.
>>>
>>> Is there any way I can help find the cause of those crashes? 
>>>
>>
>> Hi Franke,
>>
>> Jan and me have worked together to fix the mentioned bugs days
>> before, and you can try Jan's git repo and see if it works in your
>> situation:
>>
>>           git.jan-o-sch.net for-chris
>>
>> (It contains most of patches related to backref walking.)
>>
>> thanks,
>> liubo
>>

