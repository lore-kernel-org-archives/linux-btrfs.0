Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:59953 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbbDFIhi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Apr 2015 04:37:38 -0400
From: Russell Coker <russell@coker.com.au>
To: Pavel Volkov <sailor@lists.xtsubasa.org>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs hangs 3.19-10
Date: Mon, 6 Apr 2015 08:37:33 +0000
References: <CAGqmi74e_U5-UVUy+MHbxc2f-38pRyjK1Zo0Up-V9ndFpv-bXA@mail.gmail.com> <20150405100417.GE13864@carfax.org.uk> <2f6a9ac9-0684-4b9a-982e-031286be398e@lists.xtsubasa.org>
In-Reply-To: <2f6a9ac9-0684-4b9a-982e-031286be398e@lists.xtsubasa.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201504060837.33776.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 6 Apr 2015 07:40:03 AM Pavel Volkov wrote:
> On Sunday, April 5, 2015 1:04:17 PM MSK, Hugo Mills wrote:
> >    That's these, I think:
> > #define BTRFS_FEATURE_INCOMPAT_BIG_METADATA     (1ULL << 5)
> > #define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF    (1ULL << 6)
> > 
> > so it's definitely -O^extref. I don't see where big_metadata comes
> > from, though. That's not a -O option. Try with -O^extref and see where
> > that gets you. (Also, don't mount the FS on a newer kernel -- it may
> > be setting big metadata automatically, although it probably shouldn't
> > do).
> 
> By the way, is there any way to see which options are enabled on a local
> filesystem without having to try mounting it with old kernel and checking
> dmesg?

# file -s /dev/dm-0 
/dev/dm-0: BTRFS Filesystem sectorsize 4096, nodesize 4096, leafsize 4096, 
UUID=97d70558-ddea-493e-874c-ff74be9ce099, 92390113280/171796594688 bytes used, 
1 devices

Above is what file(1) reports on my laptop which has been running BTRFS since 
3.2 days.  It gives the node size etc but not the feature flags.  Some time ago 
I submitted a patch to the Debian package that covered everything I could 
figure out, I'm sure that they would accept a patch for feature flags if anyone 
can work out how to do it.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
