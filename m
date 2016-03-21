Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:36559 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542AbcCURxj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 13:53:39 -0400
Received: by mail-qg0-f41.google.com with SMTP id u110so158269732qge.3
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 10:53:39 -0700 (PDT)
Subject: Re: [PATCH] btrfs-progs: fix fi du so it works in more cases
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1458562991-6882-1-git-send-email-ahferroin7@gmail.com>
 <20160321174039.GB8095@twin.jikos.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56F03512.4050708@gmail.com>
Date: Mon, 21 Mar 2016 13:53:22 -0400
MIME-Version: 1.0
In-Reply-To: <20160321174039.GB8095@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-21 13:40, David Sterba wrote:
> On Mon, Mar 21, 2016 at 08:23:11AM -0400, Austin S. Hemmelgarn wrote:
>> Currently, btrfs fi du uses open_file_or_dir(), which tries to open
>> it's argument with o_RDWR.  Because of POSIX semantics, this fails for
>> non-root users when the file is read-only or is an executable that
>> is being run currently, or for all users (including root) when the
>> filesystem is read-only.  THis results in a somewhat confusing 'Unknown
>> error -1' message when trying to check such files.  Switch to using
>> open_file_or_dir3() with O_RDONLY passed in the flags, as this avoids
>> the limitations listed above, and we have no need to write to the files
>> anyway (and thus shouldn't be opening them writable).
>>
>> Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
>
> Applied, thanks.
>
>> ---
>> Build and runtime tested on x86-64 with glibc.
>>
>> I intend to take the time at some point this week to audit all users of
>> open_file_or_dir() and similarly change any that don't need to write
>> to what they're opening, possibly adding a helper function to do a
>> read-only open.
>
> Thanks. I think using open_file_or_dir3(path, &dirstream, O_RDONLY) is
> ok, no need for a helper.
>
Agreed, especially since this appears to be the only place that used 
open_file_or_dir() that doesn't potentially need write access.
