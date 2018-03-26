Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33522 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750955AbeCZNjf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 09:39:35 -0400
Date: Mon, 26 Mar 2018 15:37:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 2/2] btrfs-progs: Add test for collision DIR_ITEM handling
Message-ID: <20180326133708.GN6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1521816494-22947-1-git-send-email-nborisov@suse.com>
 <1521816494-22947-2-git-send-email-nborisov@suse.com>
 <617236e1-acc0-33b7-8697-a29036296829@gmx.com>
 <558444ee-efb6-e0c6-ecd0-10776b06106d@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <558444ee-efb6-e0c6-ecd0-10776b06106d@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 26, 2018 at 04:24:47PM +0300, Nikolay Borisov wrote:
> >> +# The fs is clean so lowmem shouldn't produce any warnings
> >> +run_check "$TOP/btrfs" check --mode=lowmem --readonly "$TEST_DEV"
> > 
> > I understand this is a pinpoint test case for lowmem mode, but for
> > lowmem mode test, we set TEST_ENABLE_OVERRIDE and the whole test case
> > will use lowmem mode.
> 
> So how exactly is this argument supposed to be used. I tried:
> 
> TEST_ENABLE_OVERRIDE=true TEST=031\* ./fsck-tests.sh  - no --lowmem is
> appended
> 
> I modify the TEST_ENABLE_OVERRIDE=false to TEST_ENABLE_OVERRIDE=true in
> common.local and then just run TEST=031\* ./fsck-tests.sh and it works.
> 
> TEST_ENABLE_OVERRIDE=true TEST_ARGS_CHECK=--mode=lowmem TEST=031\*
> ./fsck-tests.sh - this also works?

This is how it's supposed to work via the commandline:

- TEST_ENABLE_OVERRIDE is a global switch for any user-defined overrides
- TEST_ARGS_CHECK specifies what should be appended to 'check'.
> 
> 
> I'm not entirely sure what the ci config is but at this point I'm
> beginning to worry that if I omit the explicit --mode option this test
> might never be run in lowmem mode.

CI config == .travis.yml, ie. configuration for the continuous
integration, that among others also runs check tests in default and
lowmem mode.

We don't want mode-specific tests but rather single testcase that can be
selectively used with original or lowmem mode. So even if you have a
regression test for lowmem, it also must pass in the original mode and
therefore there are no switches inside the test script.
