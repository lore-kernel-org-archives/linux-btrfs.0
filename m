Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685Ab3ANSOE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 13:14:04 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id CC89BA4F28
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2013 19:14:03 +0100 (CET)
Date: Mon, 14 Jan 2013 10:14:03 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: Arvin Schnell <aschnell@suse.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: libify some parts of btrfs-progs
Message-ID: <20130114181403.GQ12558@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1357681304-2978-1-git-send-email-mfasheh@suse.de> <1357681304-2978-3-git-send-email-mfasheh@suse.de> <20130114141814.GA7265@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130114141814.GA7265@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Arvin!

On Mon, Jan 14, 2013 at 03:18:14PM +0100, Arvin Schnell wrote:
> please find attached a patch to make the new libbtrfs usable from
> C++ (at least for the parts snapper will likely need).

Thanks, that looks great. I'll integrate it into my stack of patches and
send it out with the next set.

Can I put:

Signed-off-by: Arvin Schnell <aschnell@suse.de>

at the bottom of the patch to indicate that started with you?

Thanks,
	--Mark

--
Mark Fasheh
