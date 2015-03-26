Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbbCZRL4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Mar 2015 13:11:56 -0400
Message-ID: <55143DD7.2020608@redhat.com>
Date: Thu, 26 Mar 2015 12:11:51 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: fdmanana@gmail.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: I think "btrfs: fix leak of path in btrfs_find_item" broke stable
 trees ...
References: <55137BE2.80603@redhat.com>	<CAL3q7H4fYq4K2rAT401QKSYKjRyaZwHDVSg6YZ0P=XU_31fLFQ@mail.gmail.com>	<5514137E.6080804@redhat.com> <1427381284.28930.5@mail.thefacebook.com>
In-Reply-To: <1427381284.28930.5@mail.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/26/15 9:48 AM, Chris Mason wrote:
> On Thu, Mar 26, 2015 at 10:11 AM, Eric Sandeen <sandeen@redhat.com> wrote:

...

>>>>  9c4f61f btrfs: simplify insert_orphan_item
>>>>
>>>>  made the whole path alloc/free go away.
>>
>> so I think there's no need for my patch; may as well just send the above to stable
>> and fix it that way, as long as 9c4f61f is deemed safe & correct, I think.
> 
> Nice catch, thanks Eric. 9c4f61f looks fine for stable to me, but
> since he's already testing on stable, I talked Eric into giving it a
> pass through xfstests before I send it up.
> 
> -chris

./check -g auto on 3.19-stable-ish seems fine-ish.  Certainly no worse w/ the patch added :)

Failures: btrfs/010 btrfs/017 btrfs/078 generic/015 generic/039 generic/040 generic/041 generic/065 generic/066 generic/071 generic/204
Failed 11 of 202 tests

I'd say ship it!

-Eric

