Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36974 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964958AbdJQNOK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 09:14:10 -0400
Date: Tue, 17 Oct 2017 15:12:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "kernelci.org bot" <bot@kernelci.org>,
        Kernel Build Reports Mailman List
        <kernel-build-reports@lists.linaro.org>,
        "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>,
        Carlos Munoz <cmunoz@caviumnetworks.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@linaro.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: next/master build: 214 builds: 29 failed, 185 passed, 29 errors,
 68 warnings (next-20171016)
Message-ID: <20171017131220.GX3521@suse.cz>
Reply-To: dsterba@suse.cz
References: <59e53a9c.0a98df0a.acf5c.fc96@mx.google.com>
 <CAK8P3a1Qk+H3zp23zR=3Wsh-Yp3YOZ0bF6BNcFHjnEHd9XnCjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAK8P3a1Qk+H3zp23zR=3Wsh-Yp3YOZ0bF6BNcFHjnEHd9XnCjA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 17, 2017 at 11:00:04AM +0200, Arnd Bergmann wrote:
> > 2 fs/btrfs/tree-checker.c:186:4: warning: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'unsigned int' [-Wformat=]
> > 1 fs/btrfs/tree-checker.c:186:70: warning: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'unsigned int' [-Wformat=]
> 
> I sent a patch a few days ago, Dave Sterba reviewed it, but it hasn't
> gone in yet.

The patch was picked last Friday, and is now part of linux-next tree

https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git/commit/?h=for-next&id=6881041b521fff47c3b31269ec9b8b5ebe7d631e

There might be a few days delay, caused by testing, before my kernel.org
for-next branch is updated and then picked by linux-next.
