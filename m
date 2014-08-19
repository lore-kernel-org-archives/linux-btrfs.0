Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbaHSPKH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 11:10:07 -0400
Date: Tue, 19 Aug 2014 17:10:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] btrfs-progs: random fixes of btrfs-filesystem
 documentation
Message-ID: <20140819151005.GX1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53E888C3.70807@jp.fujitsu.com>
 <53E8F7F0.3060300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53E8F7F0.3060300@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 11, 2014 at 10:05:52AM -0700, Eric Sandeen wrote:
> (What seems to be missing, though, is why would the user ever choose to use '-d?')

That's a fallback method if blkid or udev are not available. We've had
reports in the past that this functionality should not be dropped.
