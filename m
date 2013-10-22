Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab3JVRE1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 13:04:27 -0400
Date: Tue, 22 Oct 2013 19:04:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: improve inode hash function/inode lookup
Message-ID: <20131022170423.GB1032@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1381092807-21422-1-git-send-email-fdmanana@gmail.com>
 <1381094553-2190-1-git-send-email-fdmanana@gmail.com>
 <20131011114229.GE5787@twin.jikos.cz>
 <CAL3q7H6o3auNremGh8X0oFF_OcVuwpSxsOrAKDBmtx+d4eLxAQ@mail.gmail.com>
 <20131021232107.GS1032@suse.cz>
 <CAL3q7H4MYgGUoDHOcBDv9H7cBFC+1VqM2395qTQN=DSoTv6ZXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H4MYgGUoDHOcBDv9H7cBFC+1VqM2395qTQN=DSoTv6ZXA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 22, 2013 at 12:27:21AM +0100, Filipe David Manana wrote:
> > It is a separate change that makes your patch obsolete.
> 
> Except the part of making the hash value depend on both object id and
> root id, no?

I've read the patch again, yes, case 1 makes sense.

david
