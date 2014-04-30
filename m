Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422648AbaD3Mhh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 08:37:37 -0400
Date: Wed, 30 Apr 2014 14:37:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/14] Enhanced df - followup
Message-ID: <20140430123735.GK5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1398786620.git.dsterba@suse.cz>
 <pan.2014.04.29.17.33.09@googlemail.com>
 <pan$8e22f$932a091f$427154c$9f1ff63a@cox.net>
 <1408814.ZZlx3uERlS@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1408814.ZZlx3uERlS@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 30, 2014 at 10:15:11AM +0200, Martin Steigerwald wrote:
> [keeping dropped CC although not customary on this list]
> 
> Am Mittwoch, 30. April 2014, 00:42:44 schrieb Duncan:
> > >>> > * btrfs filesystem disk_usage - renamed to usage
> > >>> 
> > >>> [On the CLI, "usage" is often used to print a briefer "help",
> > >>> and thus shouldn't be used for an actual command.]
> > > 
> > > I think the point was to have the same term for both filesystem and
> > > device categories, which IMHO makes a lot of sense and is less to
> > > remember. Categorical polymorphism: it's a good thing. :)
> > 
> > Good idea to use the same term.
> > 
> > Bad idea (IMO) to make that term "usage", by itself.
> > 
> > =:^)
> 
> Hmmm, I disagree. What it basically displays is usage. So the term "usage" is 
> just about right.
> 
> And it isn´t an option either.
> 
> Additionally I never ever used the option "--usage". I didn´t even know it 
> existed.
> 
> But if you have a different equally short sugestion, I am all ears.
> 
> Anyway, I´d personally wouldn´t block the patch going in due to this.

I agree with all your points.

For the reference, the term 'usage' has been agreed in the previous
iteration.

[1] http://www.spinics.net/lists/linux-btrfs/msg31698.html
[2] http://www.spinics.net/lists/linux-btrfs/msg31694.html
