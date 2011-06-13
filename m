From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: use the normal checksumming infrastructure for
 free space cache
Date: Mon, 13 Jun 2011 09:56:04 -0400
Message-ID: <4DF616F4.30202@redhat.com>
References: <1307734827-10697-1-git-send-email-josef@redhat.com> <4DF56D60.4070208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DF56D60.4070208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/12/2011 09:52 PM, Li Zefan wrote:
> Josef Bacik wrote:
>> We used to store the checksums of the space cache directly in the space cache,
>> however that doesn't work out too well if we have more space than we can fit the
>> checksums into the first page.  So instead use the normal checksumming
>> infrastructure.  There were problems with doing this originally but those
>> problems don't exist now so this works out fine.  Thanks,
>>
> 
> This looks great, so I'll drop my patch that extends the original code to
> allow more than 1 crc page.
> 
> one comment below:
> 
> ...
>> @@ -879,11 +802,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
>>  
>>  	ret = 1;
>>  
>> -out_free:
>> -	kfree(checksums);
>> -	kfree(pages);
>> -
> 
> leak memory by removing kfree(pages).

Ah right good catch, I'll fix that up, thanks,

Josef
