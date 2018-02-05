Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48955 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750855AbeBEW4C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Feb 2018 17:56:02 -0500
Date: Mon, 5 Feb 2018 23:53:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] btrfs: Remove custom crc32c init code
Message-ID: <20180205225347.GK18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1515404705-490-1-git-send-email-nborisov@suse.com>
 <1515404705-490-3-git-send-email-nborisov@suse.com>
 <CAHp75VeXC=ig=P1xeFDQTvMn+FP2oGWN2SgbOmTZQj+C-K6EWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHp75VeXC=ig=P1xeFDQTvMn+FP2oGWN2SgbOmTZQj+C-K6EWg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 02, 2018 at 09:46:40PM +0200, Andy Shevchenko wrote:
> On Mon, Jan 8, 2018 at 11:45 AM, Nikolay Borisov <nborisov@suse.com> wrote:
> > The custom crc32 init code was introduced in
> > 14a958e678cd ("Btrfs: fix btrfs boot when compiled as built-in") to
> > enable using btrfs as a built-in. However, later as pointed out by
> > 60efa5eb2e88 ("Btrfs: use late_initcall instead of module_init") this
> > wasn't enough and finally btrfs was switched to late_initcall which
> > comes after the generic crc32c implementation is initiliased. The
> > latter commit superseeded the former. Now that we don't have to
> > maintain our own code let's just remove it and switch to using the
> > generic implementation.
> 
> >  fs/btrfs/hash.c            | 54 ----------------------------------------------
> >  fs/btrfs/hash.h            | 43 ------------------------------------
> 
> IIRC Adding -D to git format-patch will make it shorter and nicer.
> But please, double check that git am actually detects removals.

While the patch looks better, my 'git am' does not want to apply the
deletion:

$ git am 0001-btrfs-Remove-custom-crc32c-init-code.patch
Applying: btrfs: Remove custom crc32c init code
error: removal patch leaves file contents
error: fs/btrfs/hash.c: patch does not apply
error: removal patch leaves file contents
error: fs/btrfs/hash.h: patch does not apply
Patch failed at 0001 btrfs: Remove custom crc32c init code
The copy of the patch that failed is found in: .git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

so the ordinary diff shall be preferred.
