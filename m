Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56759 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756995Ab3BKMtb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 07:49:31 -0500
Date: Mon, 11 Feb 2013 13:49:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Alexey Polyakov <alexey.polyakov@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Raid1 not working as expected
Message-ID: <20130211124928.GM12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CACP9TETrrxT=HyvXWt+uBDXjW9o9LGvJdrAPpUmzy4nb5iWXwQ@mail.gmail.com>
 <CACP9TETFnG2T3jqaOTRtLkrPV2TMiUn5bNdQoQfGEFzmwH18DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACP9TETFnG2T3jqaOTRtLkrPV2TMiUn5bNdQoQfGEFzmwH18DA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 11, 2013 at 04:28:43PM +0400, Alexey Polyakov wrote:
> Hi!
> I created filesystem with two devices, 200gb partition each, raid1
> both for data and metadata, and 16k leaf and node size. After using it
> for day or two I got checksum error on one file. scrub reported about
> 70 more similar errors.

Did you use a kernel version between 3.8-rc1 and 3.8-rc5 ?

david
