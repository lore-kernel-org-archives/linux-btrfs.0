From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: btrfs csum failed, scrub ok
Date: Tue, 27 Mar 2012 18:46:10 +0200
Message-ID: <4F71EED2.70706@jan-o-sch.net>
References: <87haxawbtw.fsf@falma.de> <CAE5mzvh57pD_FTonZNEfH0a0o-oPNKo7OsGR3hSi_5oEW0mNGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>, Christoph Groth <cwg@falma.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE5mzvh57pD_FTonZNEfH0a0o-oPNKo7OsGR3hSi_5oEW0mNGQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 27.03.2012 18:24, cwillu wrote:
> On Tue, Mar 27, 2012 at 4:57 AM, Christoph Groth <cwg@falma.de> wrote:
>> A scrub done the morning after the incident also didn't find any
>> problems:
>>
>> root@mim:/home/cwg# btrfs scrub status /
>> scrub status for 2da00153-f9ea-4d6c-a6cc-10c913d22686
>>        scrub started at Tue Mar 27 10:37:49 2012 and finished after 3921 seconds
>>        total bytes scrubbed: 550.20GB with 0 errors
> 
> If btrfs is able to find a good copy, it will fix the bad copy automatically.

It does mention this in your logs, though. Grep for "repair", if it
doesn't occur, btrfs didn't repair any failures.

Scrub would normally find and count checksum errors, though.

-Jan
