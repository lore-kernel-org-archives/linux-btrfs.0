From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC] big fat transaction ioctl
Date: Tue, 10 Nov 2009 16:49:24 -0800
Message-ID: <4AFA0A14.7070701@goop.org>
References: <Pine.LNX.4.64.0911101143120.31818@cobra.newdream.net> <2a31deca0911101244l2a84ece6p6c5dbcce5e101e9b@mail.gmail.com> <Pine.LNX.4.64.0911101400270.27554@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0911101400270.27554@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/10/09 14:13, Sage Weil wrote:
> On Tue, 10 Nov 2009, Andrey Kuzmin wrote:
>
>   
>> On Tue, Nov 10, 2009 at 11:12 PM, Sage Weil <sage@newdream.net> wrote:
>>     
>>> Hi all,
>>>
>>> This is an alternative approach to atomic user transactions for btrfs.
>>> The old start/end ioctls suffer from some basic limitations, namely
>>>
>>>  - We can't properly reserve space ahead of time to avoid ENOSPC part
>>> way through the transaction, and
>>>  - The process may die (seg fault, SIGKILL) part way through the
>>> transaction.  Currently when that happens the partial transaction will
>>> commit.
>>>
>>> This patch implements an ioctl that lets the application completely
>>> specify the entire transaction in a single syscall.  If the process gets
>>> killed or seg faults part way through, the entire transaction will still
>>> complete.
>>>
>>> The goal is to atomically commit updates to multiple files, xattrs,
>>> directories.  But this is still a file system: we don't get rollback if
>>> things go wrong.  Instead, do what we can up front to make sure things
>>> will work out.  And if things do go wrong, optionally prevent a partial
>>> result from reaching the disk.
>>>       
>> Why not snapshot respective root (doesn't work if transaction spans
>> multiple file-systems, but this doesn't look like a real-world
>> limitation), run txn against that snapshot and rollback on failure
>> instead? Snapshots are writable, cheap, and this looks like a real
>> transaction abort mechanism.
>>     
> Good question.  :)
>
> I hadn't looked into this before, but I think the snapshots could be used 
> to achieve both atomicity and rollback.  If userspace uses an rw mutex to 
> quiesce writes, it can make sure all transactions complete before creating 
> a snapshot (commit).  The problem with this currently is the create 
> snapshot ioctl is relatively slow... it calls commit_transaction, which 
> blocks until everything reaches disk.  I think to perform well this 
> approach would need a hook to start a commit and then return as soon as it 
> can guarantee than any subsequent operation's start_transaction can't join 
> in that commit.
>
> This may be a better way to go about this, though.  Does that sound 
> reasonable, Chris?
>   

If snapshots only capture what's currently physically on disk, then it
means that the transactions will be fairly heavyweight in requiring
everything to be physically synced.  That may be what some apps want
anyway, but I can certainly imagine apps wanting transaction semantics
without having fsync-level durability requirements.

    J
