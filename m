From: cwillu <cwillu@cwillu.com>
Subject: Re: Cannot Deinstall a Debian Package
Date: Thu, 5 May 2011 15:50:57 -0600
Message-ID: <BANLkTi=yvNjaJAf+XOnssUhcWXuf7W_EVg@mail.gmail.com>
References: <201105031227.43619.CACook@quantum-sci.com>
	<201105051357.07209.CACook@quantum-sci.com>
	<1304629163.11048.7.camel@havelock.liw.fi>
	<201105051448.25771.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105051448.25771.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 5, 2011 at 3:48 PM,  <CACook@quantum-sci.com> wrote:
> On Thursday 5 May, 2011 13:59:23 Lars Wirzenius wrote:
>> dpkg --fsys-tarfile foo.deb | tar -C / -tf -
>
> I was expecting this to extract into the local directory, although it=
 seems to have extracted into the final destinations. =C2=A0Can't be su=
re. =C2=A0grub-setup -V gives the new version.
>
>
>> change -t to -x to actually extract
>
> I don't see the distinction. =C2=A0It does seem to have extracted.

tar -t just lists the contents, -x actually does an extract.

It's plausible that the update you attempted before did actually
unpack the files to their locations, and only failed to run the
post-install scripts.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
