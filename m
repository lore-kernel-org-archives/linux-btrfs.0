Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49407 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab3KNMlY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 07:41:24 -0500
Date: Thu, 14 Nov 2013 13:41:21 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <chris.mason@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: progs integration branch moved to master (new default leafsize)
Message-ID: <20131114124121.GH18494@suse.cz>
Reply-To: dsterba@suse.cz
References: <20131108220135.3802.39092@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131108220135.3802.39092@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 08, 2013 at 05:01:35PM -0500, Chris Mason wrote:
> The patch below switches our default mkfs leafsize up to 16K.  This
> should be a better choice in almost every workload, but now is your
> chance to complain if it causes trouble.

We should also turn the extended refs on by default now, it's been
around since 3.7, I'm not expecting backward compatibility issues in
general.


david
