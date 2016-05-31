Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34752 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbcEaMPn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 08:15:43 -0400
Received: by mail-io0-f172.google.com with SMTP id p194so37651624iod.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 May 2016 05:15:43 -0700 (PDT)
Subject: Re: RFE: 'btrfs' tools machine readable output
To: Nicholas D Steeves <nsteeves@gmail.com>
References: <20160516121456.GA16970@redhat.com>
 <1c0d1dbc-325b-829a-762c-67288bb957a3@gmail.com>
 <CAD=QJKjx3QstqTB8kFLO7uYFuCNf7S++TTBkMkmnAPfp9iw1Uw@mail.gmail.com>
Cc: "Richard W.M. Jones" <rjones@redhat.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, ptoscano@redhat.com
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b2cfc1a7-12d9-64e7-4d65-a8cf40f9cd05@gmail.com>
Date: Tue, 31 May 2016 08:15:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=QJKjx3QstqTB8kFLO7uYFuCNf7S++TTBkMkmnAPfp9iw1Uw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-27 15:47, Nicholas D Steeves wrote:
> On 16 May 2016 at 08:39, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
>> On 2016-05-16 08:14, Richard W.M. Jones wrote:
>>>
>>> It would be really helpful if the btrfs tools had a machine-readable
>>> output.
>>> With machine-readable output, there'd be a flag which would
>>> change the output.  eg:
>>> $ btrfs --json filesystem show
>>> {
>>>   "devices": {
>>>      "Label": "ROOT",
>>>      "uuid": "af471cfc-421a-4d51-8811-ce969f76828a",
>>>      /// etc
>>>   }
>>> }
>> I would love to see something like this myself, as it would make integration
>> with monitoring tools so much easier.  I'd vote for YAML as the output format
>> though, as it's easily human readable as well as machine parseable while
>> still being space efficient.
>> ---
>> - filesystems
>>   - label: 'ROOT'
>>     uuid: af471cfc-421a-4d51-8811-ce969f76828a
>>     devices: 1
>>       - devid: 1
>>         size: 767.97 MB
>>         used 92.00 MB
>>         path: /dev/sda2
>>     used: 5.29 MB
>> ...
>
> Rather than adding language-specific output/extensions to btrfs-progs,
> what does everyone think of an interface which allows arbitrary
> ordering similar to the date command, with arbitrary delimiter
> support?
>
> eg: date +%a\ %d\ \%B\ %H:%m
>
> with something like: %D (device), %L (label), %V (volume), %v
> (subvolume), %U (volume UUID), %u (subvol UUID), et al.
>
> 'avoids formatting the output to any particular convention, and the
> order of what is queried can be in any order...but I think the [unit
> to operate on] [named unit] bit would necessarily need to come first.
> We already have that in btrfs [sub/fi/dev] [name] :-)
>
> Or should it be a separate command...  Something like "btrfs-machine
> [unit to operate on] [named unit] [action eg: print] [cryptic line
> with user's choice of delimiter and formatting]".  And then there
> might also be the option to "btrfs-machine [unit to operate on] [named
> unit] return [scrub status, balance status, etc.]" which returns a
> single integer value along the lines of idle|in
> progress|success|failure.  And at some point in the future
> btrfs-machine [unit to operate on] [named unit] progress [operation]
> which functions like "fsck -C [fd]".
>
> Now that, I imagine, would be something libvirt users would like,
> whether for web interface, GUI, or wrapper script for for a slick NAS
> web interfaces.
>
> For now, maybe start with a proof of concept with only the "print"
> action implemented?  And eventually merge this into the main btrfs
> command something like this: "btrfs -m unit name action args" or
> "btrfs --machine unit name action args"
I'm not sure how practical this would be, the format language would have 
to be pretty complex, and would need to be easily extensible at the same 
time.  We have a functionally infinite upper bound on what can be 
reported by a number of commands (fi df for example is bounded only by 
the number of supported profiles), and trying to sanely handle that gets 
complicated.

Also, once we have _some_ kind of machine parseable output, it becomes 
much easier to use other tools to pull out the exact info you want.
>
> On 16 May 2016 at 08:21, Martin Steigerwald <martin@lichtvoll.de> wrote:
>> How about a libbtrfs so that other tools can benefit from btrfs tools
>> functionality?
> Does much does /usr/lib/x86_64-linux-gnu/libbtrfs.so expose?
>
> What is the path of minimum duplication of work, and minimum long-term
> maintenance?  If my assumptions are correct, this is a 2000-level
> programming course textbook challenge on writing a program using a
> library to query some values...and that might be something I could
> manage :-)
Based on the fact that our CLI interface is really the only API people 
are using, I don't think there's almost anything exposed at a high-level 
in libbtrfs.

