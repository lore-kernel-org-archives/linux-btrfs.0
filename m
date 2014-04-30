Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:52085 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbaD3IPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 04:15:16 -0400
Received: from merkaba.localnet (blackhole.teamix.net [194.150.191.251])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 289EE87
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Apr 2014 10:15:09 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/14] Enhanced df - followup
Date: Wed, 30 Apr 2014 10:15:11 +0200
Message-ID: <1408814.ZZlx3uERlS@merkaba>
In-Reply-To: <pan$8e22f$932a091f$427154c$9f1ff63a@cox.net>
References: <cover.1398786620.git.dsterba@suse.cz> <pan.2014.04.29.17.33.09@googlemail.com> <pan$8e22f$932a091f$427154c$9f1ff63a@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[keeping dropped CC although not customary on this list]

Am Mittwoch, 30. April 2014, 00:42:44 schrieb Duncan:
> Holger Hoffstätte posted on Tue, 29 Apr 2014 17:33:09 +0000 as excerpted:
> >> On Tue, Apr 29, 2014 at 05:10:31PM +0000, Duncan wrote:
> >>> David Sterba posted on Tue, 29 Apr 2014 17:56:47 +0200 as excerpted:
> >>> > Changes:
> >>> > * btrfs filesystem disk_usage - renamed to usage
> >>> 
> >>> [On the CLI, "usage" is often used to print a briefer "help",
> >>> and thus shouldn't be used for an actual command.]
> > 
> > I think the point was to have the same term for both filesystem and
> > device categories, which IMHO makes a lot of sense and is less to
> > remember. Categorical polymorphism: it's a good thing. :)
> 
> Good idea to use the same term.
> 
> Bad idea (IMO) to make that term "usage", by itself.
> 
> =:^)

Hmmm, I disagree. What it basically displays is usage. So the term "usage" is 
just about right.

And it isn´t an option either.

Additionally I never ever used the option "--usage". I didn´t even know it 
existed.

But if you have a different equally short sugestion, I am all ears.

Anyway, I´d personally wouldn´t block the patch going in due to this.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
