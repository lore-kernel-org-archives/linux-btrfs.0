Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982AbaAFR1W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 12:27:22 -0500
Date: Mon, 6 Jan 2014 18:27:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Phil Turmel <philip@turmel.org>
Cc: Andrea Mazzoleni <amadvance@gmail.com>, neilb@suse.de, clm@fb.com,
        jbacik@fb.com, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [RFC v2 0/2] New RAID library supporting up to six parities
Message-ID: <20140106172720.GA6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
 <52CAE18B.8020701@turmel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52CAE18B.8020701@turmel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 06, 2014 at 12:02:03PM -0500, Phil Turmel wrote:
> On 01/06/2014 04:31 AM, Andrea Mazzoleni wrote:
> FWIW, your patch 1/2 doesn't seem to have gone through on linux-raid,
> although I saw it on lkml.  Probably a different file size limit, as
> that's a very large patch.

For the reference

http://article.gmane.org/gmane.linux.kernel/1623309
