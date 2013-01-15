Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab3AON0r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 08:26:47 -0500
Date: Tue, 15 Jan 2013 14:26:45 +0100
From: Arvin Schnell <aschnell@suse.de>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.de>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: libify some parts of btrfs-progs
Message-ID: <20130115132645.GA10431@suse.de>
References: <1357681304-2978-1-git-send-email-mfasheh@suse.de> <1357681304-2978-3-git-send-email-mfasheh@suse.de> <20130114141814.GA7265@suse.de> <20130115124650.GA2040@zambezi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <20130115124650.GA2040@zambezi.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 15, 2013 at 02:46:50PM +0200, Ilya Dryomov wrote:
> On Mon, Jan 14, 2013 at 03:18:14PM +0100, Arvin Schnell wrote:
> > 
> > Hi,
> > 
> > please find attached a patch to make the new libbtrfs usable from
> > C++ (at least for the parts snapper will likely need).

> Why exactly do we need this in a non-header file?

Oh, that's clearly a mistake. Thanks for noticing.

Regards,
  Arvin

-- 
Arvin Schnell, <aschnell@suse.de>
Senior Software Engineer, Research & Development
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg)
Maxfeldstraße 5
90409 Nürnberg
Germany
