Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:59888 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966432AbbDWRgt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 13:36:49 -0400
Date: Thu, 23 Apr 2015 19:36:47 +0200
From: Lennart Poettering <lennart@poettering.net>
To: arnaud gaboury <arnaud.gaboury@gmail.com>
Cc: systemd <systemd-devel@lists.freedesktop.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] install Fedora systemd-nspawn container on btrfs
Message-ID: <20150423173647.GB29760@gardel-login>
References: <CAK1hC9ujeQs_pv6nD6C689hMFQNjMMQdUgt7RFOz0gHjdeSz_A@mail.gmail.com>
 <20150423115056.GA28566@gardel-login>
 <CAK1hC9unKak9ffbwJthki38te5PDB+28iJTN10++gRGLZpfoiA@mail.gmail.com>
 <20150423144708.GB29079@gardel-login>
 <CAK1hC9s9DQaL8-E4_R-4pr-iC0K93D+6Yf-nqqsUsNtfrr74eQ@mail.gmail.com>
 <20150423171248.GD29642@gardel-login>
 <CAK1hC9v65LCt7fu1MGYkx0Gpsb=cwcHVWDP4bcURr7WTK754iQ@mail.gmail.com>
 <CAK1hC9t_N1bTV4Xk_iXiqqAqmN5++fLQwk6UGgtEM4Kqw3PZSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAK1hC9t_N1bTV4Xk_iXiqqAqmN5++fLQwk6UGgtEM4Kqw3PZSQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 23.04.15 19:29, arnaud gaboury (arnaud.gaboury@gmail.com) wrote:

> When in /var/lib/machines/poppy:
> 
> root@hortensia ➤➤ machines/poppy # btrfs subvolume list .
> ID 266 gen 98 top level 5 path rootvol
> ID 268 gen 100 top level 5 path var
> ID 269 gen 101 top level 5 path etc
> ID 271 gen 72 top level 266 path var/lib/machines
> ID 272 gen 77 top level 268 path var/tmp
> ID 273 gen 77 top level 268 path var/lib/machines
> 
> Anyone from the Btrfs ML to help ?

Note that systemd-tmpfiles will create /var/tmp, and /var/lib/machines
as subvolumes these days, if they are missing and on btrfs.

Lennart

-- 
Lennart Poettering, Red Hat
