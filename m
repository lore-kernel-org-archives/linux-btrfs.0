From: Joe Landman <joe.landman@gmail.com>
Subject: Re: Blog: "BTRFS is effectively stable"
Date: Sat, 30 Oct 2010 19:07:27 -0400
Message-ID: <4CCCA52F.9040007@gmail.com>
References: <201010301038.28038.chris@csamuel.org> <AANLkTikRA_ZsXUJ6e_qYTuE0nzvV=YDrbqXs-Pjmqy0d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikRA_ZsXUJ6e_qYTuE0nzvV=YDrbqXs-Pjmqy0d@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/30/2010 05:19 PM, Freddie Cash wrote:
> On Fri, Oct 29, 2010 at 4:38 PM, Chris Samuel<chris@csamuel.org>  wrote:
>> A friend of mine who builds storage systems designed for HPC
>> use has been keeping an eye on btrfs and has just done some
>> testing of it with 2.6.36 and seems to like what he sees in
>> terms of stability.
>
> That's a *very* misleading conclusion to come to based solely on a
> single file I/O test.  It's more realistic to say "stable under fio
> load in ideal conditions".

Since it's my blog post that is generating these responses, let me 
provide some more information.

We want to see if the file system, at a basic level, works under load. 
We aren't yanking power, or otherwise purposefully damaging the 
underlying platform during operations, as that is not what we are testing.

What we've found is that zfs on fuse doesn't pass these very basic 
tests.  nilfs2 does (recent kernels anyway). btrfs does (now).

Our focus for the tests were quite simple.  Will the file system work 
when we are trying to shove GB/s down its throat.  If the answer is no, 
then we don't even consider looking at the "lets see how stable it is 
under purposefully harmful conditions" tests.

If the answer is yes, that it works, then we have to ask is the 
performance near where we need it for it to be useful.

Currently the answer to that is no.  Once this changes (and I saw some 
posts recently from Chris M that suggests that there have been some 
changes in this respect for 2.6.37 time frame), then we can start 
looking at the broader picture of suitability for use.

That latter set of issues, file system and metadata repair, stability in 
the face of less than ideal conditions, gets tested after we see the 
system able to perform where we need it to.

We aren't there yet.  Its stable against the tests we ran on it, which, 
as noted, some other file systems (some in wide spread use) aren't.

- Joe

