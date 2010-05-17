From: Jakob Unterwurzacher <jakobunt@gmail.com>
Subject: Re: Rename+crash behaviour of btrfs - nearly ext3!
Date: Mon, 17 May 2010 22:30:43 +0200
Message-ID: <4BF1A773.5080006@gmail.com>
References: <4BF18525.8080904@gmail.com> <20100517192554.GB2322@localhost.localdomain> <20100517200912.GE8635@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100517200912.GE8635@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 17/05/10 22:09, Chris Mason wrote:
>>> -rw-r--r-- 1 root root 20 2010-05-17 17:06:25.812016407 +0200 01280.cur
>>> -rw-r--r-- 1 root root 20 2010-05-17 17:06:25.835999490 +0200 01281.cur
>>> -rw-r--r-- 1 root root  0 2010-05-17 17:06:25.868035485 +0200 01282.cur
>>> [...]
>>> -rw-r--r-- 1 root root  0 2010-05-17 17:06:26.080003626 +0200 01291.cur
>>> -rw-rw-rw- 1 root root  0 2010-05-17 17:06:26.108010083 +0200 01292.tmp
>>>
>>
>> This isn't actually true.  There is no window, the inode isn't written to disk
>> until all of the data is flushed to disk.  So the in memory inode will be
>> update, and therefore show an i_size of 0 since the io hasn't finished, but if
>> you were to crash at this point, when you came back up you'd have the old data
>> in place because the new inode data wasn't written to disk.  I have a feeling
>> ext4 is the same way, but I'd have to check for sure.  Thanks,
> 
> Jacob, could you please confirm if your test includes a crash?
> 
> -chris

Yes, i crash the VM by pressing reset in VirtualBox.
Note that the "ls" above is from the rename test that does NOT overwrite
existing files.

Jakob
