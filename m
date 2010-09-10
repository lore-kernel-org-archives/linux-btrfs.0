From: Zhu Yanhai <zhu.yanhai@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2642!
Date: Fri, 10 Sep 2010 16:37:26 +0800
Message-ID: <AANLkTik9k3Er1P408Kzqte9WaW7_HMf=26Yk8jP5bBrY@mail.gmail.com>
References: <20100909223331.362dd906.kitayama@cl.bb4u.ne.jp>
 <AANLkTi=QQdBkvhUamuKrM=vhkYc6=9Eu6_d14M3PciJF@mail.gmail.com> <20100910160713.ef663160.kitayama@cl.bb4u.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100910160713.ef663160.kitayama@cl.bb4u.ne.jp>
List-ID: <linux-btrfs.vger.kernel.org>

Please feel free to forward it, as I don't know the addr for -mm tree.

-zyh

2010/9/10 Itaru Kitayama <kitayama@cl.bb4u.ne.jp>:
>
> Thank you, Zhu. Would you send the patch to Andrew or should I pass it on to him?
>
> Itaru
>
> On Thu, 9 Sep 2010 23:30:52 +0800
> Zhu Yanhai <zhu.yanhai@gmail.com> wrote:
>
>> Hi,
>> That's because btrfs_del_dir_entries_in_log() will return the real
>> errno after Andi's
>> commit, so btrfs_unlink_inode() has to check the return value more seriously.
>> A patch for this has been sent out.
>>
>> Regards,
>> Zhu Yanhai
>
