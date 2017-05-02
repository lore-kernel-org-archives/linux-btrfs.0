Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58929 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751022AbdEBOMW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 10:12:22 -0400
Date: Tue, 2 May 2017 16:12:10 +0200
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: tests: add variable quotation to fsck-tests
Message-ID: <20170502141210.GE23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170424132940.GA11861@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170424132940.GA11861@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 24, 2017 at 06:59:40PM +0530, Lakshmipathi.G wrote:
> Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>

Applied, thanks. As this was done out of order with other patches,
tests/fsck-tests/026-check-inode-link/test.sh was skipped.
