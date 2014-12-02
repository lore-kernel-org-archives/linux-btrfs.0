Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbaLBM4K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Dec 2014 07:56:10 -0500
Date: Tue, 2 Dec 2014 13:56:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141202125610.GS12140@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <20141130042306.GE8916@merlins.org>
 <547C6922.6030206@gmail.com>
 <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
 <20141201184621.5dd7fcd9@natsu>
 <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
 <20141202031403.GZ17395@hungrycats.org>
 <CAH-HCWWnxqExQOexPF3jY6F1=jJA35Se5RkVw87u52F6BSic2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAH-HCWWnxqExQOexPF3jY6F1=jJA35Se5RkVw87u52F6BSic2g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 02, 2014 at 09:10:15AM +0530, Shriramana Sharma wrote:
> > On a side note...only root can delete subvolumes, but non-root users
> > can create them, which results in...this:
> 
> Not sure about your Debian system, but my openSUSE Tumbleweed (with
> kernel 3.17.2 and btrfsprogs 3.17) requires me to enter the root
> password before creating a subvol (or in fact running anything under
> /sbin or /usr/sbin).

Works for me without the root password on a Tumbleweed installation
(without apparmor/selinux).
