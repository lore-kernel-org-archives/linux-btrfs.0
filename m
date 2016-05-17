Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:36611 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbcEQNFm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 09:05:42 -0400
Received: by mail-io0-f173.google.com with SMTP id i75so21941833ioa.3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 06:05:42 -0700 (PDT)
Subject: Re: RFE: 'btrfs' tools machine readable output
To: dsterba@suse.cz, "Richard W.M. Jones" <rjones@redhat.com>,
        linux-btrfs@vger.kernel.org, ptoscano@redhat.com
References: <20160516121456.GA16970@redhat.com>
 <20160517093307.GG511@twin.jikos.cz>
 <c7d51f53-d3f9-d95f-cb4d-c320ced4ca9b@gmail.com>
 <20160517122326.GJ511@twin.jikos.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b9136e93-2099-245e-46a0-941d72279e1f@gmail.com>
Date: Tue, 17 May 2016 09:05:38 -0400
MIME-Version: 1.0
In-Reply-To: <20160517122326.GJ511@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-17 08:23, David Sterba wrote:
> On Tue, May 17, 2016 at 07:14:12AM -0400, Austin S. Hemmelgarn wrote:
>>>> By this example I don't mean that JSON has to be the format -- in fact
>>>> it's a terrible format with all sorts of problems -- any format which
>>>> is parseable with C libraries would do for us.
>>>
>>> My ideas was to allow multiple formats, with slight change to the
>>> syntax:
>>>
>>> $ btrfs --format=json ...
>>> $ btrfs --format=plain ...
>>> $ btrfs --format=yaml ...
>> I like this idea, with one specific caveat, it would be _really_ nice to
>> be able to control at compile time what formats are supported.
>> Somebody's eventually going to want XML support, and I'd rather not have
>> to depend on expat or something similar in a tool that I regularly build
>> statically (I'm willing to tolerate YAML because that's what I'd use,
>> but I would probably compile out the JSON support too).
>
> I hope we can avoid any 3rd party library dependencies, we're just
> generating the output not parsing it. Either copy a version of the
> libraries or copy the quoting code, the rest can be simply implemented as
> a printf with enhanced format stings.
>
As much as I hate the possibility of having 3rd party library 
dependencies in btrfs-progs, I'm a lot more nervous about having the 
equivalent stuff open-coded or having a local copy of the library, as 
both have significant potential for bugs.  A significant majority of 
Linux systems have Python, and therefore have at least some XML library 
(I forget which one Python prefers to use).  Many also have at least one 
JSON library too.  If we make such dependencies optional, and also only 
load the library if we need it at runtime (so we would only load the 
JSON library if we are asked to print JSON output), then we could still 
avoid the overhead for most people.

The other possibility would be to just pick one output format, open code 
that, and be done with it.  It's not hard to write s simple script to 
convert between YAML, JSON, and other similar formats.  If we do go this 
way, I'd still suggest YAML as it's more human friendly, a lot easier to 
parse using scripts due to the line oriented nature of it, and is also 
probably easier to code without any external dependencies.
