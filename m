Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45547 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab3ICQqa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Sep 2013 12:46:30 -0400
Date: Tue, 3 Sep 2013 18:46:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: show compiled-in config features at module load
 time
Message-ID: <20130903164628.GA32382@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <32516c087c164d4c319ac774758c70112e560a21.1378214658.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <32516c087c164d4c319ac774758c70112e560a21.1378214658.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 03, 2013 at 03:25:27PM +0200, Stefan Behrens wrote:
> We want to know if there are debugging features compiled in, this may
> affect performance. The message is printed before the sanity checks.

Agreed.

Reviewed-by: David Sterba <dsterba@suse.cz>
