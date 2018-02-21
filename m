Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51450 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965502AbeBUNuN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 08:50:13 -0500
Date: Wed, 21 Feb 2018 14:47:54 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 03/27] libbtrfsutil: add Python bindings
Message-ID: <20180221134754.GD1469@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1518720598.git.osandov@fb.com>
 <818e5d95ac69282a1e8c193bf92671f4b9982728.1518720598.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <818e5d95ac69282a1e8c193bf92671f4b9982728.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 15, 2018 at 11:04:48AM -0800, Omar Sandoval wrote:
> +setup(
> +    name='btrfsutil',
> +    version=get_version(),
> +    description='Library for managing Btrfs filesystems',
> +    url='https://github.com/kdave/btrfs-progs',
> +    license='GPLv3',

LGPLv3?

> +    cmdclass={'build_ext': my_build_ext},
> +    ext_modules=[module],
> +)
