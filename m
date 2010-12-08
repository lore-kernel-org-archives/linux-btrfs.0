From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: The value displayed by 'ls -s' command is strange.
Date: Wed, 08 Dec 2010 09:15:34 +0900
Message-ID: <4CFECE26.1050403@jp.fujitsu.com>
References: <4CFDE978.9050407@jp.fujitsu.com> <1291743093-sup-2051@think> <AANLkTi=yQGxx7P=EoAP1sOg5rakmSmb-y+5OTeGbJnyx@mail.gmail.com> <1291750008-sup-1758@think> <AANLkTinwa=H3ge_bb0r5JgV=wPf0viCDXZGwNYftoqu4@mail.gmail.com> <1291752549-sup-5932@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Mike Fedyk <mfedyk@mikefedyk.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291752549-sup-5932@think>
List-ID: <linux-btrfs.vger.kernel.org>


(2010/12/08 5:15), Chris Mason wrote:
> Excerpts from Mike Fedyk's message of 2010-12-07 15:07:08 -0500:
>> On Tue, Dec 7, 2010 at 11:29 AM, Chris Mason <chris.mason@oracle.com> wrote:
>>> Excerpts from Mike Fedyk's message of 2010-12-07 14:16:55 -0500:
>>>> On Tue, Dec 7, 2010 at 10:44 AM, Chris Mason <chris.mason@oracle.com> wrote:
>>>>> Excerpts from Tsutomu Itoh's message of 2010-12-07 02:59:52 -0500:
>>>>>> Hi,
>>>>>>
>>>>>> I think that the disk allocation size of each file becomes a monotone increase
>>>>>> when the file is made.
>>>>>> But, it sometimes return to 0.  Is it correct?
>>>>>
>>>>> Well, there's a window during the processing of delayed allocation where
>>>>> we don't have the bytes recorded as delalloc and we don't have the bytes
>>>>> recorded in the inode yet.  That's why they are showing up as zero.
>>>>>
>>>>> We don't call inode_add_bytes() until after we insert the extent, but we
>>>>> drop the delalloc byte count on the file before the IO is done.
>>>>>
>>>>> Fixing it will be a little tricky because all the extent accounting
>>>>> assumes the inode_add_bytes happens at extent insertion time.
>>>>>
>>>>
>>>> How does opening the inode with O_APPEND during this window know where
>>>> to write the bytes?  If it's a pointer/cursor to the EOF then that
>>>> size could be used during the window.  Is that right?
>>>
>>> This counter records the number of blocks allocated to the file, and
>>> reading it with ls -l or stat is somewhat racey by nature.  Most of the
>>> time its fine, btrfs just has a really big window where the results from
>>> ls -l seem wrong.
>>>
>>
>> I see.  Is it using per-cpu vars or something similar?
> 
> Our stat function returns the block count in the inode plus the number
> of bytes we have accounted as delayed allocation.
> 
> As we do writes to the file, the delayed allocation count goes up and
> then eventually we decide we need to do some IO.
> 
> Before we do the IO, we have to decide where on the disk to write the
> extents.  Once that is decided, we decrement the count of delayed
> allocation bytes.
> 
> This is when stat starts returning the wrong answer.
> 
> Then we do the IO, and when the IO is done we actually insert the file
> extents into the file metadata.  This is when stat starts returning the
> right answer again.

I understood. 
However, I worry that the user is confused because the wrong condition
is too long. 

> 
> The whole setup sounds strange, but this is how btrfs implements the
> semantics from data=ordered.  We don't update the file to point to
> the new blocks until after the IO is done, so we never have to wait on
> the data IO before we can do a transaction commit.  It avoids all kinds
> of latencies with fsync and other problems.
> 
> One easy solution is to just add another counter in the in-memory inode
> for the number of bytes in flight that aren't accounted for in other
> places.  But I'd rather not make the inode any bigger, so I'll have to
> think if we can solve this another way.
> 
>>
>>> But, the counter really means nothing to the btrfs internals.  When we
>>> do file operations we go based on the extent pointers we find in the
>>> tree and i_size (i_size is strictly maintained).
>>>
>>
>> Would it be too heavy of an operation to have stat walk the btrfs tree
>> to get its data?
>>
> 
> I'm afraid so, stat is fairly performance critical.
> 
> -chris

