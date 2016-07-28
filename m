Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:53401 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757122AbcG1MCm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 08:02:42 -0400
Subject: Re: [sparc64] mkfs.btrfs bus error / align issue?
To: Anatoly Pugachev <matorola@gmail.com>, dsterba@suse.cz
References: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
 <20160727195609.GN30795@twin.jikos.cz> <20160728094441.GO30795@twin.jikos.cz>
 <CADxRZqwTUaZyDipvmGcfk8Q9P2X_NLQ=9svtc8BbKeFqoFVPdw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        debian-sparc <debian-sparc@lists.debian.org>
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Message-ID: <d23b0f67-f982-2088-cb72-c8fbd2c73b7a@physik.fu-berlin.de>
Date: Thu, 28 Jul 2016 14:02:35 +0200
MIME-Version: 1.0
In-Reply-To: <CADxRZqwTUaZyDipvmGcfk8Q9P2X_NLQ=9svtc8BbKeFqoFVPdw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/28/2016 01:58 PM, Anatoly Pugachev wrote:
> but where do I get -devel branch of btrfs-progs?
> I just tried git://repo.or.cz/btrfs-progs-unstable/devel.git , but
> still seeing last commit in it:

glaubitz@ikarus:~/upstream/devel$ git checkout devel
Branch devel set up to track remote branch devel from origin.
Switched to a new branch 'devel'
glaubitz@ikarus:~/upstream/devel$ git log | head -n 10
commit 8f88fca93afc870de9783b0179c6e8d1b9f0cbf3
Merge: bf80586 366983b
Author: David Sterba <dsterba@suse.com>
Date:   Tue Jul 26 19:43:50 2016 +0200

    Merge branch 'foreign/qu/fsck-lowmem-v2.1-fixups' into devel

commit bf80586481a4fa1c27571078dddc9392537aacf0
Author: David Sterba <dsterba@suse.com>
Date:   Tue Jul 26 19:33:12 2016 +0200
glaubitz@ikarus:~/upstream/devel$

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer - glaubitz@debian.org
`. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
