From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: read-only subvolumes?
Date: Thu, 24 Mar 2011 17:31:17 +0800
Message-ID: <4D8B0F65.6080905@cn.fujitsu.com>
References: <4D89ADA7.2000803@gmail.com> <4D89BC88.5030406@cn.fujitsu.com> <4D89C649.7080803@gmail.com> <4D89C81D.6050800@gmail.com> <4D89CBF4.6040600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D89CBF4.6040600@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> IMHO, this is related to how the debug options of the kernel are
> configured. Attached you find two config files, both for kernel
> version 2.6.38, with the one named 2.6.38-debug everything works and
> with the other one newly created subvolumes are read only.
> 

I've figured out what's wrong.

The root cause is the flags field of the root item for a new subvol
is never _initialized_!! so the on disk root_item->flags can be of
arbitrary value..

(so is root_item->byte_limit btw.)

I don't have a perfect solution at the moment, but I think a workaround
is to use a flag in root_item->inode_item->flags to indicate if
root->flags is initialized.
