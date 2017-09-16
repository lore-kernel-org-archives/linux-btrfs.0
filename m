Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a4-2.smtp-out.eu-west-1.amazonses.com ([54.240.4.2]:57350 "EHLO
        a4-2.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751234AbdIPMkz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Sep 2017 08:40:55 -0400
Subject: Re: Regarding handling of file renames in Btrfs
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Rohan Kadekodi <kadekodirohan@gmail.com>, linux-btrfs@vger.kernel.org
Cc: Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>,
        Jayashree Mohan <jayashree2912@gmail.com>
References: <CADb0YN=G1MT=VwLcfbbrnppeXRKe3Zi4EsmwSs+xw89wR9rb4A@mail.gmail.com>
 <a2bf5d89-6753-2893-2dac-89fcbc924096@mendix.com>
From: Martin Raiber <martin@urbackup.org>
Message-ID: <0102015e8ab4b62a-8fdaae03-6fd2-41de-a0fa-a42c8b892445-000000@eu-west-1.amazonses.com>
Date: Sat, 16 Sep 2017 12:40:52 +0000
MIME-Version: 1.0
In-Reply-To: <a2bf5d89-6753-2893-2dac-89fcbc924096@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 16.09.2017 14:27 Hans van Kranenburg wrote:
> On 09/10/2017 01:50 AM, Rohan Kadekodi wrote:
>> I was trying to understand how file renames are handled in Btrfs. I
>> read the code documentation, but had a problem understanding a few
>> things.
>>
>> During a file rename, btrfs_commit_transaction() is called which is
>> because Btrfs has to commit the whole FS before storing the
>> information related to the new renamed file.
> Can you point to which lines of code you're looking at?
>
>> It has to commit the FS
>> because a rename first does an unlink, which is not recorded in the
>> btrfs_rename() transaction and so is not logged in the log tree. Is my
>> understanding correct? [...]
> Can you also point to where exactly you see this happening? I'd also
> like to understand more about this.
>
> The whole mail thread following this message continues about what a
> transaction commit is and does etc, but the above question is never
> answered I think.
>
> And I think it's an interesting question. Is a rename a "heavier"
> operation relative to other file operations?
>
as far as I can see it only uses the log tree in some cases where the
log tree was already used for the file or the parent directory. The
cases are documented here
https://github.com/torvalds/linux/blob/master/fs/btrfs/tree-log.c#L45 .
So rename isn't much heavier than unlink+create.

Regards,
Martin Raiber

