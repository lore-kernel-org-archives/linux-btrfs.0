Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44429 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751405AbdIKUFD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 16:05:03 -0400
Date: Mon, 11 Sep 2017 22:03:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Nick Terrell <terrelln@fb.com>
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: Add zstd support
Message-ID: <20170911200333.GD14538@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170908202923.240776-1-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170908202923.240776-1-terrelln@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 08, 2017 at 01:29:23PM -0700, Nick Terrell wrote:
> Adds zstd support to the btrfs program. An optional dependency on libzstd
> >= 1.0.0 is added. Autoconf accepts `--enable-zstd' or `--disable-zstd' and
> defaults to detecting if libzstd is present using `pkg-config'. Adds tests
> for the new features based on a prebuilt btrfs image with a zstd compressed
> file.
> 
> The patch is also available in my fork of btrfs-progs [1], which passes
> Travis-CI with the new tests. The prebuilt binary is available there.
> 
> I haven't updated Android.mk.
> 
> [1] https://github.com/terrelln/btrfs-progs/tree/devel
> 
> Signed-off-by: Nick Terrell <terrelln@fb.com>
> ---
> v1 -> v2:
> - Allow zstd support to be disabled, defaulting to auto detection
> - Print if zstd is enabled/disabled when `./configure' finishes
> - Add zstd test to patch with prebuilt image`

Applied, with some changes. I've split the tests to own commit and
cleaned up test.sh so it follows the coding patterns (dd instead of
head, grep -q, minor things). The run_check should be used if possible,
but dumping the 200k of zeros to log via run_check_stdout is OTOH not
recomended. But, it's merged.
