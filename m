Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716AbbDIQpr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Apr 2015 12:45:47 -0400
Date: Thu, 9 Apr 2015 18:45:46 +0200
From: David Sterba <dsterba@suse.cz>
To: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: use local btrfs-image in leaf corruption
 test
Message-ID: <20150409164546.GI25622@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CALOYprWfYKJG-9d=J9WLEisWLcpcKwv4bPwfcjggw-EC4phbGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALOYprWfYKJG-9d=J9WLEisWLcpcKwv4bPwfcjggw-EC4phbGA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 08, 2015 at 03:50:04PM +0100, WorMzy Tykashi wrote:
> Currently this test uses the system btrfs-image. If there isn't a
> btrfs-image on $PATH, the test fails. The test should be using the
> locally compiled btrfs-image, not the system one.

Added your sign-off and applied, thanks.
