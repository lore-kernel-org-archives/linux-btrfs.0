Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbaFBRnU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jun 2014 13:43:20 -0400
Date: Mon, 2 Jun 2014 19:43:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Mike Fleetwood <mike.fleetwood@googlemail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Add dev uuid output for print_dev_item().
Message-ID: <20140602174318.GF22324@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401325356-27683-1-git-send-email-quwenruo@cn.fujitsu.com>
 <CAMU1PDhBuk46VgwNVnO_1JzOgZka1wd8dMvTjECwTRBsfZeghQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMU1PDhBuk46VgwNVnO_1JzOgZka1wd8dMvTjECwTRBsfZeghQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 29, 2014 at 08:52:04PM +0100, Mike Fleetwood wrote:
> On 29 May 2014 02:02, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> > The original print_dev_item() only prints device id,total bytes and
> > bytes used.
> > When it comes to debug things related to duplicated device id, dev uuid
> > is needed to distinguish different device since device is is no
> > reliable.
> 
> At the end of the message I think there is a couple of typos and you meant:
> ... device id is not reliable.

Fixed, thanks.
