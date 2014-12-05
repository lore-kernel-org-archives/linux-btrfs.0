Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49358 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbaLEReV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Dec 2014 12:34:21 -0500
Date: Fri, 5 Dec 2014 18:34:21 +0100
From: David Sterba <dsterba@suse.cz>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: dsterba@suse.cz, Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Moving an entire subvol?
Message-ID: <20141205173421.GL9754@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAH-HCWVcu9FW0c3zwEg_KR_yaPGRQ58yHbXsUx1JCKRu4s7NXQ@mail.gmail.com>
 <CAJCQCtT3EeGUOpZ9q78BcWv_Cc_5UGY=uPVJX+bqex9Zo_bWYg@mail.gmail.com>
 <CAH-HCWUSX+N2Byo4vpCxac89TSX2YGoP39VgFsq6952k9V9cmQ@mail.gmail.com>
 <20141202132842.GT12140@twin.jikos.cz>
 <CAH-HCWVubkp+viAEVqGoJFxJ_t1chTVC08xm6A15ucosqbWqxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAH-HCWVubkp+viAEVqGoJFxJ_t1chTVC08xm6A15ucosqbWqxQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 02, 2014 at 08:41:35PM +0530, Shriramana Sharma wrote:
> That makes sense. Is there anywhere that the "official" SuSE
> recommended subvol layout is mentioned that I can refer to without
> having to start up an installer?

https://www.suse.com/documentation/sles-12/singlehtml/book_sle_admin/book_sle_admin.html#sec.snapper.setup
"Directories that are Excluded from Snapshots"

> I am now reading a SuSECon 2013 presentation by Nyers and Schnell but
> they are very generic about the recommendations.

There are some recommended defaults that should be ok, the configuration
is flexible and the user can tune the settings later according to the
usage pattern (expected amount of data changes between snapshots,
frequency of changes).
