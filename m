Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaGXWi6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 18:38:58 -0400
Message-ID: <53D18AFE.30907@redhat.com>
Date: Thu, 24 Jul 2014 17:38:54 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH, RFC] btrfs: refactor open_ctree()
References: <53AB6185.9060109@redhat.com> <53D179B3.6010800@fb.com>
In-Reply-To: <53D179B3.6010800@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/24/14, 4:25 PM, Chris Mason wrote:
> On 06/25/2014 07:55 PM, Eric Sandeen wrote:
>> First off: total RFC, don't merge this; it builds, but
>> is totally untested.
>>
>> open_ctree() is almost 1000 lines long.  I've started trying
>> to refactor it, primarily into helper functions, and also
>> simplifying (?) things a bit at the beginning by removing the
>> ret = func(); if (ret) { err = ret; goto ... } dance where it's not
>> needed.
>>
>> Does this look like a reasonable thing to do?  Have I cut
>> things into the right chunks?  Would you rather see it as
>> as series of patches, moving one hunk of code at a time?
> 
> I do love this patch, either as a series or one big patch.  Whatever
> makes it easiest for you to test is fine with me.

Oh right!  I remember this thing!  Let me try to get back to it... ;)

Thanks,
-Eric

