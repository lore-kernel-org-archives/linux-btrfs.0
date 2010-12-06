From: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Subject: R: Re: [PATCH 5/5][REPOST][BTRFS-PROGS] Add the "btrfs filesystem
 label" command
Date: Mon, 6 Dec 2010 08:42:40 +0100 (CET)
Message-ID: <33090918.1114211291621360513.JavaMail.defaultUser@defaultHost>
Reply-To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Cc: "chris.mason@oracle.com" <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Felix Blanke <felixblanke@gmail.com>
To: <jeromepoulin@gmail.com>, "kreijack@inwind.it" <kreijack@inwind.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


>Da: jeromepoulin@gmail.com
>Data: 06/12/2010 1.48
>A: "kreijack@inwind.it"<kreijack@inwind.it>
>Cc: "chris.mason@oracle.com"<chris.mason@oracle.com>, "linux-btrfs@vger.
kernel.org"<linux-btrfs@vger.kernel.org>, "Felix Blanke"<felixblanke@gmail.
com>
>Ogg: Re: [PATCH 5/5][REPOST][BTRFS-PROGS] Add the &quot;btrfs filesystem 
label&quot; command
>
>On 2010-12-05, at 12:47, Goffredo Baroncelli <kreijack@inwind.it> wrote:
>
>> Hi all,
>>
>> this patch adds the command "btrfs filesystem label" to change (or show) 
the
>> label of a filesystem.
>> This patch is a subset of the one written previously by Morey Roof. I
>> included the user space part only. So it is possible only to change/show a
>
>label of a *single device* and *umounted* filesystem.

The label is changed on  *every devices*. I tested it (on a machine without 
btrfs) 
and I confirm that. 

$ for i in 1 2 ; do dd if=/dev/zero of=img$i bs=1M count=520; done
$ sudo losetup -f img1
$ sudo losetup -f img2
$ sudo losetup -a 
/dev/loop0: [0801]:3965895 (img1)
/dev/loop1: [0801]:3965896 (img2)
$ sudo mkfs.btrfs -L test1 /dev/loop[01]
< removed some messages>
$ sudo blkid /dev/loop[01]
/dev/loop0: LABEL="test1" UUID="764ac2d3-dd37-4a64-8cfe-db118da8f09f" 
UUID_SUB="da978017-61c4-488c-9a79-b58271f2b615" TYPE="btrfs"
/dev/loop1: LABEL="test1" UUID="764ac2d3-dd37-4a64-8cfe-db118da8f09f" 
UUID_SUB="83ea15d5-db8f-4605-96ec-77807502627b" TYPE="btrfs"
$ sudo btrfs-progs-unstable/btrfs file labe /dev/loop0
failed to open /dev/btrfs-control skipping device registration
failed to open /dev/btrfs-control skipping device registration
failed to open /dev/btrfs-control skipping device registration
failed to open /dev/btrfs-control skipping device registration
test1
$ sudo btrfs-progs-unstable/btrfs file labe /dev/loop0 test2
failed to open /dev/btrfs-control skipping device registration
failed to open /dev/btrfs-control skipping device registration
failed to open /dev/btrfs-control skipping device registration
failed to open /dev/btrfs-control skipping device registration
$ sudo btrfs file labe /dev/loop1
failed to open /dev/btrfs-control skipping device registration
failed to open /dev/btrfs-control skipping device registration
failed to open /dev/btrfs-control skipping device registration
failed to open /dev/btrfs-control skipping device registration
test2
$ sudo blkid /dev/loop[01]
/dev/loop0: LABEL="test2" UUID="764ac2d3-dd37-4a64-8cfe-db118da8f09f" 
UUID_SUB="da978017-61c4-488c-9a79-b58271f2b615" TYPE="btrfs"
/dev/loop1: LABEL="test2" UUID="764ac2d3-dd37-4a64-8cfe-db118da8f09f" 
UUID_SUB="83ea15d5-db8f-4605-96ec-77807502627b" TYPE="btrfs"


On the basis of which test your results are different ? 

>Personally I really don't understand why changing the label of a
>mounted filesystem would cause any problem at all. Could someone
>explain that to me?

Because btrfs rewrite the superblock quite often. So if you change the 
superblock from the user space when a btrfs filesystem is mounted, it is likely 
that your change is over-written. Or, worse, the changing of  the superblock 
from the user space may lead to a corruption of the filesystem.

>Or at least the applet could include some force option for filesystem
>that can't be umounted, for example, root.

This request (changing the label of the root filesystem) requires a changing 
in the kernel side. 

>Jerome

Goffredo

>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html



