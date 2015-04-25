Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:35835 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965400AbbDYSTs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Apr 2015 14:19:48 -0400
Received: by igbyr2 with SMTP id yr2so37303069igb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2015 11:19:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150424152428.GS4996@twin.jikos.cz>
References: <55392221.6090502@gmail.com>
	<55392315.8040306@gmail.com>
	<20150424152428.GS4996@twin.jikos.cz>
Date: Sat, 25 Apr 2015 14:19:47 -0400
Message-ID: <CAPL5yKetu1whj4ON+NQPJk6Z06Jnqz3MQGf6Dx=3nKqAB8Vw-g@mail.gmail.com>
Subject: Re: [PATCH 2/3] btrfs-progs: separate the overwrite check.
From: Dan Merillat <dan.merillat@gmail.com>
To: David Sterba <dsterba@suse.cz>, Dan Merillat <dan.merillat@gmail.com>,
        BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's a good question.  If path_name is absolute, the file descriptor
is ignored.  I used -1 (EBADF) instead of AT_FDCWD  there so if a
non-absolute path gets in there it errors out instead of attempting to
use a relative path off the current directory.

I'm not entirely sure if it's the best way, so if anyone else has
ideas let me know.

On Fri, Apr 24, 2015 at 11:24 AM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Apr 23, 2015 at 12:51:33PM -0400, Dan Merillat wrote:
>> +/* returns:
>> + *  0 if the file exists and should be skipped.
>> + *  1 if the file does NOT exist
>> + *  2 if the file exists but is OK to overwrite
>> + */
>> +
>> +static int overwrite_ok(const char * path)
>> +{
>> +     static int warn = 0;
>> +     struct stat st;
>> +     int ret;
>> +
>> +     /* don't be fooled by symlinks */
>> +     ret = fstatat(-1, path_name, &st, AT_SYMLINK_NOFOLLOW);
>
> Is the filedescriptor -1 correct? Previously, stat was used that uses
> AT_FDCWD for the dirfd, which is -100. -1 could be intepreted as a bad
> filedescriptor (EBADF).
