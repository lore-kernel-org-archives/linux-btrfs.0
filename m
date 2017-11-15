Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51573 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932768AbdKONeM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 08:34:12 -0500
Date: Wed, 15 Nov 2017 14:32:16 +0100
From: David Sterba <dsterba@suse.cz>
To: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] btrfs-progs: Add support for running the tools
 from
Message-ID: <20171115133216.GL28899@suse.cz>
Reply-To: dsterba@suse.cz
References: <1509439416-51824-1-git-send-email-gujx@cn.fujitsu.com>
 <87a801c8-f50b-d260-cd36-76d75648b52c@gmx.com>
 <516DDBE5B1D92D42BCF7A2E37F045A5D01479E87A3@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <516DDBE5B1D92D42BCF7A2E37F045A5D01479E87A3@G08CNEXMBPEKD02.g08.fujitsu.local>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 01, 2017 at 01:42:42AM +0000, Gu, Jinxiang wrote:
> > On 2017年10月31日 16:43, Gu Jinxiang wrote:
> > > Add support for running the tools from a given path (for
> > > example,/usr/bin) by setting $EXEC while running tests.
> > >
> > > Achieved:
> > > Specify the location of binary and run test like this:
> > > $ make EXEC=/usr/bin/ test
> > Any special reason to test system installed btrfs?
> > Even for system QA case, I think self test should be run at packaging time other than doing it after packaging.

This is supposed to extend the testing possibilities. The packaging
phase could run some tests, many tools run post-build tests, but we need
to manage devices and require root in general. This is not always
possible, besides that it requires to run from the sources directory.

> Just implement the project list below in github.
> .................
> Add support for running the tools from a given path (git, /usr/bin, /usr/local/bin), so the testsuite can be run independently.
> .................

The idea is to export the testsuite files to a separate tar, run from a
script. In that case the system binaries will be preferred.

I've promoted the project task to https://github.com/kdave/btrfs-progs/issues/77 .
