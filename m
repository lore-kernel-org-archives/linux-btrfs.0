Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42870 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726177AbeHBVKI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 17:10:08 -0400
Date: Thu, 2 Aug 2018 21:17:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v2 0/2] btrfs-progs: build improvements
Message-ID: <20180802191734.GT3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1532637115.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1532637115.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 26, 2018 at 01:34:37PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Hi, Dave,
> 
> Here's v2 of "btrfs-progs: make all programs and libraries optional",
> this time much less overkill. Now, it's just --disable-programs,
> --disable-shared, and --disable-static. Based on your devel branch.
> Please consider these for the next progs release.

Added to devel, thanks.
