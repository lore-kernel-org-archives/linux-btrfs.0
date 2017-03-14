Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39480 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752720AbdCNRnO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 13:43:14 -0400
Date: Tue, 14 Mar 2017 18:42:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Benedikt Morbach <benedikt.morbach@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH/fstest] btrfs/139: correctly receive clones to mounted
 subvol
Message-ID: <20170314174236.GF14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170222230735.23437-1-benedikt.morbach@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170222230735.23437-1-benedikt.morbach@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 23, 2017 at 12:07:35AM +0100, Benedikt Morbach wrote:
> clone needs to resolve the paths of the involved subvolumes in the target
> fs from their UUIDs. When doing so it might need to strip the prefix
> that is mounted as the root of the fs from those paths.
> 
> It didn't do so correctly when processing the source of "clone" commands
> 
> This is a regression test for
>     btrfs-progs: receive: handle root subvol path in clone
> ---
> 
> fstest for the patch mentioned above (see also https://mail-archive.com/linux-btrfs@vger.kernel.org/msg61848.html)
> 
> I thought I'd send this to linux-btrfs first as I'm not sure what the policy is
> wrt submitting fstests aren't fixed upstream yet.

Sending tests in advance is a common practice, failing test can be
expected on older kernels or installed btrfs-progs. In this case it's
not a kernel bug/feature test so I'm not entirely sure if fstests is the right
testsuite. I have adated this test and added it to the btrfs-progs.

> It's my first fstest and even though the other tests were helpful and it seems
> to work, I still assume I've made a couple of mistakes here and there.

IIRC fstests do not use the execution wrappers like run_check and there
could be more. If you want to continue, please resend to
fstests@vger.kernel.org, but as far as I'm concerned the test in
btrfs-progs is almost done (the fssum utility needs to be added).
