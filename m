From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH] Check for immutable flag in fallocate path
Date: Wed, 02 Mar 2011 09:19:54 +0100
Message-ID: <4D6DFDAA.3060006__20604.1084406481$1299054346$gmane$org@gmail.com>
References: <4D6221B8.9040303@gmail.com> <20110221124635.GA5525@infradead.org> <AANLkTi=bJBeR0m3xuGX_9YZPqRFuMY=bKoxZEWJt37=M@mail.gmail.com> <20110227224940.GL2924@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Ted Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	cluster-devel@redhat.com,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110227224940.GL2924@thunk.org>
List-ID: <linux-btrfs.vger.kernel.org>

Il 27/02/2011 23:49, Ted Ts'o ha scritto:
> On Mon, Feb 21, 2011 at 05:50:21PM +0100, Marco Stornelli wrote:
>> 2011/2/21 Christoph Hellwig <hch@infradead.org>:
>>> On Mon, Feb 21, 2011 at 09:26:32AM +0100, Marco Stornelli wrote:
>>>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>>>
>>>> All fs must check for the immutable flag in their fallocate callback.
>>>> It's possible to have a race condition in this scenario: an application
>>>> open a file in read/write and it does something, meanwhile root set the
>>>> immutable flag on the file, the application at that point can call
>>>> fallocate with success. Only Ocfs2 check for the immutable flag at the
>>>> moment.
>>>
>>> Please add the check in fs/open.c:do_fallocate() so that it covers all
>>> filesystems.
>>>
>>>
>>
>> The check should be done after the fs got the inode mutex lock.
> 
> Why?  None of the other places which check the IMMUTABLE flag do so

I add to my previous response an other point: IMHO each fs should check
for it because after the inclusion of punch hole patch, the fs
can/cannot check for the append-only flag. So XFS (it supports the
"unreserve") should check even for append. I think we don't want to
allow this operation for an append-only file, isn't it? About this point
I'll update and resend my patch.

Marco
