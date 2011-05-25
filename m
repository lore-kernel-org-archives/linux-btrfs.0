From: Josef Bacik <josef@redhat.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference
Date: Wed, 25 May 2011 15:34:11 -0400
Message-ID: <4DDD59B3.9000300@redhat.com>
References: <BANLkTikKAfPgutxW0Su0v0jZ1LnSA495hw@mail.gmail.com> <BANLkTik_=otvE_bfyjSQ2NoG6VVh_zgQKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: =?ISO-8859-1?Q?matthieu_Barth=E9lemy?= <bonsouere@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTik_=otvE_bfyjSQ2NoG6VVh_zgQKg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/25/2011 01:41 PM, matthieu Barth=E9lemy wrote:
> Finally I successfully remounted my partition. Here is how I've done
> to recover, in case it can help someone else :
>  I had to clone btrfs-progs-unstable tree.
> Then checkout branch "tmp" (because I use compression, default
> btrfs-progs are "too old"
> Then I compiled btrfs-zero-log with "make btrfs-zero-log"
> And finally ran "./btrfs-zero-log /dev/sda2"
>=20
> Now I'm copying everything to a new partition, because I don't know i=
f
> can safely use the damaged one.
>=20
> But wouldn't it be possible to avoid the "Null pointer" kernel crash
> by checking what we do inside replay_one_buffer, and then
> automatically clear log, or provide a "clear_log" mount option?
> Any idea about what could have caused my problem?
>=20

Can you do a

gdb btrfs.ko

and then do

list *(add_inode_ref+0x1e7)

so I can see where it is.  It doesn't seem like either of those
read_extent_buffer's should screw up, either we do the proper checks or
it should have gone sideways before you got there.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
