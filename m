From: Chris Mason <chris.mason@oracle.com>
Subject: Re: compile btrfs for 2.6.27-rc9
Date: Fri, 10 Oct 2008 15:25:43 -0400
Message-ID: <1223666743.8209.30.camel@think.oraclecorp.com>
References: <20081010121206.GN20679@jeru.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: nicollet@jeru.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081010121206.GN20679@jeru.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-10-10 at 14:12 +0200, Xavier Nicollet wrote:
> Hello everyone,
> 
> I am trying to compile btrfs.ko (unstable) for 2.6.27-rc9.
> I copied btrfs part of Kbuild, and fs/btrfs to my 2.6.27-rc9 tree.
> 
> Then make modules modules_install
> However, I can't insmod btrfs.ko. Dmesg ouput:
> 
> [ 8973.920435] btrfs: no symbol version for struct_module
> [ 8994.375255] btrfs: no symbol version for struct_module
> [ 9049.174891] btrfs: no symbol version for struct_module
> [ 9125.963989] btrfs: no symbol version for struct_module
> [ 9178.504381] btrfs: no version for "struct_module" found: kernel
> tainted.
> [ 9178.513086] btrfs: Unknown symbol security_inode_mkdir
> 
> Is there a better way to do it ? I am running ubuntu.

This is fixed now, if you pull from the git tree you'll have the patch.

Thanks,
Chris


