Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab3IITHr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Sep 2013 15:07:47 -0400
Message-ID: <522E1C7F.1010905@redhat.com>
Date: Mon, 09 Sep 2013 14:07:43 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add make test framework
References: <1378493456-5382-1-git-send-email-jbacik@fusionio.com> <20130909163204.GR32382@twin.jikos.cz> <20130909171328.GA2446@localhost.localdomain>
In-Reply-To: <20130909171328.GA2446@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/9/13 12:13 PM, Josef Bacik wrote:
> On Mon, Sep 09, 2013 at 06:32:04PM +0200, David Sterba wrote:
>> On Fri, Sep 06, 2013 at 02:50:56PM -0400, Josef Bacik wrote:
>>> We need to start adding some sanity tests to btrfs-progs to make sure we aren't
>>> breaking things with our patches.  The most important of these tools is btrfsck.
>>> This patch gets things started by adding a basic btrfsck test that makes sure we
>>> can fix a corruption problem we know we can fix.  Thanks,
>>
>> That's great. I hope we're going to gather more tests so let's separate
>> them to more categories from the beginning (mkfs, options coverage,
>> corrupt-block, restore maybe, dunno what else).
>>
>> This makes it possible to do a quick run a subset of the tests (eg. mkfs
>> related) after a fix is committed.
>>
>>>  tests/bad-file-extent-bytenr.img |  Bin 0 -> 4096 bytes
>>>  tests/fsck-tests.sh              |   34 ++++++++++++++++++++++++++++++++++
>>
>> I suggest to put them into a subdirectory (eg.) 'fsck' and prefix the
>> images with numbers (just a sequence number).
> 
> I'm not prefixing with numbers, I want to make it easy to tell what each image
> is testing for.  I will move them into a fsck directory tho.

David might have meant "001-bad-file-extent-bytenr.img" though.
 
>>
>>> --- /dev/null
>>> +++ b/tests/fsck-tests.sh
>>> @@ -0,0 +1,34 @@
>>> +#!/bin/bash
>>> +#
>>> +# loop through all of our bad images and make sure fsck repairs them properly
>>> +#
>>> +# It's GPL, same as everything else in this tree.
>>> +#
>>> +
>>> +TEST_DEV=""
>>
>> I found the current test hard to use, eg. I can't just do 'make test'
>> from the toplevel dir. The script fsck-tests.sh expects TEST_DEV to be
>> set, but there's no way to do that, because it's set unconditionally to
>> empty string.
> 
> Yeah I wasn't sure how I wanted to do this.  At first I thought about making the
> fsck tester just make a loop device, but I didn't want to override something if
> people were already using a loop device.  But maybe I'll just default to using
> loop5 or something big like that and then if the user wants to change it they
> can go into the script and change it themselves.  How does that sound?  Thanks,

Dumb question, can you just point btrfsck at the image itself w/o setting up
loopback?  i.e. do something like: 

# btrfs-image -r 001-bad-file-extent-bytenr.img test.img
# btrfsck --repair test.img

-Eric

> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

