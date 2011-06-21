From: Francesco R <vivo75@gmail.com>
Subject: [HELP!] parent transid verify failed on 600755752960 wanted 757102
 found 756726
Date: Tue, 21 Jun 2011 14:10:20 +0200
Message-ID: <BANLkTimgsJa6MzR+Gm4vCkW4wqku9NjxFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

[HELP!] parent transid verify failed on 600755752960 wanted 757102 found 756726

Hi list, I've a broken btrfs filesystem to deal with can someone
please help me in recover the data?

The filesystem has been created a pair of years ago with 4 devices
with the command at #create and is mounted with #fstab options.
Recently I've added a pair of devices and made a `btrfs filesystem
balance`, after it succeded I was doing a `btrfs device delete` on
"space02" (the currently broken one) in the middle of this the power
cable has been axed.
After replacing the cable cord 'space01' is mountable, 'space02' is not.

tryed to use a backup copy of super with `btrfs-select-super` but it
fail as reported in #btrfs-select-super

please, pretty please have you suggestion on what try next?


#current kernel (vanilla + linux-vserver)
uname -a
Linux dobbia 2.6.38.8-vs2.3.0.37-rc17 #5 SMP Mon Jun 20 15:04:39 CEST
2011 x86_64 Intel(R) Core(TM) i7 CPU 950 @ 3.07GHz GenuineIntel
GNU/Linux

#create
modprobe btrfs
mkfs.btrfs -L space01 -m raid10 -d raid10 $DEVICES1
mkfs.btrfs -L space02 -m raid10 -d raid10 $DEVICES2

# fstab
/dev/sda6 /mnt/space01 btrfs
defaults,device=/dev/sda6,device=/dev/sdc6,device=/dev/sdd1,device=/dev/sde1,device=/dev/sdf6,device=/dev/sdg6
0 0
/dev/sda7 /mnt/space02 btrfs
defaults,device=/dev/sda7,device=/dev/sdb7,device=/dev/sdc7,device=/dev/sdd2,device=/dev/sde2,device=/dev/sdf7,device=/dev/sdg7
0 0

# current layout
btrfs filesystem show
failed to read /dev/sr0
Label: 'space01'  uuid: c77c6e87-fccd-4204-bd2c-d924fe06be31
        Total devices 6 FS bytes used 164.81GB
        devid    7 size 244.14GB used 56.59GB path /dev/sdf6
        devid    5 size 244.93GB used 56.59GB path /dev/sdd1
        devid    8 size 244.14GB used 56.59GB path /dev/sdg6
        devid    6 size 244.93GB used 56.59GB path /dev/sde1
        devid    4 size 244.14GB used 56.59GB path /dev/sda6
        devid    3 size 244.14GB used 56.59GB path /dev/sdc6

Label: 'space02'  uuid: f752def1-1abc-48c7-8ebb-47ba37b8ffa6
        Total devices 7 FS bytes used 172.94GB
        devid    7 size 487.65GB used 0.00 path /dev/sdf7
        devid    6 size 488.94GB used 60.25GB path /dev/sde2
        devid    5 size 488.94GB used 58.75GB path /dev/sdd2
        devid    4 size 487.65GB used 60.26GB path /dev/sda7
        devid    7 size 487.65GB used 1.50GB path /dev/sdg7
        devid    2 size 487.65GB used 58.76GB path /dev/sdb7
        devid    3 size 487.65GB used 60.26GB path /dev/sdc7

Btrfs v0.19-35-g1b444cd-dirty

# first error messages
Jun 20 14:04:35 dobbia kernel: [  806.587580] device label space02
devid 4 transid 757294 /dev/sda7
Jun 20 14:04:35 dobbia kernel: [  806.629781] device label space02
devid 2 transid 756848 /dev/sdb7
Jun 20 14:04:35 dobbia kernel: [  806.630107] device label space02
devid 3 transid 757294 /dev/sdc7
Jun 20 14:04:35 dobbia kernel: [  806.652126] device label space02
devid 5 transid 756846 /dev/sdd2
Jun 20 14:04:37 dobbia kernel: [  808.201719] device label space02
devid 6 transid 757294 /dev/sde2
Jun 20 14:04:37 dobbia kernel: [  808.218108] device label space02
devid 7 transid 756846 /dev/sdf7
Jun 20 14:04:37 dobbia kernel: [  808.218433] device label space02
devid 7 transid 757294 /dev/sdg7
Jun 20 14:04:37 dobbia kernel: [  808.218715] device label space02
devid 4 transid 757294 /dev/sda7
Jun 20 14:04:37 dobbia kernel: [  808.271797] btrfs: failed to read
the system array on sdg7
Jun 20 14:04:37 dobbia kernel: [  808.293776] btrfs: open_ctree failed
Jun 20 14:04:56 dobbia kernel: [  827.190208] device label space02
devid 4 transid 757294 /dev/sda7
Jun 20 14:04:56 dobbia kernel: [  827.254517] btrfs: failed to read
the system array on sdg7
Jun 20 14:04:56 dobbia kernel: [  827.280152] btrfs: open_ctree failed
Jun 20 14:05:01 dobbia kernel: [  832.442454] device label space02
devid 4 transid 757294 /dev/sda7
Jun 20 14:05:01 dobbia kernel: [  832.502017] btrfs: failed to read
the system array on sdg7
Jun 20 14:05:01 dobbia kernel: [  832.521492] btrfs: open_ctree failed
Jun 20 14:05:20 dobbia kernel: [  851.113237] device label space02
devid 4 transid 757294 /dev/sda7
Jun 20 14:05:20 dobbia kernel: [  851.199478] btrfs: allowing degraded mounts
Jun 20 14:05:20 dobbia kernel: [  851.563583] parent transid verify
failed on 600755752960 wanted 757102 found 756726
Jun 20 14:05:20 dobbia kernel: [  851.564146] parent transid verify
failed on 600755752960 wanted 757102 found 756726
Jun 20 14:05:20 dobbia kernel: [  851.651006] btrfs bad tree block
start 0 600859951104
Jun 20 14:05:20 dobbia kernel: [  851.671362] parent transid verify
failed on 600859955200 wanted 756926 found 756726
Jun 20 14:05:20 dobbia kernel: [  851.671636] parent transid verify
failed on 600859955200 wanted 756926 found 756726
Jun 20 14:05:20 dobbia kernel: [  851.693515] btrfs bad tree block
start 0 601053986816
Jun 20 14:05:20 dobbia kernel: [  851.693559] btrfs bad tree block
start 0 601054003200
Jun 20 14:05:20 dobbia kernel: [  851.693566] btrfs bad tree block
start 0 601054007296
Jun 20 14:05:20 dobbia kernel: [  851.693669] btrfs bad tree block
start 0 601053990912
Jun 20 14:05:20 dobbia kernel: [  851.693714] btrfs bad tree block
start 0 601053995008
Jun 20 14:05:25 dobbia kernel: [  856.642102] verify_parent_transid:
90 callbacks suppressed

#btrfs-select-super
./btrfs-select-super -s 1 /dev/sda7
using SB copy 1, bytenr 67108864
failed to read /dev/sr0
failed to read /dev/sr0
btrfs-select-super: volumes.c:1367: btrfs_read_sys_array: Assertion
`!(ret)' failed.
Aborted
