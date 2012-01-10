From: Peter Hjalmarsson <xake@rymdraket.net>
Subject: Broken btrfs filesystem
Date: Tue, 10 Jan 2012 12:42:13 +0100
Message-ID: <1326195733.1587.17.camel@lillen.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have problems with a btrfs filesystem, and am holding on to it for
some more days before reformat.
What I am interested about is two things:
1. Is there any way to restore more stuff from the filesystem then
already fetched (it would help to get the system up faster, but nothing
really of worth on that computer that is not already backed up)?
2. Is there anything here that resembles a bug that should be fixed
somewhere and do you need more information to fix this bug?

Please CC me as I am not subscribed.

So here comes the gory details:

I have a latop on which I have stock Fedora 16 installed with a ext4
boot, and then a luks-encrypted swap partiton and a luks-encrypted root
partition holding a btrfs volume.
Yesterday I hibernated my laptop, and when I resumed it it seemed to
resume normally, it let me unlock the screensaver, but did not allow an=
y
file-system-access and suddenly oopsed within seconds. Afterwards the
system failed to mount the root partition.

So I hooked the harddrive up to my desktop running Gentoo with a
3.2.0-kernel and latest btrfs-progs from git.

Trying to mount the filesystem does not work:
[11353.370007] device fsid 4c86ad4c-0d71-48a3-8cd2-058cccda2a07 devid 1
transid
83234 /dev/mapper/udisks-luks-uuid-d7efe74d-ed8f-425a-942c-c6bbc44483a3=
-uid1000
[11353.391953] parent transid verify failed on 869829160960 wanted 8237=
6
found 83320
[11353.391958] parent transid verify failed on 869829160960 wanted 8237=
6
found 83320
[11353.391961] parent transid verify failed on 869829160960 wanted 8237=
6
found 83320
[11353.391964] parent transid verify failed on 869829160960 wanted 8237=
6
found 83320
[11353.391966] parent transid verify failed on 869829160960 wanted 8237=
6
found 83320
[11353.391968] Failed to read block groups: -5
[11353.404931] btrfs: open_ctree failed


Trying with "-o recovery"
[11353.370007] device fsid 4c86ad4c-0d71-48a3-8cd2-058cccda2a07 devid 1
transid
83234 /dev/mapper/udisks-luks-uuid-d7efe74d-ed8f-425a-942c-c6bbc44483a3=
-uid1000
[11353.391953] parent transid verify failed on 869829160960 wanted 8237=
6
found 83320
[11353.391958] parent transid verify failed on 869829160960 wanted 8237=
6
found 83320
[11353.391961] parent transid verify failed on 869829160960 wanted 8237=
6
found 83320
[11353.391964] parent transid verify failed on 869829160960 wanted 8237=
6
found 83320
[11353.391966] parent transid verify failed on 869829160960 wanted 8237=
6
found 83320
[11353.391968] Failed to read block groups: -5
[11353.404931] btrfs: open_ctree failed


So mounting it seems not to be an option.

So I tried "restore".
=46irst run it restored one file, then it stopped. Upon retrying it
restored a lot more files (mostly the /var/lib/yum directory, and a
couple of empty directories), but now it never restores more then up to
one certain file, and it always fails after that with the following:

