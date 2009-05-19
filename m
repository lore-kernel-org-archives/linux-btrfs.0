From: Claudio Martins <ctpm@ist.utl.pt>
Subject: Re: extended acls..
Date: Tue, 19 May 2009 21:01:50 +0100
Message-ID: <200905192101.50836.ctpm@ist.utl.pt>
References: <42ab06770905190950x5077edb0s3c55bd1c39ebeebe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Sriram Ramkrishna <sriram.ramkrishna@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <42ab06770905190950x5077edb0s3c55bd1c39ebeebe@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 19 May 2009, Sriram Ramkrishna wrote:
>
> I'm curious if there is any plans to add extended acls ala AFS?  The
> reason I ask is that it seems in Linux we don't seem have moved off o=
f
> POSIX style acls and I think there is definitely at least from my
> perspective that having a richer set of acl would be needed.  For
> instance, we would need acls to deal with controlled countries if we
> are sharing data with them etc.  It is a big shame that there is no
> RFC for extended ACLs.
>

 Hi,

 As other people on this list have already said, the right implementati=
on=20
might not be through BTRFS. But IMHO if you are looking at extended ACL=
s=20
beyond what is already provided by many linux filesystems, you could lo=
ok at=20
NFS4 ACLs, which have semantics which should fit Linux and Posix better=
 than=20
AFS ACLs. Also, AFS ACLs being per directory and not per file, would be=
 less=20
flexible than NFS4's.

 Regards

Cl=C3=A1udio

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
