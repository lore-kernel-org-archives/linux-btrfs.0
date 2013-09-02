Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758776Ab3IBOw0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Sep 2013 10:52:26 -0400
Date: Mon, 2 Sep 2013 16:52:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH v7] Btrfs: optimize key searches in btrfs_search_slot
Message-ID: <20130902145224.GB23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1377780253-17826-1-git-send-email-fdmanana@gmail.com>
 <1378031968-22062-1-git-send-email-fdmanana@gmail.com>
 <20130902133909.GX23113@twin.jikos.cz>
 <CAL3q7H4YjTeTBj2DoVP1wQXQiCqnMrbXUqFFOKuDR-rRNW+zXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H4YjTeTBj2DoVP1wQXQiCqnMrbXUqFFOKuDR-rRNW+zXA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 02, 2013 at 03:40:39PM +0100, Filipe David Manana wrote:
> Between patch versions v5 to v7, I don't have any strong preference.
> All have correct, small and simple code.

I'm ok with v7.
