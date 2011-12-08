From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: Re: Btrfs switches to using mostly one thread
Date: Thu, 08 Dec 2011 15:36:06 +0000
Message-ID: <4EE0D966.10609@jeremysanders.net>
References: <jbqkib$v1g$1@dough.gmane.org> <20111208153201.GJ8971@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111208153201.GJ8971@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/12/11 15:32, Chris Mason wrote:
> On Thu, Dec 08, 2011 at 03:19:38PM +0000, Jeremy Sanders wrote:
>> Hi - I'm trying out btrfs again, and I see the same old bug in kernel 3.1.4
>> (Fedora 16, x86_64, dual-core), where after a few hours of writing, it
>> switches from writing with several threads to writing with one:
>
> Ok, I'll try to reproduce this here.  Could you please do a sysrq-t, I'd
> like to see what the other delalloc-writers are doing.

I'll restart the copying to get it back to its failed state and post the 
results when it fails.

Jeremy

