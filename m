From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Sun, 21 Aug 2011 23:08:15 -0700
Message-ID: <4E51F24F.1050503@oracle.com>
References: <1309275199-10801-1-git-send-email-josef@redhat.com> <4E4F814B.5070202@gmail.com> <4E4F865B.2010608@gmail.com> <4E4FD48B.8030101@oracle.com> <4E4FE1B1.7010601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com, viro@ZenIV.linux.org.uk
To: Marco Stornelli <marco.stornelli@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4E4FE1B1.7010601@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/20/2011 09:32 AM, Marco Stornelli wrote:
> Il 20/08/2011 17:36, Sunil Mushran ha scritto:
>> On 08/20/2011 03:03 AM, Marco Stornelli wrote:
>>> Il 20/08/2011 11:41, Marco Stornelli ha scritto:
>>>> Hi,
>>>>
>>>> Il 28/06/2011 17:33, Josef Bacik ha scritto:
>>>>> This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.
>>>>> Turns out
>>>>> using fiemap in things like cp cause more problems than it solves, so
>>>>> lets try
>>>>> and give userspace an interface that doesn't suck. We need to match
>>>>> solaris
>>>>> here, and the definitions are
>>>>>
>>>>> *o* If /whence/ is SEEK_HOLE, the offset of the start of the
>>>>> next hole greater than or equal to the supplied offset
>>>>> is returned. The definition of a hole is provided near
>>>>> the end of the DESCRIPTION.
>>>>>
>>>>> *o* If /whence/ is SEEK_DATA, the file pointer is set to the
>>>>> start of the next non-hole file region greater than or
>>>>> equal to the supplied offset.
>>>>>
>>>>
>>>> I'm implementing the SEEK_DATA/SEEK_HOLE management for pramfs and 
>>>> I've
>>>> got some doubts about the right behavior:
>>>>
>>>> 1) when we use SEEK_DATA/SEEK_HOLE, the offset used in lseek means
>>>> always the offset from the start of the file, right?
>>>>
>>>> 2) in case of a file with hole at the beginning and data at the 
>>>> end, if
>>>> I do lseek(fd, 0, SEEK_HOLE) I should receive the end of the file
>>>> because the idea is to search the *next* hole and we have always a
>>>> virtual hole at the end of the file, right?
>>>
>>> Just to be precise about this question: the alternative here, it's to
>>> return the same position because we are already in a hole.
>>
>> Yes, the offset is from the start of the file.
>>
>> And yes, same offset is ok. I think the word next should be
>> dropped from the definition. It is misleading.
>>
>
> Thank. Yes the word "next" is not very clear. I re-read the proposal 
> for the standard, actually it's seems to me that if we are in the last 
> hole we should return the file size, if we are not in the last hole 
> than it's ok the same offset - "....except that
> if offset falls beyond the last byte not within a hole, then the file
> offset may be set to the file size instead".

Any proposal that differentiates between holes is wrong. It should not
matter where the hole is.

Think of it from the usage-pov.

doff = 0;
while ((doff = lseek(SEEK_DATA, doff)) != -ENXIO) {
     hoff = lseek(SEEK_HOLE, doff);
     read_offset = doff;
     read_len = hoff -doff;
     process();
     doff = hoff;
}

The goal is to make this as efficient as follows. Treating the last
hole differently adds more code for no benefit.

