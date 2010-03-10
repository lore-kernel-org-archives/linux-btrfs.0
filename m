From: Gordan Bobic <gordan@bobich.net>
Subject: Re: SSD Optimizations
Date: Wed, 10 Mar 2010 23:22:25 +0000
Message-ID: <4B9829B1.1020706@bobich.net>
References: <4B97F7CE.4030405@bobich.net> <93cdabd21003101512n6d773084hcf5e4a85aa180480@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21003101512n6d773084hcf5e4a85aa180480@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Mike Fedyk wrote:
> On Wed, Mar 10, 2010 at 11:49 AM, Gordan Bobic <gordan@bobich.net> wrote:
>> I'm looking to try BTRFS on a SSD, and I would like to know what SSD
>> optimizations it applies. Is there a comprehensive list of what ssd mount
>> option does? How are the blocks and metadata arranged? Are there options
>> available comparable to ext2/ext3 to help reduce wear and improve
>> performance?
>>
>> Specifically, on ext2 (journal means more writes, so I don't use ext3 on
>> SSDs, since fsck typically only takes a few seconds when access time is <
>> 100us), I usually apply the
>> -b 4096 -E stripe-width = (erase_block/4096)
>> parameters to mkfs in order to reduce the multiple erase cycles on the same
>> underlying block.
>>
>> Are there similar optimizations available in BTRFS?
> 
> I think you'll get more out of btrfs, but another thing you can look
> into is ext4 without the journal.  Support was added for that recently
> (thanks to google).

How is this different to using mkfs.ext2 from e4fsprogs?

And while I appreciate hopeful remarks along the lines of "I think 
you'll get more out of btrfs", I am really after specifics of what the 
ssd mount option does, and what features comparable to the optimizations 
that can be done with ext2/3/4 (e.g. the mentioned stripe-width option) 
are available to get the best possible alignment of data and metadata to 
increase both performance and life expectancy of a SSD.

Also, for drives that don't support TRIM, is there a way to make the FS 
apply aggressive re-use of erased space (in order to help the drive's 
internal wear-leveling)?

I have looked through the documentation and the wiki, but it provides 
very little of actual substance.

Gordan
