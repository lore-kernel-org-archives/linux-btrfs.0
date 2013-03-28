Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:51745 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121Ab3C1Pza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 11:55:30 -0400
Message-ID: <515467EE.1090105@petaramesh.org>
Date: Thu, 28 Mar 2013 16:55:26 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: This time HD LED doesn't come up at all :-(
References: <51542EB6.7030403@petaramesh.org> <20130328131939.GN28030@localhost.localdomain>
In-Reply-To: <20130328131939.GN28030@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 28/03/2013 14:19, Josef Bacik a écrit :
> Can you capture the output and post it somewhere so I can see it?  Thanks,
Hi Josef,

I just uploaded the screenshot here: http://dl.free.fr/pRabNdCsf (You
will need to type in your email address or the list's one to retrieve it)

Meanwhile I did some more tests, and I'm puzzled :

- Booting the latest PartedMagic Live (I believe it's a 3.7.9 kernel), I
can mount the HD BTRFS filesystem wihtout problem (only tried with
subvolid=0), I can btrfsck it (unmounted), and it looks allright;

- Still, trying to boot the system the normal way (3.8.0 kernel) fails,
and I get these errors...

At least the FS doesn't look plain dead, but I have no clue...

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

