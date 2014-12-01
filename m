Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbaLAR2c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 12:28:32 -0500
Date: Mon, 1 Dec 2014 18:28:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Marc MERLIN <marc@merlins.org>, Shriramana Sharma <samjnaa@gmail.com>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141201172832.GI12140@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <20141130042306.GE8916@merlins.org>
 <547C6922.6030206@gmail.com>
 <CAE8gLhmn3aX88t1FO2=BnHXk0-+2xQ4dnW57dga93iA-bFaUzQ@mail.gmail.com>
 <547C7211.3070809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <547C7211.3070809@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 01, 2014 at 08:50:09AM -0500, Austin S Hemmelgarn wrote:
> It would not surprise 
> me though if RHEL or SuSE had patched the kernel to allow using rm on a 
> subvolume.

This would be quite a big change in behaviour that we would not do
without taking it upstream first.
