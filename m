Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab3JAOAh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 10:00:37 -0400
Date: Tue, 1 Oct 2013 16:00:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: dsterba@suse.cz, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/9] enhance btrfs qgroup show command
Message-ID: <20131001140035.GF18291@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1379917048-9720-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <20131001111950.GA18291@twin.jikos.cz>
 <0CE9197F-E95E-4C1E-8A7A-DFFD6AF110D3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0CE9197F-E95E-4C1E-8A7A-DFFD6AF110D3@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 01, 2013 at 08:25:38PM +0800, Wang Shilong wrote:
> > * -l sounds less intuitive, I suggest to use -r as for
> >  'referenced', given that there is -e for 'exclusive'.
> 
> Yeah, here -l means limited size. Anyway, this is a little  obscure.
> Maybe -r is better, but it may let user think it is a qgroup's referenced size
> but not max referenced size..

The referenced and exclusive sizes are always printed, I think that's ok
to assign -r to the referenced limit. If we want to reserve -r for
something else, next option is to use -R and -E for the limits.

During the time I was testing it the 2 most frequent uses were '-t' or
'-tcle'.

> > * the size should be pretty-printed by default or in bytes if a
> >  commandline option is given
> 
> Agree, maybe i can add an options for example '-h'  here.

-h prints help. But we haven't solved selecting units in other commands
as well, so this should be possibly done consistently and in one go.

> > * in the long term, the tabular output would be much better as
> >  default, and the current terse output available via commandline option
> >  for batch processing
> 
> The main reason that i don't use table result as default is because there
> are so many columns here, and my first table result will be a head name like:
> 
> rfer excl max_refer max_excl
> ----  -----  -----------   -------------
> 
> In order to keep compatibility with previous 'btrfs qgroup show', i add '-t'.

That's fine for now.
