From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: Using SSDs for caching?
Date: Thu, 18 Jun 2009 17:55:30 +0200
Message-ID: <20090618155530.GA16819@mother.pipebreaker.pl>
References: <D3FA806D-C1A1-455F-A4E0-81AAD3E5C615@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <D3FA806D-C1A1-455F-A4E0-81AAD3E5C615@karlsbakk.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 18, 2009 at 03:56:23PM +0200, Roy Sigurd Karlsbakk wrote:
> I have heard/read about systems from Sun and NetApp using SDs for =20
> caching. Sun uses different SDs for read and write caching (one being=
 =20
> faster for reads and the other for writes). The storage solution from=
 =20
> Sun is based on Solaris with ZFS.
>
> I know too little about filesystems design to know exactly how they d=
o =20
> this, but can someone think of a way this could be implemented in btr=
fs?=20

  Linux already has second-level=C2=B9 cache layer, it called FS-Cache.=
 For now,
the sole user is NFS. btrfs could take advantage of FS-Cache also.

=C2=B9 first-level is page cache in RAM

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
