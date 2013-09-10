Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab3IJVWG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 17:22:06 -0400
Message-ID: <522F8D72.6060303@suse.com>
Date: Tue, 10 Sep 2013 17:21:54 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
Cc: Mark Fasheh <mfasheh@suse.de>, Christoph Hellwig <hch@infradead.org>,
        viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Andrew Vagin <avagin@gmail.com>
Subject: Re: [PATCH][RESEND] vfs: allow /proc/PID/maps to get device from
 stat
References: <20130807195718.GC31381@wotan.suse.de> <20130807201826.GA23804@infradead.org> <20130807205146.GE2397@localhost.localdomain> <20130808121349.GC5180@infradead.org> <20130808130207.GA16712@localhost.localdomain> <20130808134805.GB24181@infradead.org> <20130808154454.GF16712@localhost.localdomain> <20130812114752.GA2390@infradead.org> <20130910153655.GH31381@wotan.suse.de> <20130910155607.GC2446@localhost.localdomain>
In-Reply-To: <20130910155607.GC2446@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="riA1dt0A9lsS1dQKaalFI6txiccIV79Ms"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--riA1dt0A9lsS1dQKaalFI6txiccIV79Ms
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 9/10/13 11:56 AM, Josef Bacik wrote:
> On Tue, Sep 10, 2013 at 08:36:55AM -0700, Mark Fasheh wrote:
>> On Mon, Aug 12, 2013 at 04:47:52AM -0700, Christoph Hellwig wrote:
>>> On Thu, Aug 08, 2013 at 11:44:54AM -0400, Josef Bacik wrote:
>>>> On Thu, Aug 08, 2013 at 06:48:05AM -0700, Christoph Hellwig wrote:
>>>>> On Thu, Aug 08, 2013 at 09:02:07AM -0400, Josef Bacik wrote:
>>>>>> This won't work, try having 10000 subvolumes with dirty inodes and=
 do sync then
>>>>>> go skiing, you'll have time :).  Thanks,
>>>>>
>>>>> Why would the dirty inodes make any difference?  If you share the b=
di
>>>>> between the subvolumes the sync workflow should be exactly the same=

>>>>> still.
>>>>>
>>>>
>>>> If we could dis-entangle vfsmounts from sb's and have it so you coul=
d have
>>>> multiple vfsmounts with just one sb that would solve at least the in=
-kernel
>>>> confusion, but I think we still have the userspace confusion.  Thank=
s,
>>>
>>> I think it would mostly solve userspace confusion, as userspace only
>>> sees mounts and the device names.
>>>
>>> But please fix this up properly instead of propagating the effects of=

>>> the nasty btrfs hack that should never have been merged in that form
>>> further up the stack.
>>
>> Can one of you explain how this solves the problem that userspace is g=
etting
>> different devices for the same inode?
>>
>> Seriously, I've been looking into it and I'm a bit lost. I followed th=
e
>> converstaion until here but I don't see how any of the proposed change=
s
>> actually *fix* anything? Also, what is the relationship between vfsmou=
nts
>> and sb today? Wouldn't a bind mount produce the situation of more than=
 1
>> vfsmount per sb that is described above?
>>
>> Sincerely, someone who would like to fix this ABI breakage that has be=
en
>> going on for years.
>=20
> And let me restate the problem so we're all on the same page.
>=20
> Btrfs has subvolumes, completely separate trees within the file system.=
  These
> trees get their own object numbering, which in turn is how we do our in=
ode
> numbers.  So if you have multiple subvolumes, they will likely have the=
 same
> inode numbers within the same file system.  This screws up things like =
rsync
> which say "hey look, these two inodes are the same, lets skip them."  S=
o we have
> an anonymous dev so we can make them look different.
>=20
> Now if we were to make each subvol its own vfsmount (essentially a bind=
 mount)
> and remove the anonymous device that wouldn't fix the problem _at all_.=
  The
> file system would appear to be the same to rsync and it wouldn't back s=
tuff up.
> So we still need some way of telling userspace that this object is diff=
erent.
>=20
> I'm not convinced vfsmounts is the way to do this, it doesn't do anythi=
ng other
> than add a whole lot of complexity to our mounting/subvolume mechanism =
that is
> already relatively complex.  Thanks,

Agreed. It's hugely wasteful as well. We can have thousands of
subvolumes even on modest systems like workstations when automated
snapshots are involved. Using a vfsmount for each subvolume would make
/proc/mounts pretty useless. Having a separate superblock for each one,
at 1k a pop, would waste a ton of memory considering that they'll be
identical except for the dev_t.

The only way vfsmounts would work is if we added a dev_t there, which
would usually be set to ->mnt_sb->s_dev except for the btrfs case. That
still doesn't solve the polluted /proc/mounts, though.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--riA1dt0A9lsS1dQKaalFI6txiccIV79Ms
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSL411AAoJEB57S2MheeWyhAEP/2hSx14oEGXiaB68wvTsP1mL
eUSaAASvw5tgovMnCrj/4+e/agXd/KNWXN26iuypsnmlNuS/pGSXgklXhRTdiLdk
GCZcAyJBHhXqxD06etpaXSq8lrbn5B51YtMsOIxiB5ZgoedPoJZypZEmIW3WfeKB
b5e7B4LdlWtyAgj+phMkUROy2yszYAEiEhITPy6fb7Lzlyu+NXd3kYNUrv05TRr+
57UPdIWVD+VV4kWkQzubQThW/nn7K78qX9JEJcpvqs0G9hihqrJAD1LY4AhZCi4w
HL/+iYRZ/Ag3p3teauMPT/dPfyIIi0nP/tL48jXxRnuZDPtoFB9dop1N7+T+3bkv
1hDoydgsR7HC1jyVzgl5zvQsomoR/zJFCRIJQdtPTg4v3NkfnUmFi9oKhcZzGoyP
CoVv3U45yZ8Kkj8r2BL5kSMX7pMJsQrDw+v85R7KjtxQcdnaCsafxowd3hGzanaH
ysTFmcSuRZtEbKv3yJF+XJeamyIa5JMozb0hlLG8r3d5pcI3PPuc2lAPIM/X+Cga
fXR8aiu2yPxBtA+HyA3hyG2qoxLjH/+ii69i4JetowH9e1RiT5LQhDF8+hjL0bTS
daF9ES5QbvQVeSmZhWqDbDwI0BMVaMs+MxMcSIwJqRkj1FvyUtv0qmfMTARhTxdV
WcCwjwjJP9b1QAzJJo35
=9gyp
-----END PGP SIGNATURE-----

--riA1dt0A9lsS1dQKaalFI6txiccIV79Ms--
