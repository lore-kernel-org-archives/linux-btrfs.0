Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:34508 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbcHIRKQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 13:10:16 -0400
Received: by mail-oi0-f50.google.com with SMTP id l203so26158166oib.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Aug 2016 10:10:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMG9ccwqnK63sbcF79VndBMitvFjX6pHPCU9YrrZcwEdiQxY5w@mail.gmail.com>
References: <CAMG9ccwK93opLn=qOcceDjExwDHHRaxO=juvcXz4TuWKt_qXeg@mail.gmail.com>
 <CAJCQCtSs5bHZu5NLjVfJLgxL45BdNq7hrmV3VdCLz+WxLEXrMw@mail.gmail.com> <CAMG9ccwqnK63sbcF79VndBMitvFjX6pHPCU9YrrZcwEdiQxY5w@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 9 Aug 2016 11:10:08 -0600
Message-ID: <CAJCQCtTuhTKBK=zjXsq3o0mFnU6T7hYsLLr2VD0N7gqJ7vX0FQ@mail.gmail.com>
Subject: Re: Strange behavior after "rm -rf //"
To: Ivan Sizov <sivan606@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 8, 2016 at 12:38 PM, Ivan Sizov <sivan606@gmail.com> wrote:
> 2016-08-08 20:13 GMT+03:00 Chris Murphy <lists@colorremedies.com>:
>> Just a wild guess, the deletions may be in the tree log and haven't
>> been applied to the other trees (fs tree, extent tree, etc). So yes
>> I'd expect they get deleted on a rw mount.
>>
>> This is what kernel? Because kernel 4.6 offers mount option
>> "nologreplay" which suggests even if you do mount -r that log replay
>> happens, so you shouldn't see these deleted files unless you mount ro
>> *and* use nologreplay mount option.
>
> Live USB has kernel 4.5.7. Maybe I should try to run "btrfs rescue
> zero-log" and then mount RW? Will the files safe in that case?

Depends on what's in the log that you're zeroing out. It's entirely
possible other things are lost, not just the incomplete deletion. And
also I have no idea if the deletion is entirely contained in only the
tree log.

>
>> Anyway, even 5 seconds of rm -rf damages too much. If you don't have
>> recent snapshots then it's not sanely salvageable, just reinstall.
>
> As I could see, almost all the "deleted" files are present. Certainly,
> I'll make an rsync diff between two-week-ago snapshot and the current
> FS state. But it will better if in-place recover without backup is
> possible.
>
> P.S. IMHO, log replay by default is a quite dangerous thing. I didn't
> know about that change and I could lose all files if the live USB had
> 4.6 kernel))

The change is only a mount time option to avoid log replay and that
option only applies to ro mounts. All file systems with logs always
replay the log on mount by default, that's the entire point of the
log.



-- 
Chris Murphy
