Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56251 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752582AbeBERTd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Feb 2018 12:19:33 -0500
Date: Mon, 5 Feb 2018 18:17:18 +0100
From: David Sterba <dsterba@suse.cz>
To: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "quwenruo.btrfs@gmx.com" <quwenruo.btrfs@gmx.com>
Subject: Re: [RFC PATCH v2 2/4] btrfs-progs: Add EXEC represent path of
 executable file
Message-ID: <20180205171718.GG18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1517560445-5712-1-git-send-email-gujx@cn.fujitsu.com>
 <1517560445-5712-3-git-send-email-gujx@cn.fujitsu.com>
 <20180202180730.GA18553@twin.jikos.cz>
 <516DDBE5B1D92D42BCF7A2E37F045A5D016B127127@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <516DDBE5B1D92D42BCF7A2E37F045A5D016B127127@G08CNEXMBPEKD02.g08.fujitsu.local>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 03, 2018 at 09:07:47AM +0000, Gu, Jinxiang wrote:
> 
> 
> > -----Original Message-----
> > From: David Sterba [mailto:dsterba@suse.cz]
> > Sent: Saturday, February 03, 2018 2:08 AM
> > To: Gu, Jinxiang/顾 金香 <gujx@cn.fujitsu.com>
> > Cc: linux-btrfs@vger.kernel.org; dsterba@suse.cz; quwenruo.btrfs@gmx.com
> > Subject: Re: [RFC PATCH v2 2/4] btrfs-progs: Add EXEC represent path of executable file
> > 
> > On Fri, Feb 02, 2018 at 04:34:03PM +0800, Gu Jinxiang wrote:
> > > Use EXEC instead of TOP to represent the path of excutable file.
> > > EXEC is set to TOP by default, but when there is no excutable file in
> > > TOP, use the path where btrfs is install as EXEC.
> > 
> > What if we just allow to change TOP (ie. do not overwrite it in the test driver scripts)? The logic will be the same as with EXEC, but we won't
> > have to rewrite essentailly all paths in the testsuite.
> > 
> Since besides executable files, TOP is also used to find
> $TOP/tests/common, $TOP/Documentation, $TOP/tests/fuzz-tests/images,
> i.e.
> so, change TOP will also effect on those resources.

Yeah $TOP is used for too many different things. It works for from
inside git, but this needs to change for the exported testsuite. So
TEST_TOP for the sourced 'common' scripts and maybe other variables for
the internal binaries that do not get typically installed.

> So, I introduce EXEC to differentiate executable files and other resources.

I understand why but I don't like this approach. TOP should be enough
for all binaries that are expected to exist in the path, the rest needs
own variable.
