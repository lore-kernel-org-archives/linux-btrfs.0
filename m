Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F24BC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 11:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22AE220C01
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 11:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbfB0L7u (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 06:59:50 -0500
Received: from rain.plan9.de ([5.9.56.12]:40105 "EHLO mail.nethype.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729605AbfB0L7u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 06:59:50 -0500
X-Greylist: delayed 947 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2019 06:59:49 EST
Received: from [10.9.0.40] (helo=localhost.localdomain)
        by mail.nethype.de with esmtp (Exim 4.89)
        (envelope-from <stefan@hello-penguin.com>)
        id 1gyxd1-0005E9-R3; Wed, 27 Feb 2019 11:43:59 +0000
Received: from stefan by localhost.localdomain with local (Exim 4.92-RC6)
        (envelope-from <stefan@hello-penguin.com>)
        id 1gyxd1-0007XD-IH; Wed, 27 Feb 2019 12:43:59 +0100
Date:   Wed, 27 Feb 2019 12:43:59 +0100
From:   Stefan Traby <stefan@hello-penguin.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Mike Fleetwood <mike.fleetwood@googlemail.com>,
        Qu Wenruo <wqu@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: gitignore: Ignore hidden files
Message-ID: <20190227114359.GA28913@hello-penguin.com>
Reply-To: Stefan Traby <stefan@hello-penguin.com>
References: <20190227051602.28987-1-wqu@suse.com>
 <CAMU1PDi9GD9TC6B8kN4iGbeddOxkPH7B+UxeiVbC_KOwJvxnzQ@mail.gmail.com>
 <62c5272f-6e30-4ea2-dff0-853bad22fb14@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62c5272f-6e30-4ea2-dff0-853bad22fb14@gmx.com>
Organization: Stefan Traby Services && Consulting
X-Operating-System: Linux 4.20.11-oesi (x86_64)
X-MIL:  A-6172171143
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 27, 2019 at 07:29:13PM +0800, Qu Wenruo wrote:
> On 2019/2/27 下午7:22, Mike Fleetwood wrote:
> > On Wed, 27 Feb 2019 at 05:16, Qu Wenruo <wqu@suse.com> wrote:
> >>
> >> A lot of editor/IDE related config files are hidden files, like .vimrc
> >> or .clang_complete.
> >>
> >> Instead of adding gitignore entry for each editor/IDE, just ignore all
> >> hidden files like what kernel does.
> > I think you mean:
> > files starting with ".", like ls does by default without the -a flag.
> 
> When I punched the words "linux hidden file" into google, I got quite a
> lot of pages showing 'In the Linux operating system, a hidden file is
> any file that begins with a "."'
> 
> So I think the words "hidden files" should be more or less OK?

I think the word "dotfiles" is ok.

-- 

  ciao - 
    Stefan
