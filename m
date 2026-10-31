Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793457264;
	b=31Lm56T1EQyDCdcMjz1+SRO6FXit9lnAoRgMJSyadGuoJpgLL9wV446qpSq4UAy/sQyq
	 k47TpQRaeerf/oCmwsUFDol5lcN/hvaZoDq/ADK+ggdz63XAhQMnvVoqqQGbhewe3Qmrq
	 d2fdjLm08mocZWLi+H9WSPrT++rnmewThPNVEHxr5IO5z0yTRMBTIBryGMokrw17yRumD
	 rI3ztF1aAbjt+seO9PPO7mF06yF6yOiLiBD5xm20+0Se17XZr+bmPOYg8jRW/fAw5jx1H
	 OARpIB3e0rL2cZNu3Vr+U7Z1soMAzZ5LrtXPc/ulC6wGKIn3P3h8ui1vdlRxRG+NyDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793457264;
	h=Received:DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:User-Agent;
	bh=wmUlHuqBLh5kgE9P0I7jDj71Idh4M39E1I25dVG2A0o=;
	b=Pyq3aZLSjabLm5nFYMjzNt2lkQO8D0xv9gkO8s0xtbsO5CvR6bk+q9cCpd98OOxjQye5
	 /hiFVQGn0hPux0tLZ/VZ9AbrjBaaxAeE4i/BPSBwwer5vSyxtJc37a9by29tKijNCYdmr
	 sjVScjrVdw/Dw98j/vK88RS+RPW7vBlcR6cu7H5OMDQ3FeaGYjbCFu5QcQmiiQMMwDCFV
	 nLeiqGgztzTMoLq7eCFbrJMbjC62gXPXlI3OnznEidwYnC9zy6rSn8aKldHVj1XSas64v
	 +QTcjAwBsDvD2big0sWcXtOdIxiAUwOIJgK3bSPm1pUoo7oPLOf788lfQEJD2VZ6VNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jUCsnsfW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5471F606A31A;
	Sat, 31 Oct 2026 14:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jUCsnsfW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0935A1F00919;
	Sat, 31 Oct 2026 14:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793457264;
	bh=wmUlHuqBLh5kgE9P0I7jDj71Idh4M39E1I25dVG2A0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jUCsnsfWetnqFakKIw+xGL5zpziAhBDKe1hm5Aq4qLgkVwdgC6wJy1uN0js2ptJGf
	 rIuGVTof7ztnNfHEpMcMdFbbgmPj/cHbo09ThqHqUtLXdp60ksbu3EdJQlLADoiWDg
	 rdgXNTK9ilG9E0pXcoduUfVKHj3Zd1Z2J6BNBKYNcCbsVMAVqv7uyGayyyyovOwnTp
	 G5h5wyuFwBuMQa/GVZ8XJiWo+ToWf7jTKF/x7Xe2phPvpuBGmIRYJG9CyMmq3ivAen
	 I1AKgCxqjfBnQUhCwdZoEzL5aE/2/z+w5p6PPXYTDxOddMAnFpng/9ze6MO+53pFLz
	 W/S6DsKbk5Xvg==
Received: by pali.im (Postfix)
	id A0AC0809; Sat, 31 Oct 2026 15:34:20 +0100 (CET)
Date: Sat, 31 Oct 2026 15:34:20 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: koraynilay <koray.fra@gmail.com>, David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Chris Mason <mason@kernel.org>, Jan Kara <jack@suse.cz>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Sean Smith <defendthedisabled@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Pedro Falcato <pfalcato@suse.de>
Subject: Re: [RFC PATCH v2 1/2] vfs: add provenance time (ptime)
Message-ID: <20261031143420.is7g6wgdpwbo6wvz@pali>
References: <20261028134728.294127-1-koray.fra@gmail.com>
 <20261028134728.294127-2-koray.fra@gmail.com>
 <auILs54TUcWXf3us@pedro-suse.tail5790ac.ts.net>
 <auMzpUIEmGCE_x_N@amir-ThinkPad-T480>
 <CAOQ4uxiuy0VwZj+3M-zRqQ49WTpHZpiaQ+6MZ8z8WdLjyQM_zA@mail.gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxiuy0VwZj+3M-zRqQ49WTpHZpiaQ+6MZ8z8WdLjyQM_zA@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Saturday 31 October 2026 15:18:05 Amir Goldstein wrote:
> On Thu, Oct 29, 2026 at 12:53 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Wed, Oct 28, 2026 at 02:56:39PM +0000, Pedro Falcato wrote:
> > > On Wed, Oct 28, 2026 at 02:47:27PM +0100, koraynilay wrote:
> > > > Add provenance time (ptime), indicating the time when a file or
> > > > directory was created. This is user-settable via file_setattr() and
> > > > retrievable via statx(2) (using STATX_PTIME) or file_getattr().
> > > >
> > > > The semantics of when to preserve this new timestamp are the same as
> > > > mtime, the idea being that there is a correspondence like this:
> > > >
> > > > ctime <-> btime
> > > > mtime <-> ptime
> > > >
> > > > so every operation (copying, moving, ...) that currently preserves mtime
> > > > should also preserve ptime.
> > > >
> > > > Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepting
> > > > FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
> > > > xflags, and use it in fileattr_to_file_attr()/file_attr_to_fileattr() to
> > > > allow ptime to be used with the file_setattr()/file_getattr() syscalls.
> > >
> > > Random comment, but: could this be doable with xattrs instead? I'm not sure
> > > where I would put the xattrs code (if in userspace exclusively, or if hooking
> > > the VFS up with this, or if doing it on the filesystem side), but it would
> > > surely be less disruptive than modifying a bunch of filesystems one-by-one.
> > >
> > > This patch is quite simple, but changing btrfs, then ext4, xfs, etc is a
> > > mess, and inevitably you can't get these timestamps until you upgrade your
> > > filesystems.
> > >
> >
> > I disagree.
> >
> > I think that creation time should be a first class property in
> > filesystems that support it.
> >
> 
> One of the reasons that I think this API is a good match for the Windows
> style creation time is that it was already discussed as an API for the
> Windows style DOS attributes [1].
> 
> koraynilay,
> 
> In your next posting, I suggest that you first demonstrate how the proposed
> API is used to facilitate filesystems that already support a user-settable
> creation time (smb, ntfs,vfat,exfat), before adding btrfs support.

FYI, also nfs4 (the protocol itself) supports setting and changing the creation time.
And maybe there are more filsystems which support it...

I think that ufs2 on FreeBSD supports changing it via utime() syscall.

> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/linux-fsdevel/20241227121508.nofy6bho66pc5ry5@pali/
