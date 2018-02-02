Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38973 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752388AbeBBStZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 13:49:25 -0500
Date: Fri, 2 Feb 2018 19:47:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, quwenruo.btrfs@gmx.com
Subject: Re: [RFC PATCH v2 0/4] Add support for export testsuits
Message-ID: <20180202184711.GC18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1517560445-5712-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1517560445-5712-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 02, 2018 at 04:34:01PM +0800, Gu Jinxiang wrote:
> Achieved:
> 1. export testsuit by:
>  $ make EXPORT=/where/you/want/to/generate/tests.tar.gz package
> relative path and absolute path both be ok.
> Besides tests itself, fssum and btrfs-corrupt-block will also be
> included in tests.tar.gz, since misc and fsck tests depend on
> btrfs-corrupt-block, and misc tests depend on fssum. 

My idea was:

$ make testuite

that will build all dependencies, ie. fssum and btrfs-corrupt-block, and
create btrfs-progs-tests.tar.gz in the current directory, ie. no need
for the EXPORT variable.

The tar command you used would add anything that's under tessts/ but we
don't need everything. So I'd expect there's a file that lists all files
and directories that we want in the testsuite tarball.

Some sort of identification should be put to the tarball, eg. what git
describe says and timestamp of generation.

> 2. after decompress tests.tar.gz, run test by:
>  $ TEST=`MASK` ./mkfs-tests.sh
> and, without MASK also be ok.
> replenish:
> The directory Structure after decompress tests.tar.gz is:
>  $ tar -xzvf ./tests.tar.gz
>  $ ls
>    tests fssum btrfs-corrupt-block

The structure could be reduced by one directory level if the contents of
tests is moved one directory up. That way all the test driver scritps
are in the same place as fssum and btrfs-corrupt-block. This would need
to be reflected in the test scripts.
