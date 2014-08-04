Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbaHDSxJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Aug 2014 14:53:09 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s74Ir9L3014313
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Aug 2014 14:53:09 -0400
Message-ID: <53DFD694.4070809@redhat.com>
Date: Mon, 04 Aug 2014 13:53:08 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 03/12] btrfs: handle errors from reading the quota tree
 root
References: <1406934766-16974-1-git-send-email-sandeen@redhat.com> <1406934766-16974-4-git-send-email-sandeen@redhat.com> <20140804183519.GB18659@lenny.home.zabbo.net> <53DFD40F.40802@redhat.com> <20140804185113.GC18659@lenny.home.zabbo.net>
In-Reply-To: <20140804185113.GC18659@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/4/14, 1:51 PM, Zach Brown wrote:
> On Mon, Aug 04, 2014 at 01:42:23PM -0500, Eric Sandeen wrote:
>> On 8/4/14, 1:35 PM, Zach Brown wrote:
>>> On Fri, Aug 01, 2014 at 06:12:37PM -0500, Eric Sandeen wrote:
>>>> Reading the quota tree root may fail with ENOENT
>>>> if there is no quota, which is fine, but the code was
>>>> ignoring every other error as well, which is not fine.
>>>
>>> Kinda makes you want to write a test that would have caught this.
>>>
>>> Kinda.
>>
>> /me looks at ground, shuffles feet ...
>>  
>>> Also, if you're still keen to iterate on this series, it looks like this
>>> pattern is copied and pasted a few times in open_ctree().  With
>>> temporary root pointers for each block, for some reason.  A little
>>> helper function could take a bite out of open_ctree().
>>
>> Hm, the uuid tree is roughly similar, but not exactly.  I think those
>> are the only 2 "optional" roots (uuid because it'll get regenerated).
>>
>> I'm guessing the temporary root pointer is so we don't ever assign a
>> PTR_ERR to the root in fs_info?  
> 
> It took me a while to see what you meant.
> 
> Yeah, using a temporary root makes sense.  Using a different one for
> each block makes less sense.
> 

<snip>

> - z
> 

Yeah, fair enough, I thought about that after I hit send ;)
I could send a V2 of patch 11/12 to do that w/o needing to redo
the series too much.  :)  I'll see if there are any other comments.

Thanks!
-Eric
