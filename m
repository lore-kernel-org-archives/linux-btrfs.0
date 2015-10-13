Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45742 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932332AbbJMQmU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 12:42:20 -0400
Date: Tue, 13 Oct 2015 18:41:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Henk Slager <hslager@hotmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS with 8TB SMR drives
Message-ID: <20151013164109.GN27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CA+wwUFBKOxHSXOn9rcG+k5CTaKMPWGnx2a5dNo=CCfzawRLKGg@mail.gmail.com>
 <20151012132136.GE27761@twin.jikos.cz>
 <BLU436-SMTP165112E5F4D118F381D47A4A9310@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BLU436-SMTP165112E5F4D118F381D47A4A9310@phx.gbl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 12, 2015 at 06:25:52PM +0200, Henk Slager wrote:
> and looking at this spec:
> http://www.seagate.com/files/www-content/product-content/hdd-fam/seagate-archive-hdd/en-us/docs/archive-hdd-dS1834-3-1411us.pdf
> 
> it seems that it is a drive-managed SMR disk. I am not sure why David
> assumes it is host-managed, maybe drive firmware/functionality can be
> bypassed.

Because the drive-managed ones are not interesting from the filesystem POV.
