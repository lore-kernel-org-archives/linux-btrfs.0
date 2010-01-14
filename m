From: Paul Komkoff <i@stingr.net>
Subject: Re: btrfs fallocate woes
Date: Thu, 14 Jan 2010 18:24:06 +0000
Message-ID: <715ea5c11001141024n8a6fa6fy95dfea4d991686c9@mail.gmail.com>
References: <715ea5c11001140328g6198447axce1ba884a6e6fb96@mail.gmail.com>
	 <aday6k0lhpx.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Roland Dreier <rdreier@cisco.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <aday6k0lhpx.fsf@roland-alpha.cisco.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 14, 2010 at 5:27 PM, Roland Dreier <rdreier@cisco.com> wrot=
e:
> My fallocate man page says:
>
> =A0 =A0 =A0 Because allocation is done in block size chunks, fallocat=
e() may
> =A0 =A0 =A0 allocate a larger range than that which was specified.
>
> so the btrfs behavior seems OK to me.
>
> You say this is a regression. =A0What btrfs version behaved different=
ly?

Err. My wording may not be very precise.
I see this as the regression from every other filesystem, to the
extent that rsync --preallocate will give you directory tree full of
corrupted files.

Also, your man page also says something else:
       If  FALLOC_FL_KEEP_SIZE  flag is not specified in mode, the
default behavior is almost same as when this flag is specified.  The
only difference is that on
       success, the file size will be changed if offset + len is
greater than the file size.   This  default  behavior  closely
resembles  the  behavior  of  the
       posix_fallocate(3) library function, and is intended as a
method of optimally implementing that function.

See, here nothing says to which value file size will be changed. Also,
posix_fallocate man page (which is actually a shortcut to
fallocate(fd, 0, ...)) says:
       If the size of the file is less than offset+len, then the file
is increased to this size; otherwise the file size is left unchanged.

Nowhere there it is said that size is ceil()'d to a blocksize.
Moreover, I never saw an app that does fallocate() and then
ftruncate() - every single app out there assumes that posix_fallocate
(and fallocate, fwiw), while may allocate more space, will set the
file size to something different than offset+len.
--=20
This message represents the official view of the voices in my head
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
