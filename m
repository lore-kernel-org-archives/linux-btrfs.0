From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: iscsi target cause kernel oops on btrfs
Date: Fri, 7 May 2010 08:17:09 +0200
Message-ID: <20100507061709.GA8646@mother.pipebreaker.pl>
References: <k2s1495a7251005062230pa88bdf76o91d9b8a48702e5c2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <k2s1495a7251005062230pa88bdf76o91d9b8a48702e5c2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 06, 2010 at 10:30:31PM -0700, jason chan wrote:
> Hi all,
>=20
> I have OpenSUSE and the following rpms:
> iscsitarget-kmp-desktop-1.4.19_2.6.34.0_rc5_6-2.13.i586
> iscsitarget-1.4.19-2.13.i586
>=20
> May =A06 22:11:18 aopen kernel: [ 1201.903664] =A0[<c02fcd05>] ?
> do_sync_write+0xb5/0xf0
> May =A06 22:11:18 aopen kernel: [ 1201.903675] =A0[<c023b688>] ?
> dequeue_entity+0x38/0x1f0
> May =A06 22:11:18 aopen kernel: [ 1201.903687] =A0[<f80dd71e>] ?
> fileio_make_request+0x11e/0x200 [iscsi_trgt]

  I saw it before: http://www.mail-archive.com/linux-btrfs@vger.kernel.=
org/msg02713.html
Never really debugged issue, I've moved to userspace iSCSI implementati=
on,
which works fine.

--=20
Tomasz Torcz               "Never underestimate the bandwidth of a stat=
ion
xmpp: zdzichubg@chrome.pl    wagon filled with backup tapes." -- Jim Gr=
ay

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
