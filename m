Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56646 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750896AbdEBRYL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 13:24:11 -0400
Date: Tue, 2 May 2017 19:24:05 +0200
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: tests: add variable quotation to
 convert-tests
Message-ID: <20170502172405.GV23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170423190000.GA15598@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170423190000.GA15598@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 24, 2017 at 12:30:00AM +0530, Lakshmipathi.G wrote:
> Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>

Applied, thanks.

> -			if [[ $TEST_LOG =~ dump ]]; then
> +			if [[ "$TEST_LOG" =~ dump ]]; then

Please note, that the matched string should not be quoted, since bash 3.2.
