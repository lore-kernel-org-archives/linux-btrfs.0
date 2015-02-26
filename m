Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:46764 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbbBZNgi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Feb 2015 08:36:38 -0500
Message-ID: <54EF2161.90607@gmail.com>
Date: Thu, 26 Feb 2015 14:36:33 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: mtk.manpages@gmail.com, Eric Sandeen <sandeen@redhat.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        XFS Developers <xfs@oss.sgi.com>, linux-man@vger.kernel.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: Documenting MS_LAZYTIME
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com> <54E7578E.4090809@redhat.com> <20150221025636.GB7922@thunk.org> <54EEDE23.6080009@gmail.com> <20150226133113.GD11217@thunk.org>
In-Reply-To: <20150226133113.GD11217@thunk.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/26/2015 02:31 PM, Theodore Ts'o wrote:
> On Thu, Feb 26, 2015 at 09:49:39AM +0100, Michael Kerrisk (man-pages) wrote:
>>> How about somethign like "This mount significantly reduces writes
>>> needed to update the inode's timestamps, especially mtime and actime.
>>
>> What is "actime" in the preceding line? Should it be "ctime"?
> 
> Sorry, no, it should be "atime".

Thanks.

>> I find the wording of there a little confusing. Is the following 
>> a correct rewrite:
>>
>>     The advantage of MS_STRICTATIME | MS_LAZYTIME is that stat(2)
>>     will return the correctly updated atime, but the atime updates
>>     will be flushed to disk only when (1) the inode needs to be 
>>     updated for filesystem / data consistency reasons or (2) the 
>>     inode is pushed out of memory, or (3) the filesystem is 
>>     unmounted.)
> 
> Yes, that's correct.  The only other thing I might add is that in the
> case of a crash, the atime (or mtime) fields on disk might be out of
> date by at most 24 hours.

So in other words, add a sentence to that last para:

    The disadvantage of MS_STRICTATIME | MS_LAZYTIME is that
    in the case of a system crash, the atime and mtime fields
    on disk might be out of date by at most 24 hours.

Right?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
