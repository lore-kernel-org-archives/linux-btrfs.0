From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: Oops while attempting to mount degraded multi-device raid1
	data/metadata btrfs filesystem
Date: Fri, 26 Mar 2010 14:15:27 -0700
Message-ID: <93cdabd21003261415g45b31a40saa00d378d0e1f748@mail.gmail.com>
References: <93cdabd21003051219m6238b1b8nd88ca7fc3724d67a@mail.gmail.com>
	 <93cdabd21003261049h4a468bf6ubd7bb8be1ac68d41@mail.gmail.com>
	 <20100326180639.GF6334@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100326180639.GF6334@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 26, 2010 at 11:06 AM, Josef Bacik <josef@redhat.com> wrote:
> On Fri, Mar 26, 2010 at 10:49:57AM -0700, Mike Fedyk wrote:
>> I still get this oops with the latest btrfs kernel code from git (as
>> of =C2=A02010-03-21) compiled against 2.6.32.9-70.fc12.x86_64
>>
>
> Will you try this patch
>
> [PATCH] Btrfs: fail to mount if we have problems reading the block gr=
oups
>
> and see if it works? =C2=A0Thanks,
>
> Josef
>

As already discussed on irc....

With that patch it doesn't oops anymore, but it still doesn't mount.

I get this kernel output:
btrfs: failed to read the system array on sda7
btrfs: open_ctree failed
device fsid 3546a1a7a4563c4b-2b1289f58c64988c devid 1 transid 974 /dev/=
sda7
btrfs: allowing degraded mounts
=46ailed to read block groups: -5
btrfs: open_ctree failed

btrfs-debug-tree crashes on the FS:

# time btrfs-debug-tree /dev/sda7 > /tmp/sda7-debug-tree.out
failed to read /dev/sde
failed to read /dev/sdd
failed to read /dev/sdc
failed to read /dev/sdb
btrfs-debug-tree: volumes.c:1381: btrfs_read_sys_array: Assertion
`!(ret)' failed.
Aborted (core dumped)

real    0m0.304s
user    0m0.001s
sys     0m0.016s


# wc /tmp/sda7-debug-tree.out
0 0 0 /tmp/sda7-debug-tree.out

# rpm -qa |grep -i btrfs
btrfs-progs-0.19-9.fc13.x86_64

I'll leave this patch running in my btrfs module for every-day testing.

I'll await any patches you'd like me to test.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
