From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2642!
Date: Fri, 10 Sep 2010 16:07:13 +0900
Message-ID: <20100910160713.ef663160.kitayama@cl.bb4u.ne.jp>
References: <20100909223331.362dd906.kitayama@cl.bb4u.ne.jp>
	<AANLkTi=QQdBkvhUamuKrM=vhkYc6=9Eu6_d14M3PciJF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Zhu Yanhai <zhu.yanhai@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=QQdBkvhUamuKrM=vhkYc6=9Eu6_d14M3PciJF@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


Thank you, Zhu. Would you send the patch to Andrew or should I pass it on to him?

Itaru

On Thu, 9 Sep 2010 23:30:52 +0800
Zhu Yanhai <zhu.yanhai@gmail.com> wrote:

> Hi,
> That's because btrfs_del_dir_entries_in_log() will return the real
> errno after Andi's
> commit, so btrfs_unlink_inode() has to check the return value more seriously.
> A patch for this has been sent out.
> 
> Regards,
> Zhu Yanhai
