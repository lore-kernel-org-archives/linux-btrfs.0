From: Daniel Witzel <dannyboy48888@gmail.com>
Subject: Re: parent transid verify failures on 2.6.39
Date: Fri, 24 Jun 2011 15:46:01 +0000 (UTC)
Message-ID: <loom.20110624T173859-917@post.gmane.org>
References: <4E026FD4.7020606@podzimek.org> <1308793398-sup-9234@shiny> <20110623195409.GA21007@dhcp231-156.rdu.redhat.com> <loom.20110623T230224-841@post.gmane.org> <4E03B197.3060009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

well here is what I,m doing:

patch -p1 < disk-io.patch  
output: "patching file fs/btrfs/disk-io.c"
rmmod btrfs 
rmmod lzo_compress
make -j3
make -j3 modules
make -j3 modules_install
cp arch/x86_64/boot/bzImage /boot/linux-next
depmod -a

(reboot)
modprobe btrfs
btrfs device scan
btrfs filesystem show (all drives show)
mount -o ro /dev/sdb1 /btrfs

and the output is : 

[ 4364.813453] parent transid verify failed on 2206281838592 wanted 2135 found 
1545
[ 4364.817093] btrfs: open_ctree failed
 

I checked the resulting disk-io.c file and the changes were merged. as you can
see I rebuilt my kernel and modules, rebooted and still got this error. is there
a step I'm missing? 

thanks




