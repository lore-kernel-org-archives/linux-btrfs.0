From: Jakob Unterwurzacher <jakobunt@gmail.com>
Subject: Re: Rename+crash behaviour of btrfs - nearly ext3!
Date: Tue, 18 May 2010 20:24:48 +0200
Message-ID: <4BF2DB70.4080702@gmail.com>
References: <4BF18525.8080904@gmail.com> <20100517193652.GC8635@think> <4BF1DBCD.7060208@gmail.com> <20100518003032.GK8635@think> <20100518005926.GM8635@think> <4BF28225.2000908@gmail.com> <20100518131304.GX8635@think> <4BF29EF5.4020408@gmail.com> <20100518143658.GA8635@think> <4BF2B8FD.10301@gmail.com> <20100518161013.GD8635@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100518161013.GD8635@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 18/05/10 18:10, Chris Mason wrote:
>>
>> I'm not sure how much memory a queued rename takes up, but the time that
>> would be spent flushing it to disk would then be spent flushing file
>> data, draining the write buffer and freeing memory, no?
>>
>> That would be writing to disk
>>
>>  [Data..................][Rename]  or
>>  [Rename][Data..................]
> 
> Actually it is:
> 
> [Data..................][allow the transaction commit to complete]  or
> [allow the transaction commit to complete][Data..................]
> 
> The problem is that people think of the rename as a tiny thing, but it
> is really bundled in with all of the other metadata operations that were
> done in the current transaction.   The space that was allocated to hold
> the new file name, the space that was freed to remove the old file name,
> the directory entries, the directory inode etc etc.
> 
> This means that holding back that one rename requires holding back every
> operation done to the filesystem.
> 
> In btrfs, we're still able to do fsyncs quickly in this case
> because we have a dedicated log for that.  But there are a few different
> types of operations (like disk management) that require us to wait for
> the transaction to complete even when we use the dedicated log.
> 
>>
>> Whether you drain the file data queue or the rename queue first, in the
>> end you'd have to write it all....
> 
> It's about latency.  The latency required to write the entire file is
> unbounded (the size of the file is unbounded).  The latency required to
> commit the transaction without the file data is bounded because we are
> able to control the amount of metadata in each transaction.
> 
> See the firefox vs ext3 wars for an example of all of this, it's the
> latency the firefox people were (rightly) complaining about.
> 
>>
>> I thought the problem of delaying the renames was complexity, well, at
>> least T'Tso said it was [1] - I'm not sure if this applies to btrfs as well.
> 
> I'm afraid there are lots and lots of different issues at play.  The
> most important way to look at it is that forcing data to disk is very
> slow, which is why we try to avoid it whenever we can.
> 
> Applications can request that the data go to disk via lots of different
> ways.  Rename was never ever meant to be one of them, but it really does
> make sense to provide atomic replacement of old good data with new good
> data, so we've implemented that extra syncing.
> 
> Implementing syncing when userland doesn't expect extra syncing usually
> just make userland very unhappy.  It's not that we can't do it it's that
> doing it has implications for every application that uses rename.
> 
> -chris

Thanks for all the insight.

I will update the wiki FAQ to make clear what "data=ordered" in btrfs
means, what not, and why (or something like that).


Jakob
