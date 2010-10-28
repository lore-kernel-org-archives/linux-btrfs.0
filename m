From: David Nicol <davidnicol@gmail.com>
Subject: Re: [PATCH v2] Btrfs: allow subvol deletion by unprivileged user with
 -o user_subvol_rm_allowed
Date: Thu, 28 Oct 2010 12:11:27 -0500
Message-ID: <AANLkTimtvMe6UxWG2NTHB3eW3VT=72nv_62f8DxAiO4j@mail.gmail.com>
References: <1288120849-32029-1-git-send-email-sage@newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288120849-32029-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

do the resulting semantics match (or resemble) the semantics provided
by other facilities that allow non-superusers to mount and unmount
file systems?

If all "user mountable file systems" are provided either by the FUSE
layer (but that is concerned with providing the FS, not mounting it)
or by setuid tools, this question may be safe to ignore.

On Tue, Oct 26, 2010 at 2:20 PM, Sage Weil <sage@newdream.net> wrote:
> Add a mount option user_subvol_rm_allowed that allows users to delete=
 a
> (potentially non-empty!) subvol when they would otherwise we allowed =
to do
> an rmdir(2). =C2=A0We duplicate the may_delete() checks from the core=
 VFS code
> to implement identical security checks (minus the directory size chec=
k).
> We additionally require that the user has write+exec permission on th=
e
> subvol root inode.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
