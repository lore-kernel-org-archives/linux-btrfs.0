From: Jakob Unterwurzacher <jakobunt@gmail.com>
Subject: Re: Rename+crash behaviour of btrfs - nearly ext3!
Date: Tue, 18 May 2010 17:57:49 +0200
Message-ID: <4BF2B8FD.10301@gmail.com>
References: <4BF18525.8080904@gmail.com> <20100517193652.GC8635@think> <4BF1DBCD.7060208@gmail.com> <20100518003032.GK8635@think> <20100518005926.GM8635@think> <4BF28225.2000908@gmail.com> <20100518131304.GX8635@think> <4BF29EF5.4020408@gmail.com> <20100518143658.GA8635@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100518143658.GA8635@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 18/05/10 16:36, Chris Mason wrote:
>>
>> The idea would be to delay the rename hitting the disk until the data
>> has been written anyway.
>> The mv would return immediately, and someday, after the data has been
>> written to disk, the rename would be written to disk.
> 
> This is possible, but we have to choose between consuming unbounded
> resources while we queue up all the mvs or sometimes forcing the things
> to disk.  At the end of the day, disks are so slow that eventually you
> do end up waiting on them.
> 
> -chris
> 

I'm not sure how much memory a queued rename takes up, but the time that
would be spent flushing it to disk would then be spent flushing file
data, draining the write buffer and freeing memory, no?

That would be writing to disk

 [Data..................][Rename]  or
 [Rename][Data..................]

Whether you drain the file data queue or the rename queue first, in the
end you'd have to write it all....

I thought the problem of delaying the renames was complexity, well, at
least T'Tso said it was [1] - I'm not sure if this applies to btrfs as well.


Thanks,
Jakob



[1] https://bugzilla.kernel.org/show_bug.cgi?id=15910#c9
