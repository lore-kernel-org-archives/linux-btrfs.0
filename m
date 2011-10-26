From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Snapshot rollback
Date: Tue, 25 Oct 2011 21:30:58 -0400
Message-ID: <4EA762D2.2020605@cfl.rr.com>
References: <4EA46E3A.9090307@cfl.rr.com> <loom.20111024T071806-3@post.gmane.org> <4EA60690.7080401@cfl.rr.com> <4EA6193B.30104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Arand Nash <ienorand@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EA6193B.30104@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/24/2011 10:04 PM, Arand Nash wrote:
> Btrfs is unfortunately unable to look for snapshots by name above the
> currently set default root (I do not know why exectly), it can however
> find them by id anywhere.

Ok, so looking up subvols by name uses the default subvol to resolve the
name, and so when I change the default subvol to the snapshot of @,
there is no @home name there pointing to the subvol?  Things make much
more sense knowing that.  I thought that the subvolumes had their own
namespace outside of any one subvolume.

Is there a way to create another name entry in @snap that points to
@home, or can you only have the original @home entry in the default subvol?

> To backup
> ~# mount /dev/sda1 /mnt
> ~# ls /mnt
> @ @home
> ~@ btrfs sub snap /mnt/@ /mnt/@rootsnap
> ~# ls /mnt
> @ @home @rootsnap
> 
> And to rollback:
> ~# mv /mnt/@ /mnt/@rootmessy
> ~# mv /mnt/@rootsnap /mnt/@
> And just reboot, since it just mounts whatever is named "@/".

Perfect... I think I'll keep the default subvol mounted under /.subvols
to make managing them easy.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk6nYtIACgkQJ4UciIs+XuJ/CQCgsbMLAY/h9opq/T7qBJKKrSz2
v0cAnRq8PKp1jx9r4Q6X4J6Ixjv3KpeS
=GSCn
-----END PGP SIGNATURE-----
