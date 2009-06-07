From: Daniel Cordero <theappleman@gmail.com>
Subject: Re: New experimental btrfs branch ready for testing
Date: Sun, 7 Jun 2009 13:13:41 +0100
Message-ID: <20090607121341.GA11706@cumin.applehq.eu>
References: <20090601210447.GC3890@think>
 <8B019CAA-9B37-4403-B5FB-A925A17C045A@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <8B019CAA-9B37-4403-B5FB-A925A17C045A@karlsbakk.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 07, 2009 at 01:50:27PM +0200, Roy Sigurd Karlsbakk wrote:
> On 1. juni. 2009, at 23.04, Chris Mason wrote:
>
>> I've setup git branches called newformat where you can pull the new  
>> code.
>>
>> For the kernel (based on 2.6.30-rc7):
>>
>> git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs- 
>> unstable.git newformat
>
> # git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs- 
> unstable.git newformat
> fatal: Not a git repository
>
>> For the progs:
>>
>> git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs- 
>> progs-unstable.git newformat
>
> # git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs- 
> progs-unstable.git newformat
> fatal: Not a git repository
>
>>
> Have this code been removed, or is it me doing something funny?

You're doing something funny.

I'm guessing you don't already have a copy of the btrfs repositories, so
you should be using clone instead of pull.
If you do have them, cd into them.
