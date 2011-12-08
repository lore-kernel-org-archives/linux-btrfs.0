From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: Re: Btrfs switches to using mostly one thread
Date: Thu, 08 Dec 2011 17:39:16 +0000
Message-ID: <4EE0F644.6000204@jeremysanders.net>
References: <jbqkib$v1g$1@dough.gmane.org> <20111208153201.GJ8971@shiny> <4EE0EC68.6040505@jeremysanders.net> <20111208172316.GP8971@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111208172316.GP8971@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/12/11 17:23, Chris Mason wrote:
> On Thu, Dec 08, 2011 at 04:57:12PM +0000, Jeremy Sanders wrote:
>> On 08/12/11 15:32, Chris Mason wrote:
>>> On Thu, Dec 08, 2011 at 03:19:38PM +0000, Jeremy Sanders wrote:
>>>> Hi - I'm trying out btrfs again, and I see the same old bug in kernel 3.1.4
>>>> (Fedora 16, x86_64, dual-core), where after a few hours of writing, it
>>>> switches from writing with several threads to writing with one:
>>>
>>> Ok, I'll try to reproduce this here.  Could you please do a sysrq-t, I'd
>>> like to see what the other delalloc-writers are doing.
>>
>> I've attached sysrq-t. It looks like it might be truncated at the
>> beginning, however.
>
> /var/log/messages may have the whole thing, please do check.

That was from /var/log/messages. I think it needs a longer log_buf_len. 
Unfortunately the system hasn't come back from its reboot, so it will 
have to wait until tomorrow when I can get to it physically.

Jeremy
