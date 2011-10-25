From: Edward Ned Harvey <kernel@nedharvey.com>
Subject: RE: how stable are snapshots at the block level?
Date: Tue, 25 Oct 2011 08:04:56 -0400
Message-ID: <000801cc930e$53407460$f9c15d20$@nedharvey.com>
References: <CAKvOHKABup6D2pwbiZpCfxoHt7Obv6sHAZqcPp=ce9ZcJ8-vuw@mail.gmail.com> <000101cc918d$3ffb45b0$bff1d110$@nedharvey.com> <CAKvOHKCjxxKTahivOuRBPBB89JBrTwndQ6cCEuFaPbJr8PYtpA@mail.gmail.com> <000001cc9255$2b34fc70$819ef550$@nedharvey.com> <slrnjaavrd.ml8.stephane.chazelas@spam.is.invalid> <000501cc930b$cae17bc0$60a47340$@nedharvey.com> <slrnjad98d.d1s.stephane.chazelas@spam.is.invalid>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "'Stephane CHAZELAS'" <stephane_chazelas@yahoo.fr>,
	<linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <slrnjad98d.d1s.stephane.chazelas@spam.is.invalid>
List-ID: <linux-btrfs.vger.kernel.org>

> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Stephane CHAZELAS
> 
> rsync won't work if you've got snapshot volumes though (unless
> (etc blah)

Please read the OP.  He is currently using rsync to backup his snapshots and
is not worried about the present state of the filesystem - only the
snapshots.  He's looking for something faster.

