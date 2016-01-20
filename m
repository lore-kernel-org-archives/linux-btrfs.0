Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:55434 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933132AbcATPIF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 10:08:05 -0500
Date: Wed, 20 Jan 2016 20:08:00 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: bo.li.liu@oracle.com, linux-btrfs@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: Kernel 4.4.0 KVM guest on Btrfs locks up on snapshotting
Message-ID: <20160120200800.6858d6ee@natsu>
In-Reply-To: <569F70AA.2030006@redhat.com>
References: <20160120030223.22cc3ae0@natsu>
 <20160120001944.GA9884@localhost.localdomain>
 <20160120100852.470479a6@natsu>
 <569F70AA.2030006@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tFCtLXIvuwn4vCAcQb+ocZ="; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/tFCtLXIvuwn4vCAcQb+ocZ=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Jan 2016 12:34:02 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 20/01/2016 06:08, Roman Mamedov wrote:
> > I don't get any ENOSPC errors on the host, also it doesn't seem to
> > be a slowdown caused by disk I/O searching for free space, just a
> > complete lock-up: I monitor the guest with 'ping', and when it
> > happens, the ping responses stop immediately and do not return,
> > also there is no reaction to any keypress in the KVM VNC window.
>=20
> Can you go to the QEMU monitor (Ctrl-Alt-F2 typically, or just add
> "-monitor stdio" to the QEMU command line) and type "info status"?

Aha, now this is getting somewhere.
------------------
(qemu) info status
VM status: paused (io-error)

(qemu) info block
hd: vm.img (raw)
    I/O status:       nospace
    Detect zeroes:    unmap

ide1-cd0: [not inserted]
    Removable device: not locked, tray closed

floppy0: [not inserted]
    Removable device: not locked, tray closed

sd0: [not inserted]
    Removable device: not locked, tray closed

(qemu) info block-jobs
No active jobs
------------------

So this seems to be an transient ENOSPC error returned to the data writing
process by the FS during snapshotting. I can now reproduce this without KVM,
just with dd. Seems not much to do with KVM then, I will post more details =
to
the btrfs list. Thanks!

--=20
With respect,
Roman

--Sig_/tFCtLXIvuwn4vCAcQb+ocZ=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlafotAACgkQTLKSvz+PZwjasACfWcsxV6stukHnqSjaXlbw76hx
y1wAn0Ewyg5XIvR5xmX+3tRKcPCAPB4+
=5aMo
-----END PGP SIGNATURE-----

--Sig_/tFCtLXIvuwn4vCAcQb+ocZ=--
