Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab3BLWM5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 17:12:57 -0500
Date: Tue, 12 Feb 2013 23:12:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] btrfs: accept zero for balance usage filter
Message-ID: <20130212221255.GC12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1360586032-22973-1-git-send-email-dsterba@suse.cz>
 <20130212163617.GA1922@zambezi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130212163617.GA1922@zambezi.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 12, 2013 at 06:36:17PM +0200, Ilya Dryomov wrote:
> Josef, please don't pull this one into btrfs-next, it's been deprecated
> by "Btrfs: allow for selecting only completely empty chunks" from me.
> David and I discussed this on IRC, he is OK with it.

Ack.

david
