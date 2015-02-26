Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:38679 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbbBZIx7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Feb 2015 03:53:59 -0500
Message-ID: <54EEDF1F.1000703@gmail.com>
Date: Thu, 26 Feb 2015 09:53:51 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>
CC: mtk.manpages@gmail.com, Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        XFS Developers <xfs@oss.sgi.com>, linux-man@vger.kernel.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: Documenting MS_LAZYTIME
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com> <54E7578E.4090809@redhat.com> <20150221025636.GB7922@thunk.org> <54EB1B19.8050808@gmail.com> <54EB5456.5030607@redhat.com>
In-Reply-To: <54EB5456.5030607@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/23/2015 05:24 PM, Eric Sandeen wrote:
> On 2/23/15 6:20 AM, Austin S Hemmelgarn wrote:
>> On 2015-02-20 21:56, Theodore Ts'o wrote:
>>> On Fri, Feb 20, 2015 at 09:49:34AM -0600, Eric Sandeen wrote:
>>>>
>>>>>                This mount option significantly reduces  writes  to  the
>>>>>                inode  table  for workloads that perform frequent random
>>>>>                writes to preallocated files.
>>>>
>>>> This seems like an overly specific description of a single workload out
>>>> of many which may benefit, but what do others think?  "inode table" is also
>>>> fairly extN-specific.
>>>
>>> How about somethign like "This mount significantly reduces writes
>>> needed to update the inode's timestamps, especially mtime and actime.
>>> Examples of workloads where this could be a large win include frequent
>>> random writes to preallocated files, as well as cases where the
>>> MS_STRICTATIME mount option is enabled."?
>>>
>>> (The advantage of MS_STRICTATIME | MS_LAZYTIME is that stat system
>>> calls will return the correctly updated atime, but those atime updates
>>> won't get flushed to disk unless the inode needs to be updated for
>>> file system / data consistency reasons, or when the inode is pushed
>>> out of memory, or when the file system is unmounted.)
>>>
>> If you want to list some specific software, it should help with
>> anything that uses sqlite (which notably includes firefox and
>> chrome), as well as most RDMS software and systemd-journald.
> 
> I'm really uneasy with starting to list specific workloads and applications
> here. It's going to get dated quickly, and will lead to endless cargo-cult
> tuning.
>
> I'd strongly prefer to just describe what it does (reduces the number of
> certain metadata writes to disk) and leave it at that....

I'm inclined to agree that it's probably not useful to list
specific applications, but I think giving some examples
of workloads, as Ted proposed does help the reader get an idea.
It helps some people (e.g., me) better understand what the
point of the feature is.

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
