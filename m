Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbbHaNp5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 09:45:57 -0400
Date: Mon, 31 Aug 2015 15:45:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: mount command now shows subvol and subvolid
Message-ID: <20150831134517.GQ11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAJCQCtSx8yvtbm+7i3bNtv1DaRtTAgRTdk+iMTrk5nNhssgRLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtSx8yvtbm+7i3bNtv1DaRtTAgRTdk+iMTrk5nNhssgRLQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 30, 2015 at 11:17:44AM -0600, Chris Murphy wrote:
> Does anyone know when this changed? Maybe it's a 4.2 thing... anyway
> it's very much welcome!

And another "side effect" is that /proc/self/mountinfo will report the
mounted subvolume, even if it was an implicit mount of non-toplevel
subvolume.
