Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaLCSxM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Dec 2014 13:53:12 -0500
Date: Wed, 3 Dec 2014 19:53:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: dsterba <dsterba@suse.cz>, Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141203185311.GX12140@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <20141130042306.GE8916@merlins.org>
 <547C6922.6030206@gmail.com>
 <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
 <20141201184621.5dd7fcd9@natsu>
 <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
 <20141202031403.GZ17395@hungrycats.org>
 <CAH-HCWWnxqExQOexPF3jY6F1=jJA35Se5RkVw87u52F6BSic2g@mail.gmail.com>
 <20141202125610.GS12140@twin.jikos.cz>
 <CAH-HCWUm1CiapmHjy66DRKHa6NRegEW03es1DkK1SWv0159ZMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAH-HCWUm1CiapmHjy66DRKHa6NRegEW03es1DkK1SWv0159ZMw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 02, 2014 at 08:45:10PM +0530, Shriramana Sharma wrote:
> On Tue, Dec 2, 2014 at 6:26 PM, David Sterba <dsterba@suse.cz> wrote:
> >
> > Works for me without the root password on a Tumbleweed installation
> > (without apparmor/selinux).
> 
> Are you then referring to a btrfs partition mounted with user_subvol_rm_allowed?

The context was 'does creating a subvolume require root password'.
