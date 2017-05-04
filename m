Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40233 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755864AbdEDQxf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 May 2017 12:53:35 -0400
Date: Thu, 4 May 2017 18:53:27 +0200
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, btrfs <linux-btrfs@vger.kernel.org>,
        dsterba@suse.cz
Subject: Re: [PATCH 9/9] btrfs-progs: modify: Introduce option to specify the
 pattern to fill mirror
Message-ID: <20170504165327.GA10575@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
 <20170417032642.30770-10-quwenruo@cn.fujitsu.com>
 <CAKuJGC8vX53NExNAYj-de9vta_y5rdv3fC2z9-fP=rPatv-OOg@mail.gmail.com>
 <33ef367f-85a5-8418-d57e-b38b22214487@cn.fujitsu.com>
 <CAKuJGC9tcGh49XGv+tU729Y0BNnnMEwDk7axGQv6RAV0ZbFCGQ@mail.gmail.com>
 <9e8c3a66-f43a-bce8-36b1-5f358c6cab4a@cn.fujitsu.com>
 <CAKuJGC9Lcc+0hw7CQCMC2QhEUH1hm1doOxNsPv8Z-sqR4oErkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKuJGC9Lcc+0hw7CQCMC2QhEUH1hm1doOxNsPv8Z-sqR4oErkQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 23, 2017 at 01:12:42PM +0530, Lakshmipathi.G wrote:
> Thanks for the example and details. I understood some and need to
> re-read couple of more times to understand the remaining.
> 
> btw, I created a corruption framework(with previous org), the sample
> usage and example is below. It looks similar to Btrfs corruption tool.
> thanks.
> 
> --
> corrupt.py --help
[...]

Interesting, can you please share the script? This is another
alternative that seems more plausible for rapid prototyping of various
corruption scenarios. The C utility (either existing btrfs-corrupt-block
or the proposed btrfs-modify) can become tedious to change, but can be
compiled and distributed without the python dependency.

I wanted to use something python-based for tests when Hans announced the
python-btrfs project, but it has broader goals than just the testsuite
needs.  So we could have our own corrupt.py, just for our internal use.

I'm not sure if a compiled tool like btrfs-modify is really needed, but
why we can't have both.
