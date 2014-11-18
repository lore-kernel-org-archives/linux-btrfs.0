Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33446 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187AbaKRQuv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 11:50:51 -0500
Date: Tue, 18 Nov 2014 17:50:50 +0100
From: David Sterba <dsterba@suse.cz>
To: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-progs: ARGV0_BUF_SIZE causes problems with tests
Message-ID: <20141118165050.GA7166@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CALOYprUMGsFEEUeYfd7Zs8_ZLM7_scApBCF=br42iq6suhA03w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALOYprUMGsFEEUeYfd7Zs8_ZLM7_scApBCF=br42iq6suhA03w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 15, 2014 at 01:27:13AM +0000, WorMzy Tykashi wrote:
> I found a bit of a weird corner-case today. [1] It seems that, due to
> the use of a 64-byte constant (ARGV0_BUF_SIZE) in utils.c, some tests
> fail with a "buffer overflow detected" error if the progs are built in
> a location with a sufficiently long path.

Ouch, thanks for the report. The correct fix is IMO to extend the buffer
to PATH_MAX plus what you propose as fix.
