From: Christoph Groth <cwg@falma.de>
Subject: Re: btrfs csum failed, scrub ok
Date: Tue, 27 Mar 2012 18:59:49 +0200
Message-ID: <87d37yt1x6.fsf@falma.de>
References: <87haxawbtw.fsf@falma.de>
	<CAE5mzvh57pD_FTonZNEfH0a0o-oPNKo7OsGR3hSi_5oEW0mNGQ@mail.gmail.com>
	<4F71EED2.70706@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Jan Schmidt <list.btrfs@jan-o-sch.net> writes:
> On 27.03.2012 18:24, cwillu wrote:
>> On Tue, Mar 27, 2012 at 4:57 AM, Christoph Groth <cwg@falma.de> wrote:
>>> A scrub done the morning after the incident also didn't find any
>>> problems:
>>>
>>> root@mim:/home/cwg# btrfs scrub status /
>>> scrub status for 2da00153-f9ea-4d6c-a6cc-10c913d22686
>>>        scrub started at Tue Mar 27 10:37:49 2012 and finished after 3921 seconds
>>>        total bytes scrubbed: 550.20GB with 0 errors
>> 
>> If btrfs is able to find a good copy, it will fix the bad copy automatically.
>
> It does mention this in your logs, though. Grep for "repair", if it
> doesn't occur, btrfs didn't repair any failures.

"repair" doesn't occur in the logs.  Actually, there are no other
entries from btrfs.

So why didn't btrfs try to repair a block it believed to be bad?

