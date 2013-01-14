Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758011Ab3ANW0d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 17:26:33 -0500
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 3B4DDA39D2
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2013 23:26:32 +0100 (CET)
Date: Mon, 14 Jan 2013 23:26:31 +0100
From: Arvin Schnell <aschnell@suse.de>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: libify some parts of btrfs-progs
Message-ID: <20130114222631.GA2545@suse.de>
References: <1357681304-2978-1-git-send-email-mfasheh@suse.de> <1357681304-2978-3-git-send-email-mfasheh@suse.de> <20130114141814.GA7265@suse.de> <20130114181403.GQ12558@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <20130114181403.GQ12558@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 14, 2013 at 10:14:03AM -0800, Mark Fasheh wrote:
> Hi Arvin!
> 
> On Mon, Jan 14, 2013 at 03:18:14PM +0100, Arvin Schnell wrote:
> > please find attached a patch to make the new libbtrfs usable from
> > C++ (at least for the parts snapper will likely need).
> 
> Thanks, that looks great. I'll integrate it into my stack of patches and
> send it out with the next set.
> 
> Can I put:
> 
> Signed-off-by: Arvin Schnell <aschnell@suse.de>
> 
> at the bottom of the patch to indicate that started with you?

Sure.

Regards,
  Arvin

-- 
Arvin Schnell, <aschnell@suse.de>
Senior Software Engineer, Research & Development
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg)
Maxfeldstraße 5
90409 Nürnberg
Germany
