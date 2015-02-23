Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:51289 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbbBWMUq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Feb 2015 07:20:46 -0500
Message-ID: <54EB1B19.8050808@gmail.com>
Date: Mon, 23 Feb 2015 07:20:41 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
CC: Michael Kerrisk <mtk.manpages@gmail.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        XFS Developers <xfs@oss.sgi.com>, linux-man@vger.kernel.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: Documenting MS_LAZYTIME
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com> <54E7578E.4090809@redhat.com> <20150221025636.GB7922@thunk.org>
In-Reply-To: <20150221025636.GB7922@thunk.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-02-20 21:56, Theodore Ts'o wrote:
> On Fri, Feb 20, 2015 at 09:49:34AM -0600, Eric Sandeen wrote:
>>
>>>                This mount option significantly reduces  writes  to  the
>>>                inode  table  for workloads that perform frequent random
>>>                writes to preallocated files.
>>
>> This seems like an overly specific description of a single workload out
>> of many which may benefit, but what do others think?  "inode table" is also
>> fairly extN-specific.
>
> How about somethign like "This mount significantly reduces writes
> needed to update the inode's timestamps, especially mtime and actime.
> Examples of workloads where this could be a large win include frequent
> random writes to preallocated files, as well as cases where the
> MS_STRICTATIME mount option is enabled."?
>
> (The advantage of MS_STRICTATIME | MS_LAZYTIME is that stat system
> calls will return the correctly updated atime, but those atime updates
> won't get flushed to disk unless the inode needs to be updated for
> file system / data consistency reasons, or when the inode is pushed
> out of memory, or when the file system is unmounted.)
>
If you want to list some specific software, it should help with anything 
that uses sqlite (which notably includes firefox and chrome), as well as 
most RDMS software and systemd-journald.

