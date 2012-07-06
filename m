Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:47011 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab2GFPCf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jul 2012 11:02:35 -0400
Message-ID: <4FF6FE0A.2090204@jan-o-sch.net>
Date: Fri, 06 Jul 2012 17:02:34 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
References: <20120703224756.GA21647@sli.dy.fi> <20120704001713.GA8986@sli.dy.fi> <4FF42876.8010309@jan-o-sch.net> <20120704160340.GA9770@sli.dy.fi> <4FF47168.9010405@jan-o-sch.net> <20120704202452.GA8996@sli.dy.fi> <4FF5998D.8020205@jan-o-sch.net> <20120705234739.GA9736@sli.dy.fi> <4FF6C12A.10305@jan-o-sch.net> <20120706143350.GA10427@sli.dy.fi> <20120706144030.GL7159@shiny>
In-Reply-To: <20120706144030.GL7159@shiny>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, July 06, 2012 at 16:40 (+0200), Chris Mason wrote:
> On Fri, Jul 06, 2012 at 08:33:51AM -0600, Sami Liedes wrote:
>> On Fri, Jul 06, 2012 at 12:42:50PM +0200, Jan Schmidt wrote:
>>> I've no good idea at the moment how to go on. It might help to get a feeling if
>>> it's shifting around at least a little bit or really constant in the timing of
>>> occurrence. So can you please apply the next patch on top of the other two and
>>> give it some more failure tries? The "checksum mismatch [1234]" line will be of
>>> most interest. I'm also curious what the additional debug variables will say in
>>> the extended version of the very first printk. You can leave out the stack
>>> traces if you like, they won't matter much anyway.
>>
>> Ok. Also turned on CONFIG_DEBUG_PAGEALLOC and CONFIG_SLUB_DEBUG_ON as
>> suggested by Chris Mason.
>>
>> With those and the latest patch, there's an oops already at boot. I
>> don't have netconsole yet at that point, but here's the important
>> parts (sure I can capture it fully if you need).
>>
>> By the way, something seems to be untabifying your patches. I don't
>> know if it's on my side or yours, but at least some other patches I
>> receive via linux-btrfs contain tabs. Doing a M-x tabify in emacs
>> mostly makes them apply cleanly for me.
>>
>> 	Sami
>>
>>
>> ------------------------------------------------------------
>> btrfs: disk space caching is enabled
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000150
>> IP: [<ffffffffa0223568>] check_node+0x138/0x250 [btrfs]
> 
> This isn't from any of the new debugging.  Can you please try it on an
> unpatched kernel?

You're confusing that with check_leaf. I added check_node along the way, see my
mail from Thu, July 05, 2012 at 15:41 (+0200). I'd really like to add something
similar for the 3.6 series.

Checking for the null pointer dereference.

-Jan
