Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab3DVP1y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 11:27:54 -0400
Message-ID: <517556CF.9090405@redhat.com>
Date: Mon, 22 Apr 2013 10:27:11 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2] btrfs: move leak debug code to functions
References: <517387F8.506@redhat.com> <5174C82D.1080901@redhat.com> <20130422152203.GQ16427@twin.jikos.cz>
In-Reply-To: <20130422152203.GQ16427@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/22/13 10:22 AM, David Sterba wrote:
> On Mon, Apr 22, 2013 at 12:18:37AM -0500, Eric Sandeen wrote:
>> There was a time when sprinkling #ifdefs around was
>> bad form.   We can clean up the code a bit by moving
>> the leak-list adds/removes into functions and make things
>> more readable.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> V2: remove extra semicolons on no-op #defines,
>> thanks Roger!
>>
>> p.s. maybe _debug_ should be in the function names?
>> *shrug* 
> 
> I agree with that, makes things clear in the code, one does not need to
> look into that function.
> 
> The leak_list members of extent_state and extent_buffer are present even
> without LEAK_DEBUG and are taking space, I'd like to see them moved
> under an #ifdef, but as the define is now local to the .c file this
> would need to add eg. a CONFIG_ option or a comment that describes how
> it should be used.

Yep I noticed that too, I'd be happy to elevate it to a CONFIG_ option if
it's really something that will be kept around for a while.

Could maybe be lumped in to a CONFIG_BTRFS_DEBUG that catches other
#define DEBUG behaviors as well?

-Eric

> Bug I'm fine with changing just the function names right now, the rest
> is optional and nice to have.
> 
> Reviewed-by: David Sterba <dsterba@suse.cz>
> 

