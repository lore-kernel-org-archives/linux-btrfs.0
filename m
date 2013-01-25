Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:15037 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab3AYI4m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 03:56:42 -0500
Message-ID: <510248C6.5010600@jan-o-sch.net>
Date: Fri, 25 Jan 2013 09:56:38 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: Chen Yang <chenyang.fnst@cn.fujitsu.com>,
        Alexander Block <ablock84@googlemail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH] Btrfs/send: sparse and pre-allocated file support for,
 btrfs-send mechanism
References: <50FF58BC.7090604@cn.fujitsu.com> <50FFC3C6.7040305@cn.fujitsu.com> <CAOcd+r0cNNaVFJdTVW_2f6u90u-km02mDtwk3H4Vt-YEcHNzzQ@mail.gmail.com> <51009455.7040005@cn.fujitsu.com> <CAOcd+r0hMRic8=fXNmUSbifAXwnQER8wCkj=mHSBGpQ7fM=LDA@mail.gmail.com> <51016BBB.8060307@jan-o-sch.net> <CAOcd+r1xeEC9ReiQwp6bHc9Euvf8xhYLKSBrvcijqiHHjotBwg@mail.gmail.com>
In-Reply-To: <CAOcd+r1xeEC9ReiQwp6bHc9Euvf8xhYLKSBrvcijqiHHjotBwg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,

On Thu, January 24, 2013 at 19:06 (+0100), Alex Lyakas wrote:
> On Thu, Jan 24, 2013 at 7:13 PM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
>> We don't transfer the metadata itself and that's for good reason. The data
>> should look alike from a user's point of view where possible. In places where we
>> have no good solution, we make compromises (inode numbers come to mind).
>>
>> So, as a general rule: If possible with reasonable effort, I like to keep as
>> much of the structure as possible. Therefore, I'd rather not see a sparse
>> detector in any receiver out there; if it's sparse, send it as sparse, and if
>> it's on disk, send it as zeros on disk.
> Agree, but I don't think we have any such thing. Receiver just obeys
> the commands in the stream, not tries to analyze them. Or perhaps you
> mean something else by "sparse detector"?

Sorry, I commented on the whole thread, in a single email. The above comment is
more in the direction of

---
On Thu, January 24, 2013 at 12:58 (+0100), Hugo Mills wrote:
> I disagree on the "content vs representation" comment above. I
> would very much hope that the reference receive implementation can
> turn a string of zeroes (or a hole) back into a sparse file. As a
> user, I'd be quite irritated if, say, one of my sparse VM images ended
> up 5 times the size when I backed it up with send/receive, simply
> because it's gone from holey to a huge bunch of zeroes. That
> particular issue can be dealt with at the receiver level, though.
---

>> Handling of preallocated space with this rule is, well, arguable. For me, such
>> space is more on disk than it's not. Applications preallocating space might do
>> so for a good reason, and I would not treat those blocks as if they were holes
>> for send and receive.
> 
> So, if I understand you correctly, you do suggest to distinguish
> between punch-hole and preallocate on send side (e.g., by using
> different send commands), and do appropriate things on the receive
> side by using/not using the FALLOC_FL_PUNCH_HOLE flag to the fallocate
> API on the receive side. If yes, then this was also my opinion.

Yes :-)
-Jan
