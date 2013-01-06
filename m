Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:33253 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab3AFTRM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jan 2013 14:17:12 -0500
Message-ID: <50E9CDB3.3010401@petaramesh.org>
Date: Sun, 06 Jan 2013 20:17:07 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Re: /boot as a btrfs subvolume
References: <50E8986A.2050002@czarc.net> <EEB5FCDE-687D-4EEF-9A85-68703266704C@colorremedies.com> <50E98DC6.3030304@czarc.net> <06B00D7F-F963-4A55-AAA2-7F209DF0AD35@colorremedies.com>
In-Reply-To: <06B00D7F-F963-4A55-AAA2-7F209DF0AD35@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 06/01/2013 20:11, Chris Murphy a écrit :
> If you use UUID, and you use subvol=, and you don't rename/move your subvolume, it's perfectly safe. Nevertheless, GRUB becoming subvolid aware seems like a good idea to me, but I have no idea what's involved in that.

I actually run several machines on which I have /boot in a separate
BTRFS subvol, without any issue. I have a multiboot between several
different distros (typically Ubuntu, Mint, LMDE, Bodhi... All Ubuntu
derivatives except for LMDE which is Debian-based...) sharing the same
BTRFS container and using different subvols i.e. UBUNTU/@boot,
LMDE/@boot etc...

Works just great.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

