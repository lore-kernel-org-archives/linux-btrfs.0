From: Chester <somethingsome2000@gmail.com>
Subject: Re: immutable (WORM) file system
Date: Mon, 12 Mar 2012 14:52:47 -0500
Message-ID: <CAAE6i0j4n9_7=swv8NJE1FVToXjPCefT+NtSbbaShs6UBKVQjg@mail.gmail.com>
References: <CAP7LQsLiDC8Y=g+ocQGYdC-4LdpDWs9QkL+PvMD311wR2UY0GQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Fong Vang <sudoyang@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAP7LQsLiDC8Y=g+ocQGYdC-4LdpDWs9QkL+PvMD311wR2UY0GQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

There's support for Read-only snapshots, so you might be able to use
that with some clever scripting =3D\

On Mon, Mar 12, 2012 at 2:36 PM, Fong Vang <sudoyang@gmail.com> wrote:
> Does anyone know if there's a plan to provide an option to make a
> BTRFS filesystem a WORM (write-one-read-many)? =A0So essentially, onc=
e a
> file has been written it cannot be altered nor deleted. =A0To delete
> would require a newfs. =A0I know that there's extended attributes but
> root can alter that on individual files.
>
> Anyway, thanks in advance for any help.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
