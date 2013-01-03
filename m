Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35980 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab3ACQmK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jan 2013 11:42:10 -0500
Date: Thu, 3 Jan 2013 17:42:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Georgios Tsalikis <anaphaxeton@hol.gr>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Libified btrfs utils?
Message-ID: <20130103164207.GD20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <BLU0-SMTP213444C7DD70FB0E7A8EB63D5210@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BLU0-SMTP213444C7DD70FB0E7A8EB63D5210@phx.gbl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 03, 2013 at 05:25:20PM +0200, Georgios Tsalikis wrote:
> Is it possible that you deliver btrfs management utilities come in a C
> library form? It is always good to have a C API and CLI utility separation.
> Take libparted as an example. How much more functionality is in gparted than
> the (standard) cli parted? Writting tools by direct access to an API is much
> more elegant for a programmer. Please, consider my suggestion. Many would
> appreciate it, i am sure... Especially people like me that want to write GUI
> frontends.

Thanks for the suggestion, this has been asked for in the past and is
listed under projects:

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Provide_a_library_covering_.27btrfs.27_functionality

david
