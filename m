Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757831Ab3HHN0R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 09:26:17 -0400
Date: Thu, 8 Aug 2013 15:26:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Arne Jansen <sensille@gmx.net>
Cc: Sergei Trofimovich <slyich@gmail.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>, linux-kernel@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: [PATCH 6/7] btrfs: cleanup: removed unused 'btrfs_reada_detach'
Message-ID: <20130808132614.GS5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375911803-17318-1-git-send-email-slyich@gmail.com>
 <1375911803-17318-7-git-send-email-slyich@gmail.com>
 <520349BA.8080006@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <520349BA.8080006@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 09:33:14AM +0200, Arne Jansen wrote:
> On 07.08.2013 23:43, Sergei Trofimovich wrote:
> > From: Sergei Trofimovich <slyfox@gentoo.org>
> > 
> > Found by uselex.rb:
> >> btrfs_reada_detach: [R]: exported from: fs/btrfs/btrfs.o fs/btrfs/built-in.o fs/btrfs/reada.o
> 
> even though the function is currently unused, I'm hesitating to remove it
> as it's part of the reada-API and might be handy for anyone going to use
> the API in the future.

I agree. As replied here,
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg24047.html
please keep the function.

david
