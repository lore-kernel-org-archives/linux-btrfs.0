Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50538 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727126AbeHPAuK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 20:50:10 -0400
Date: Wed, 15 Aug 2018 20:12:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Omar Sandoval <osandov@fb.com>
Subject: Re: [PATCH v2 00/20] btrfs-progs:  Rework of "subvolume list/show"
 and relax the root privileges of them
Message-ID: <20180815181211.GQ24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

so I've merged the first bath to devel. There was quite some whitespace
damage and style issues, but I fixed that as I went through the pathes.

I've left out all patches that introduce new options, this is the hard
part and single letter options cannot be added just randomly. That's
what led to the current state.

The semantics of current options is preserved, with the slight exception
to the option -a.

> * Future todo:
> If this approach is ok, I'd like to update the output of "sub list" more like:
>   - Remove obsolete field (i.e. top-level) from output

Yeah the top-level field can be removed from the user output. Current
idea of the fields printed by default is: id, generation, type, path.
The type is a representation of eg. read-write status,
subvolume/snapshot, and maybe received, or if it is default.

The remaining fields are on-demand by other options and the future proof
solution is to provide the single option to specify which columns to
print.

The inline format, ie. the current one, is not very comprehensive so the
table layout should be the default for user.

The path format needs to be selected by a more concise way than just -A
and possibly more added options. Eg. --path

* absolute (shorthand abs)
* realative to the current path (pwd)
* toplevel relative (toplevel)

In order to make it possible to distinguish in the output without prior
knowledge of which one was selected, I propose this formatting:

* absolute path always starts with / and is really absolute to the /
* relative path to the current directory starts with ./
* toplevel does not start with ./ nor /

There are patches touching the libbtrfsutil code, so I'd like to hear
from Omar what he thinks.

What's now in devel should not change and provide base for further
patches, so please use it if you're going to implement something from
the above.
