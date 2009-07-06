From: Amerigo Wang <amwang@redhat.com>
Subject: Re: [Patch v2] btrfs: use file_remove_suid() after i_mutex is held
Date: Mon, 06 Jul 2009 17:12:14 +0800
Message-ID: <4A51BFEE.9050200@redhat.com>
References: <20090706072043.6555.13669.sendpatchset@localhost.localdomain> <4A51AAFB.1000601@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
	Yan Zheng <zheng.yan@oracle.com>,
	Josef Bacik <jbacik@redhat.com>, Arjan <arjan@infradead.org>,
	Chris Mason <chris.mason@oracle.com>,
	akpm@linux-foundation.org, linux-btrfs@vger.kernel.org,
	Sven Wegener <sven.wegener@stealer.net>
To: Tao Ma <tao.ma@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A51AAFB.1000601@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Tao Ma wrote:
> Hi Amerigo,
>
> Amerigo Wang wrote:
>> V1 -> V2:
>> Move kmalloc() before mutex_lock(), suggested by Arjan.
>>
>> file_remove_suid() should be called with i_mutex held,
>> file_update_time() too. So move them after mutex_lock().
>>
>> Plus, check the return value of kmalloc().
>>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: Arjan <arjan@infradead.org>
>> Cc: Chris Mason <chris.mason@oracle.com>
>> Cc: Yan Zheng <zheng.yan@oracle.com>
>> Cc: Sven Wegener <sven.wegener@stealer.net>
>> Cc: Josef Bacik <jbacik@redhat.com>
>> Cc: Jeff Mahoney <jeffm@suse.com>
>>
>> ---
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index 7c3cd24..09ef5d6 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -944,14 +944,17 @@ static ssize_t btrfs_file_write(struct file 
>> *file, const char __user *buf,
>>      if (count == 0)
>>          goto out_nolock;
>>  
>> +    pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
>> +    if (!pages)
>> +        goto out_nolock;
> I guess you need to set err to -ENOMEM here so that the caller knows 
> what's wrong. With your patch, this function just return 0(since 
> num_written and err are both 0) with no error, and I guess it is worse 
> than kernel BUG out when the NULL pages is used later.

Agree. Thanks, I will update it.

