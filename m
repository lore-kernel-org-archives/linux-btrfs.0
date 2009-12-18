From: Zhaolei <zhaolei@cn.fujitsu.com>
Subject: Re: Re: [PATCH] btrfs: Simplify offset calculation method for ctree.h
Date: Fri, 18 Dec 2009 13:51:14 +0800
Message-ID: <4B2B1852.6080105@cn.fujitsu.com>
References: <4B2ADB4C.7010900@cn.fujitsu.com> <9bd6b5360912172039y432361fu243d0f05bf75b7b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: sniper <s3c24xx@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751576AbZLRFtb@vger.kernel.org>
In-Reply-To: <9bd6b5360912172039y432361fu243d0f05bf75b7b7@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

sniper wrote:
> No, many pointers in btrfs function arguments are not pointing to an
> absolute address, but relative to the start address of extent.
> Take following function as example, argument inode_item is an offset
> value to the beginning of leaf. So we can't reach its member with
> &inode_item->xxx

Notice that we are not reach its member, we are getting pointer of its
member with &inode_item->mtime.
This operation have same effect as old one.

Thanks
Zhaolei

> 
>>  static inline struct btrfs_timespec *
>>  btrfs_inode_mtime(struct btrfs_inode_item *inode_item)
>>  {
>> -       unsigned long ptr = (unsigned long)inode_item;
>> -       ptr += offsetof(struct btrfs_inode_item, mtime);
>> -       return (struct btrfs_timespec *)ptr;
>> +       return &inode_item->mtime;
>>  }
