Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33401 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753497AbdCMRs3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 13:48:29 -0400
Date: Mon, 13 Mar 2017 18:47:50 +0100
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: cli-tests: Convert non-raid filesystem to
 raid
Message-ID: <20170313174750.GR14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170129144455.GA12174@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170129144455.GA12174@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 29, 2017 at 08:14:55PM +0530, Lakshmipathi.G wrote:
> Simple script to verify non-raid filesystem conversion.

The cli (command line interface) tests are supposed to cover the common
usecases from the point of option combinations etc, not really verifying
the result. It would be good if you add more than just one simple test,
especially for the balance filters. Adding the helpers to prepare the
filesystem (number of devices, raid profiles) would be a good start.
Some code for that is in the mkfs tests, but this belongs to the common
scripts so we could easily use that.
