From: sniper <s3c24xx@gmail.com>
Subject: Re: Re: [PATCH] btrfs: Simplify offset calculation method for ctree.h
Date: Fri, 18 Dec 2009 14:59:17 +0800
Message-ID: <9bd6b5360912172259x17ee93d6y631ab52988f8965a@mail.gmail.com>
References: <4B2ADB4C.7010900@cn.fujitsu.com>
	 <9bd6b5360912172039y432361fu243d0f05bf75b7b7@mail.gmail.com>
	 <4B2B1852.6080105@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B2B1852.6080105@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

2009/12/18 Zhaolei <zhaolei@cn.fujitsu.com>:
> sniper wrote:
>> No, many pointers in btrfs function arguments are not pointing to an
>> absolute address, but relative to the start address of extent.
>> Take following function as example, argument inode_item is an offset
>> value to the beginning of leaf. So we can't reach its member with
>> &inode_item->xxx
>
> Notice that we are not reach its member, we are getting pointer of its
> member with &inode_item->mtime.
> This operation have same effect as old one.

right!