# ./restore /dev/dm-1 /home/xake/Skrivbord/ferra-rescue
parent transid verify failed on 869829160960 wanted 82376 found 83320
parent transid verify failed on 869829160960 wanted 82376 found 83320
parent transid verify failed on 869829160960 wanted 82376 found 83320
parent transid verify failed on 869829160960 wanted 82376 found 83320
Ignoring transid failure
parent transid verify failed on 869828055040 wanted 82376 found 83315
parent transid verify failed on 869828055040 wanted 82376 found 83315
parent transid verify failed on 869828055040 wanted 82376 found 83315
parent transid verify failed on 869828055040 wanted 82376 found 83315
Ignoring transid failure
parent transid verify failed on 823939305472 wanted 83180 found 83847
parent transid verify failed on 823939305472 wanted 83180 found 83847
parent transid verify failed on 823939305472 wanted 83180 found 83847
parent transid verify failed on 823939305472 wanted 83180 found 83847
Ignoring transid failure
Root objectid is 5
Skipping existing
file /home/xake/Skrivbord/ferra-rescue/var/lib/rpm/.rpm.lock
If you wish to overwrite use the -o option to overwrite
parent transid verify failed on 823805370368 wanted 83121 found 83393
parent transid verify failed on 823805370368 wanted 83121 found 83393
parent transid verify failed on 823805370368 wanted 83121 found 83393
parent transid verify failed on 823805370368 wanted 83121 found 83393
Ignoring transid failure
parent transid verify failed on 823789125632 wanted 83120 found 83356
parent transid verify failed on 823789125632 wanted 83120 found 83356
parent transid verify failed on 823789125632 wanted 83120 found 83356
parent transid verify failed on 823789125632 wanted 83120 found 83356
Ignoring transid failure
parent transid verify failed on 823789125632 wanted 83120 found 83356
Ignoring transid failure
parent transid verify failed on 823784792064 wanted 81189 found 83707
parent transid verify failed on 823784792064 wanted 81189 found 83707
parent transid verify failed on 823784792064 wanted 81189 found 83707
parent transid verify failed on 823784792064 wanted 81189 found 83707
Ignoring transid failure
parent transid verify failed on 823926468608 wanted 83142 found 83754
parent transid verify failed on 823926468608 wanted 83142 found 83754
parent transid verify failed on 823926468608 wanted 83142 found 83754
parent transid verify failed on 823926468608 wanted 83142 found 83754
Ignoring transid failure
parent transid verify failed on 823789125632 wanted 83120 found 83356
Ignoring transid failure
parent transid verify failed on 823790784512 wanted 83120 found 83356
parent transid verify failed on 823790784512 wanted 83120 found 83356
parent transid verify failed on 823790784512 wanted 83120 found 83356
parent transid verify failed on 823790784512 wanted 83120 found 83356
Ignoring transid failure
parent transid verify failed on 823790784512 wanted 83120 found 83356
Ignoring transid failure
parent transid verify failed on 823790784512 wanted 83120 found 83356
Ignoring transid failure
parent transid verify failed on 823928971264 wanted 83126 found 83779
parent transid verify failed on 823928971264 wanted 83126 found 83779
parent transid verify failed on 823928971264 wanted 83126 found 83779
parent transid verify failed on 823928971264 wanted 83126 found 83779
Ignoring transid failure
parent transid verify failed on 823518138368 wanted 83091 found 83318
parent transid verify failed on 823518138368 wanted 83091 found 83318
parent transid verify failed on 823518138368 wanted 83091 found 83318
parent transid verify failed on 823518138368 wanted 83091 found 83318
Ignoring transid failure
parent transid verify failed on 823789125632 wanted 83120 found 83356
Ignoring transid failure
parent transid verify failed on 823790784512 wanted 83120 found 83356
Ignoring transid failure
parent transid verify failed on 823518138368 wanted 83091 found 83318
Ignoring transid failure
restore: ctree.c:777: read_node_slot: Assertion `!(level =3D=3D 0)' fai=
led.
Avbruten (SIGABRT) (minnesutskrift skapad)


So I fired up gdb and took a look:

#0  0x00007f1898406775 in *__GI_raise (sig=3D6)
at ../nptl/sysdeps/unix/sysv/linux/raise.c:64
        resultvar =3D 0
        pid =3D 4127
        selftid =3D <optimized out>
#1  0x00007f1898407a75 in *__GI_abort () at abort.c:93
        save_stage =3D 2
        act =3D {__sigaction_handler =3D {sa_handler =3D 0x7f1898dbd11a=
,
sa_sigaction =3D 0x7f1898dbd11a}, sa_mask =3D {__val =3D {1397436114552=
90,
140736052465056, 139743648404496, 140736052465296, 139743610498902,=20
              206158430232, 140736052465312, 140736052465088,
139743610409080, 206158430256, 140736052465344, 139743648481760,
139743613791840, 1, 0, 140736052474502}}, sa_flags =3D -1739462902,=20
          sa_restorer =3D 0x7f1898dbd08c}
        sigs =3D {__val =3D {32, 0 <repeats 15 times>}}
#2  0x00007f18983ff57e in __assert_fail_base (fmt=3D<optimized out>,
assertion=3D0x7f1898dbd11a "!(level =3D=3D 0)", file=3D0x7f1898dbd08c "=
ctree.c",
line=3D<optimized out>, function=3D<optimized out>) at assert.c:96
        str =3D 0x7f189a8701e0 ""
        total =3D 4096
#3  0x00007f18983ff640 in *__GI___assert_fail (assertion=3D0x7f1898dbd1=
1a
"!(level =3D=3D 0)", file=3D0x7f1898dbd08c "ctree.c", line=3D777,
function=3D0x7f1898dbd791 "read_node_slot") at assert.c:105
No locals.
#4  0x00007f1898da42eb in read_node_slot (root=3D<optimized out>,
parent=3D<optimized out>, slot=3D<optimized out>) at ctree.c:777
        level =3D <optimized out>
        __PRETTY_FUNCTION__ =3D "read_node_slot"
#5  0x00007f1898da1346 in next_leaf (root=3D0x7f189a85d410,
path=3D0x7f189a87d8c0) at restore.c:122
        slot =3D 28
        level =3D 1
        c =3D <optimized out>
        next =3D 0x7f189a9a4790
#6  0x00007f1898da15bb in search_dir (root=3D0x7f189a85d410,
key=3D0x7fffaa6a1390,=20
    dir=3D0x7f189a89e760
"/home/xake/Skrivbord/ferra-rescue/var/lib/yum/yumdb/l/48ab9cbdbbcb080a=
450811f1aecf0abcbb54cfab-libcdio-devel-0.82-5.fc16-x86_64") at restore.=
c:503
        path =3D <optimized out>
        leaf =3D 0x7f189ab41770
        dir_item =3D <optimized out>
        location =3D {objectid =3D 282000, type =3D 1 '\001', offset =3D=
 0}
        filename =3D "changed_by\000y\000estamp\000\000\000\000\000\000=
Z
\004w\v\351F\031\020=D4=85\232\030\177\000\000\000Z\004w\v\351F\031\020=
=D4=85\232
\030\177\000\000\217\022j\252\377\177\000\000\200\277\206\232\030\177
\000\000\060R\263\232\030\177\000\000\271\\\263\232\030\177\000\000\001
\000\000\000\000\000\000\000\020=D4=85\232\030\177\000\000*\006L\230\03=
0\177
\000\000\060\000\000\000\060\000\000\000=C8=AEu\230\030\177\000\000\270=
\256u
\230\030\177\000\000\000\071}\232\030\177\000\000\000\340\000\000\000
\000\000\000\200\000\000\000\000\000\000\000\220\000\000\000\000\000\00=
0
\000\001\000\000\000\t\000\000\000\260\000\000\000\000\000\000\000@\277
\206\232\t\000\000\000\062\000\000\000\000\000\000\000\200P\374\230\030
\177\000\000`\256u\230\030\177\000\000\200\000\000\000\000\000\000\000
\271\\\263\232\030\177\000\000\001\000\000\000\000\000\000\000\020=D4=85=
\232
\030"...
        name_ptr =3D <optimized out>
        name_len =3D <optimized out>
        ret =3D <optimized out>
        fd =3D 32536
        loops =3D <optimized out>
        type =3D 212 '\324'


So any knowledge on how to proceed? Also, is there any documentation fo=
r
"restore" planned, I could not find any information about what the
options really do...

Regards
Peter

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
