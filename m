Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:33287 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbbCRNbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 09:31:45 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: Re: number of hardlinks for directory in ls -lid always 1?
Date: Wed, 18 Mar 2015 14:31:43 +0100
Message-ID: <1929370.YSr7hGqtmM@merkaba>
In-Reply-To: <20150317160717.GU20767@twin.jikos.cz>
References: <9389540.MYekrP2a8Q@merkaba> <20150317160717.GU20767@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 17. März 2015, 17:07:17 schrieb David Sterba:
> On Tue, Mar 17, 2015 at 02:33:30PM +0100, Martin Steigerwald wrote:
> > On BTRFS I see
> > 
> > martin@merkaba:~> ls -lid /usr/local
> > 27138 drwxrwsr-x 1 root staff 62 Aug 15  2014 /usr/local
> > martin@merkaba:~> ls -lid /usr/local/.
> > 27138 drwxrwsr-x 1 root staff 62 Aug 15  2014 /usr/local/.
> > martin@merkaba:~> ls -lid /usr/local/bin/..
> > 27138 drwxrwsr-x 1 root staff 62 Aug 15  2014 /usr/local/bin/..
> > 
> > On other filesystems like Ext4 I see the actual number of hardlinks to
> > the directory.
> > 
> > Is this intended behaviour of BTRFS or a bug?
> 
> Intended behaviour, this has been asked in the past, I don't have the
> link sorry, try searching the mailinglist archives.

I did, yet I didn´t find anything.

Any idea on what words except "hardlinks", "hard links", "number", "ls -l" 
I can throw at Baloo fulltext search on BTRFS mailing list folder in 
KMail? 

I also tried various search terms with Startpage.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
