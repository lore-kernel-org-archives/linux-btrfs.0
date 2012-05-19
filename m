Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59394 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab2ESRgi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 May 2012 13:36:38 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: SSD format/mount parameters questions
Date: Sat, 19 May 2012 19:36:36 +0200
Cc: Sander <btrfs@humilis.net>, Martin <m_btrfs@ml1.co.uk>
References: <jp32u7$vlc$1@dough.gmane.org> <20120518070251.GA32766@panda> (sfid-20120518_121930_821794_9A426EAB)
In-Reply-To: <20120518070251.GA32766@panda>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201205191936.36655.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 18. Mai 2012 schrieb Sander:
> Martin wrote (ao):
> > Are there any format/mount parameters that should be set for using
> > btrfs on SSDs (other than the "ssd" mount option)?
> 
> If possible, format the whole device, do not partition the ssd. This
> will guarantee proper allignment.

Current partitioning tools align at 1 MiB unless otherwise specified.

And then thats only the alignment of the start of the filesystem.

Not the granularity that the filesystem itself uses to align its writes.

And then its not clear to me what effect proper alignment will actually 
have given the intelligent nature of SSD firmwares.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
