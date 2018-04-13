Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:35522 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753107AbeDMOj2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Apr 2018 10:39:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhRoAnxr36Cy1pov+ExnNJ8Y+inmUc7chD77ONPt=u9qw@mail.gmail.com>
References: <CA+EzBbCbRsZ=2qkBYjGVZQAVmUz34ky8vDOB7HxqRCrgymzysQ@mail.gmail.com>
 <CAOQ4uxhK6DQxTdipX2SP2t1960PrRt66+k3FVxQqwTBs-67cQA@mail.gmail.com>
 <CAPaz=E+-baGSWhL3nD-8X4jn6rKdn2AVGLeqWh3EY5Nh-RodRA@mail.gmail.com> <CAOQ4uxhRoAnxr36Cy1pov+ExnNJ8Y+inmUc7chD77ONPt=u9qw@mail.gmail.com>
From: Jayashree Mohan <jayashree2912@gmail.com>
Date: Fri, 13 Apr 2018 09:39:27 -0500
Message-ID: <CA+EzBbCFURDs77xiL3ECf7+4irrywbmD1HdsUSUYE_oeonbo8A@mail.gmail.com>
Subject: Re: Symlink not persisted even after fsync
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Dave,

Thanks for clarifying the crash recovery semantics of strictly
metadata ordered filesystems. We had a follow-up question in this
case.

On Fri, Apr 13, 2018 at 8:16 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Apr 13, 2018 at 3:54 PM, Vijay Chidambaram <vijay@cs.utexas.edu> wrote:
>> Hi Amir,
>>
>> Thanks for the reply!
>>
>> On Fri, Apr 13, 2018 at 12:52 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>
>>> Not a bug.
>>>
>>> From man 2 fsync:
>>>
>>> "Calling  fsync() does not necessarily ensure that the entry in the
>>>  directory containing the file has also reached disk.  For that an
>>>  explicit fsync() on a file descriptor for the directory is also needed."
>>
>>
>> Are we understanding this right:
>>
>> ext4 and xfs fsync the parent directory if a sym link file is fsync-ed. But
>> btrfs does not. Is this what we are seeing?
>
> Nope.
>
> You are seeing an unintentional fsync of parent, because both
> parent update and symlink update are metadata updates that are
> tracked by the same transaction.
>
> fsync of symlink forces the current transaction to the journal,
> pulling in the parent update with it.
>
>
>>
>> I agree that fsync of a file does not mean fsync of its directory entry, but
>> it seems odd to do it for regular files and not for sym links. We do not see
>> this behavior if we use a regular file instead of a sym link file.
>>
>
> fsync of regular file behaves differently than fsync of non regular file.
> I suggest this read:
> https://thunk.org/tytso/blog/2009/03/12/delayed-allocation-and-the-zero-length-file-problem/
>
>>>
>>> There is a reason why this behavior is not being reproduces in
>>> ext4/xfs, but you should be able to reproduce a similar issue
>>> like this:
>>>
>>>
>>> 1. symlink (foo, bar.tmp)
>>> 2. open bar.tmp
>>> 3. fsync bar.tmp
>>> 4. rename(bar.tmp, bar)
>>> 5. fsync bar
>>> ----crash here----
>>

Going by your argument that all previous transactions that referenced
the file being fsync-ed needs to be committed, should we expect xfs
(and ext4) to persist file bar in this case?

If that's expected, I'd like to bring to your notice that file bar is
not persisted in both xfs and ext4. Is there any other detail we
should be considering in this scenario?


>>
>> I'm guessing xfs/ext4 detect the symlink-fsync pattern and fsync the parent
>> dir in our workload, but would miss it because of the rename in the workload
>> you provided?
>>
>
> No pattern detecting by xfs/ext4 AFAIK.
> rename does not change metadata of victim, so fsync(bar)
> may (depending on fs) trigger no metadata transaction commit.
>
> Thanks,
> Amir.
