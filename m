From: Xavier Nicollet <nicollet@jeru.org>
Subject: compile btrfs for 2.6.27-rc9
Date: Fri, 10 Oct 2008 14:12:06 +0200
Message-ID: <20081010121206.GN20679@jeru.org>
Reply-To: nicollet@jeru.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I am trying to compile btrfs.ko (unstable) for 2.6.27-rc9.
I copied btrfs part of Kbuild, and fs/btrfs to my 2.6.27-rc9 tree.

Then make modules modules_install
However, I can't insmod btrfs.ko. Dmesg ouput:

[ 8973.920435] btrfs: no symbol version for struct_module
[ 8994.375255] btrfs: no symbol version for struct_module
[ 9049.174891] btrfs: no symbol version for struct_module
[ 9125.963989] btrfs: no symbol version for struct_module
[ 9178.504381] btrfs: no version for "struct_module" found: kernel
tainted.
[ 9178.513086] btrfs: Unknown symbol security_inode_mkdir

Is there a better way to do it ? I am running ubuntu.

Cheers,

-- 
Xavier Nicollet
