From: Arand Nash <ienorand@gmail.com>
Subject: Re: Snapshot rollback
Date: Tue, 25 Oct 2011 04:04:43 +0200
Message-ID: <4EA6193B.30104@gmail.com>
References: <4EA46E3A.9090307@cfl.rr.com> <loom.20111024T071806-3@post.gmane.org> <4EA60690.7080401@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EA60690.7080401@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 25/10/11 02:45, Phillip Susi wrote:
 > (...)
>
> On 10/24/2011 01:45 AM, dima wrote:
>> Hello Phillip,
>> It is hard to judge without seeing your fstab and bootloader config. Maybe your
>> / was directly in subvolid=0 without creating a separate subvolume for it (like
>> __active in Goffredo's reply)? In my very humble opinion, if you have your @home
>> subvolume under subvolid=0 and then change the default subvolume, it just cannot
>> access your @home any more.
>
> Why can't it?
>
> It appears that Ubuntu sets up two subvols, one named @ and one named
> @home, and mounts them at / and /home respectively.  The boot loader was
> set to pass rootflags=subvol=@.  After changing the default volume, the
> system would not boot until I removed that rootflags argument, then it
> mounted the snapshot correctly as the root, but refused to mount /home,
> giving this nonsense error that /dev/sda1 is not a valid block device.
 >
 > (...)

Btrfs is unfortunately unable to look for snapshots by name above the 
currently set default root (I do not know why exectly), it can however 
find them by id anywhere.

In the case of (Debian?) Ubuntu, you should pretty much stay away from 
set-default.

What happens is Ubuntu mounts the _default_ subvolume, which in the 
normal case refers to the top of the btrfs tree (alias subvolid=5), then 
it looks below this for the subvolumes ("directories") named "@/" (given 
by the boot option) and "@home/" (given in fstab).

Now, when you use set-default here, it will instead mount that subvolume 
as the default, and then look _below_ that for "@/" and "@home/", 
obviously, this won't work, since these exist higher up in the tree.

When you disable the rootflags argument, btrfs assumes the default 
subvolume is the root, which works, as noted.

In order to find "@home/", you could rewrite the fstab to instead of 
"subvol=@home" read "subvolid=###", since by specifying id instead of 
name, it can find it anywhere in the tree, the subvolid can be found via
~# btrfs subvolume list /


HOWEVER, this is not the way btrfs is intended to be used on Ubuntu.
As mentioned earlier, you likely will not want to touch set-default, 
instead, when you want to muck around with your mounting sobvolumes, you 
just use mv:

To backup
~# mount /dev/sda1 /mnt
~# ls /mnt
@ @home
~@ btrfs sub snap /mnt/@ /mnt/@rootsnap
~# ls /mnt
@ @home @rootsnap

And to rollback:
~# mv /mnt/@ /mnt/@rootmessy
~# mv /mnt/@rootsnap /mnt/@
And just reboot, since it just mounts whatever is named "@/".


Now in your case, if you want to go back to the Ubuntu default btrfs 
setup, you would:
~# btrfs subvolume set-default 5 /
(since id 5 is always the top of the tree)
And reinstate the rootflags boot option.


Hope that explains some of it.

--
Martin Werner ("arand")
