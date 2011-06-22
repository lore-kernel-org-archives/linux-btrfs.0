From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 10/12 v3] Btrfs: deal with EEXIST after iput
Date: Wed, 22 Jun 2011 09:57:58 +0800
Message-ID: <4E014C26.8050705@cn.fujitsu.com>
References: <1308646193-7086-1-git-send-email-liubo2009@cn.fujitsu.com> <1308646193-7086-11-git-send-email-liubo2009@cn.fujitsu.com> <4E00A3E2.9030108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, dave@jikos.cz, chris.mason@oracle.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E00A3E2.9030108@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/21/2011 10:00 PM, Josef Bacik wrote:
> On 06/21/2011 04:49 AM, Liu Bo wrote:
>> There are two cases when BTRFS_I(inode)->logged_trans is zero:
>> a) an inode is just allocated;
>> b) iput an inode and reread it.
>>
>> However, in b) if btrfs is not committed yet, and this inode _may_
>> still remain
>> in log tree.
>>
>> So we need to check the log tree to get logged_trans a right value
>> in case it hits a EEXIST while logging.
> 
> Instead of doing this why not just check and see if the inode has been
> logged but the transaction has not yet been committed in
> btrfs_drop_inode?  That way the inode doesn't get evicted from cache
> until after we know it's ok and that way we don't have to waste a tree
> lookup.  Thanks,
> 

Good idea, I'll follow it.

thanks,
liubo

> Josef
> 

