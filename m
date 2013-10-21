Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab3JUXVL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 19:21:11 -0400
Date: Tue, 22 Oct 2013 01:21:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: improve inode hash function/inode lookup
Message-ID: <20131021232107.GS1032@suse.cz>
Reply-To: dsterba@suse.cz
References: <1381092807-21422-1-git-send-email-fdmanana@gmail.com>
 <1381094553-2190-1-git-send-email-fdmanana@gmail.com>
 <20131011114229.GE5787@twin.jikos.cz>
 <CAL3q7H6o3auNremGh8X0oFF_OcVuwpSxsOrAKDBmtx+d4eLxAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6o3auNremGh8X0oFF_OcVuwpSxsOrAKDBmtx+d4eLxAQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 11, 2013 at 06:20:16PM +0100, Filipe David Manana wrote:
> Good point David. However it would be a rather radical behaviour change imho.

A radical step to prevent this practictly impossible but nasty bug to
happen :)

> I think it should be a separate change if there are no objections
> against such change.

It is a separate change that makes your patch obsolete.

david
