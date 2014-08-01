Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:37132 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaHABxQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 21:53:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140731190910.GP31950@carfax.org.uk>
References: <1406829213-4759-1-git-send-email-xerofoify@gmail.com>
	<20140731190910.GP31950@carfax.org.uk>
Date: Thu, 31 Jul 2014 21:53:15 -0400
Message-ID: <CAPDOMVj8cEsgR1TTOkTUWaxMHiEbpnM6qcj7opRuRLP+3YOfTg@mail.gmail.com>
Subject: Re: [PATCH] Add support to check for FALLOC_FL_COLLAPSE_RANGE and
 FALLOC_FL_ZERO_RANGE crap modes
From: Nick Krause <xerofoify@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Nicholas Krause <xerofoify@gmail.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 31, 2014 at 3:09 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Thu, Jul 31, 2014 at 01:53:33PM -0400, Nicholas Krause wrote:
>> This adds checks for the stated modes as if they are crap we will return error
>> not supported.
>
>    You've just enabled two options, but you haven't actually
> implemented the code behind it. I would tell you *NOT* to do anything
> else on this work until you can answer the question: What happens if
> you apply this patch, create a large file called "foo.txt", and then a
> userspace program executes the following code?
>
> int fd = open("foo.txt", O_RDWR);
> fallocate(fd, FALLOCATE_FL_COLLAPSE_RANGE, 50, 50);
>
>    Try it on a btrfs filesystem, both with and without your patch.
> Also try it on an ext4 filesystem.
>
>    Once you've done all of that, reply to this mail and tell me what
> the problem is with this patch. You need to make two answers: what are
> the technical problems with the patch? What errors have you made in
> the development process?
>
>    *Only* if you can answer those questions sensibly, should you write
> any more patches, of any kind.
>
>    Hugo.
>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>  fs/btrfs/file.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index 1f2b99c..599495a 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -2490,7 +2490,8 @@ static long btrfs_fallocate(struct file *file, int mode,
>>       alloc_end = round_up(offset + len, blocksize);
>>
>>       /* Make sure we aren't being give some crap mode */
>> -     if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
>> +     if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE|
>> +     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
>>               return -EOPNOTSUPP;
>>
>>       if (mode & FALLOC_FL_PUNCH_HOLE)
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>   --- The glass is neither half-full nor half-empty; it is twice as ---
>                         large as it needs to be.
Calls are there in btrfs , therefore will either kernel panic or cause an oops.
Need to test this patch as this is very easy to catch bug.
Nick
