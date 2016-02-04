Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34631 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbcBDUKG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Feb 2016 15:10:06 -0500
Received: by mail-io0-f173.google.com with SMTP id 9so106117300iom.1
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Feb 2016 12:10:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56B387C6.9070505@inwind.it>
References: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
	<56B2AA51.80908@cn.fujitsu.com>
	<56B387C6.9070505@inwind.it>
Date: Thu, 4 Feb 2016 13:10:05 -0700
Message-ID: <CAJCQCtQOnvKMjrEKmY-nYGFgkH44ztqS_kYDA80vA-p5SmPtMw@mail.gmail.com>
Subject: Re: btrfs-progs and btrfs(8) inconsistencies
From: Chris Murphy <lists@colorremedies.com>
To: kreijack@inwind.it
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Moviuro <moviuro@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 4, 2016 at 10:17 AM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
> On 2016-02-04 02:33, Qu Wenruo wrote:
>> The idea itself makes a lot of sense.
>> But I have at least two things to worry about:
>>
>> 1) Old scripts backward compatibility
>>     Especially xfstests. Maintainer will hate it a lot.
>>     As we have changed it several times and broken existing test cases.
>>
>>     Although personally I like to let all the backward compatibility
>>     things go hell, but that's definitely not how things work. :(
>
> we could change the name of the btrfs prog (like bfs or bctl  ?).

btrfsctl? :-)

Is there a big problem with just having a consistent "machine
readable" flag for the existing btrfs that achieves this goal? Why fix
bugs in two different places when this is really just a request to
have consistent output *formatting*?


> If the command is called with the old name (btrfs) the old behavior is maintained; with the new name the new output is show if the specific sub command was updated; instead if the specific sub-command is not updated, the old output is show.

If there's a new command, then it ought to be for scripts, not for
users. We are much better off breaking all scripts with a new way of
doing things going forward, than breaking users (again) with another
command change.


>
> We could allow a window of 1-year of transition where the new command will be in the alpha state where there is no any guarantee to be backward compatible, hoping that this time would be sufficient to reshape the output of all commands.
>

Well quite honestly I think bash scripts depending on user space tools
are subject to no guarantees anyway. How about an actual stable
API/ABI for developers to depend on if they need to interact with
Btrfs, rather than doing it indirectly through user space tools, which
are mainly for users after all.

-- 
Chris Murphy
