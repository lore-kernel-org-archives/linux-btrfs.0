Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19503 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753259AbbAOTGZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 14:06:25 -0500
Date: Thu, 15 Jan 2015 14:06:10 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: price to pay for nocow file bit?
To: Lennart Poettering <lennart@poettering.net>
CC: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        <linux-btrfs@vger.kernel.org>
Message-ID: <1421348770.21014.32@mail.thefacebook.com>
In-Reply-To: <20150108165321.GA23339@gardel-login>
References: <20150107174315.GA21865@gardel-login>
	<20150108155610.GA12859@hungrycats.org>
	<20150108165321.GA23339@gardel-login>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Thu, Jan 8, 2015 at 11:53 AM, Lennart Poettering 
<lennart@poettering.net> wrote:
> On Thu, 08.01.15 10:56, Zygo Blaxell (ce3g8jdj@umail.furryterror.org) 
> wrote:
> 
>>  On Wed, Jan 07, 2015 at 06:43:15PM +0100, Lennart Poettering wrote:
>>  > Heya!
>>  >
>>  > Currently, systemd-journald's disk access patterns (appending to 
>> the
>>  > end of files, then updating a few pointers in the front) result in
>>  > awfully fragmented journal files on btrfs, which has a pretty
>>  > negative effect on performance when accessing them.
>>  >
>>  > Now, to improve things a bit, I yesterday made a change to 
>> journald,
>>  > to issue the btrfs defrag ioctl when a journal file is rotated,
>>  > i.e. when we know that no further writes will be ever done on the
>>  > file.
>>  >
>>  > However, I wonder now if I should go one step further even, and 
>> use
>>  > the equivalent of "chattr -C" (i.e. nocow) on all journal files. 
>> I am
>>  > wondering what price I would precisely have to pay for
>>  > that. Judging by this earlier thread:
>>  >
>>  >         http://www.spinics.net/lists/linux-btrfs/msg33134.html
>>  >
>>  > it's mostly about data integrity, which is something I can live 
>> with,
>>  > given the conservative write patterns of journald, and the fact 
>> that
>>  > we do our own checksumming and careful data validation. I mean, if
>>  > btrfs in this mode provides no worse data integrity semantics than
>>  > ext4 I am fully fine with losing this feature for these files.
>> 
>>  This sounds to me like a job for fallocate with FALLOC_FL_KEEP_SIZE.
> 
> We already use fallocate(), but this is not enough on cow file
> systems. With fallocate() you can certainly improve fragmentation when
> appending things to a file. But on a COW file system this will help
> little if we change things in the beginning of the file, since COW
> means that it will then make a copy of those blocks and alter the
> copy, but leave the original version unmodified. And if we do that all
> the time the files get heavily fragmented, even though all the blocks
> we modify have been fallocate()d initially...
> 
>>  This would work on ext4, xfs, and others, and provide the same 
>> benefit
>>  (or even better) without filesystem-specific code.  journald would
>>  preallocate a contiguous chunk past the end of the file for appends,
>>  and
> 
> That's precisely what we do. But journald's write pattern is not
> purely appending to files, it's "append something to the end, then
> link it up in the beginning". And for the "append" part we are
> fine with fallocate(). It's the "link up" part that completely fucks
> up fragmentation so far.

I think a per-file autodefrag flag would help a lot here.  We've made 
some improvements for autodefrag and slowly growing log files because 
we noticed that compression ratios on slowly growing files really 
weren't very good.  The problem was we'd never have more than a single 
block to compress, so the compression code would give up and write the 
raw data.

compression + autodefrag on the other hand would take 64-128K and recow 
it down, giving very good results.

The second problem we hit was with stable page writes.  If bdflush 
decides to write the last block in the file, it's really a wasted IO 
unless the block is fully filled.  We've been experimenting with a 
patch to leave the last block out of writepages unless its a 
fsync/O_SYNC.

I'll code up the per-file autodefrag, we've hit a few use cases that 
make sense.

-chris



