Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:53039 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbcFWX32 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 19:29:28 -0400
Subject: Re: Hello world, python-btrfs
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <57647351.4010603@mendix.com>
 <20160623142648.GE4915@twin.jikos.cz>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <d97ae16c-3348-9952-2416-acc60b5eb817@mendix.com>
Date: Fri, 24 Jun 2016 01:29:22 +0200
MIME-Version: 1.0
In-Reply-To: <20160623142648.GE4915@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 06/23/2016 04:26 PM, David Sterba wrote:
> On Sat, Jun 18, 2016 at 12:01:53AM +0200, Hans van Kranenburg wrote:
>> proof-of-concept level scripts to be able to debug my btrfs file
>> systems, the inevitable happened:
>>
>> https://github.com/knorrie/python-btrfs/
>>
>> Currently, the primary goal of this module is to be able to inspect the
>> internals of an existing filesystem for educational purposes.
>
> Looks great, I like.

Thanks, much appreciated!

> Python is better language for prototyping various
> things, also more convenient to write one-shot scripts to do specific
> rescue tasks.
>
>> The python module acts as a wrapper around the low level kernel calls
>> and btrfs data structures, presenting them as python objects with
>> interesting attributes and references to other objects.
>
> I guess it could be extended to read the filesystem objects directly
> from the image, so it's not only built around the search ioctl.
>
>> Why?!
>>
>> * Because it's fun!
>
> Best reason ever!

Moo!

>> * Because I get sick of using horrible ducttape regex solutions to
>> programmatically parse human readable output of external tools to
>> implement monitoring tools~~!11one.

This is actually the main reason I started it. Or was it being able to 
see where balance got the usage information from...

>> * Because I might to be able to help other people that also want to
>> learn the internals of btrfs.
>> * Much more...
>>
>> How?
>>
>> * It's a python library, so the code will have a decent level of
>> pythonicity. The ioctl search returns a generator, the search key is a
>> nice object you can just increment etc...
>> * This is a work in progress. I can only add support for parts of btrfs
>> that I understand myself first.
>
> My question is whether it sounds like a good idea to host the python
> bindings inside btrfs-progs or not.

Whoa, hold your horses!

> I can imagine creating scripts to
> craft images for testing or verifying results of fsck, so it would be
> more convenient to keep them in one place (but using a git submodule
> instead would not be a big deal).

python-btrfs is just a library. You can just clone the git somewhere, 
start hacking on it and put it in your python path, or pip install or 
apt-get install python-btrfs etc...

Programs that use it can be anywhere. What I have in examples/ now 
should probably end up either in howto style documentation or in proper 
tests for the lib (which requires keeping known-state filesystem images 
to test on etc, exploding into a new level of whoa).

> I'm mostly interested in the object representation of the filesystem
> objects and basic API around that, so if you have other plans with
> python-btrfs, we can at least share some of the code. My python-fu is
> not that strong so I'd rely on you or others to maintain that if you're
> interested.

Ok, I added a little TODO:
https://github.com/knorrie/python-btrfs/blob/master/TODO.md

There's a few things I want to do first at least, which are completing 
to support the full set of data structures using the kernel API, 
finishing to move existing code that I have lying around to use the new 
lib and a bit of extra info to help interested sysadmin/programmers to 
start using the library to peek around in their own filesystem a bit to 
see what's going on.

I haven't looked at how the btrfs-progs treat disks directly, but would 
certainly be interested in learning about that.

 From what you say, I feel that you're thinking about not only looking 
around in filesystems, but having ways to manipulate them?

Can you provide a more concrete example of "craft images for testing" or 
related ideas about how this project could help during regular btrfs 
development?

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com
