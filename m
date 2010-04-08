From: Harshavardhana <harsha@gluster.com>
Subject: Re: [PATCH] fs/btrfs: Return EPERM for rmdir on subvolumes and snapshots
Date: Thu, 08 Apr 2010 15:35:40 -0700
Message-ID: <4BBE5A3C.5060804@gluster.com>
References: <1270758931-5291-1-git-send-email-harsha@gluster.com> <20100408220717.GA15666@arch.davidb.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: David Brown <btrfs@davidb.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100408220717.GA15666@arch.davidb.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/08/2010 03:07 PM, David Brown wrote:
> On Thu, Apr 08, 2010 at 01:35:31PM -0700, Harshavardhana wrote:
>
>
>>     if (inode->i_size > BTRFS_EMPTY_DIR_SIZE ||
>>         inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
>> -        return -ENOTEMPTY;
>> +        return -EPERM;
>
> Don't you want to still return ENOTEMPTY for the size check, and only
> the EPERM on the root of subvolume?
>
> David
Yep my bad.  i_size check has to be ENOTEMPTY

Thanks

-- 
Harshavardhana
http://www.gluster.com

