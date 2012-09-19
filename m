Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:46149 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645Ab2ISRio (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 13:38:44 -0400
Message-ID: <505A013F.8000303@petaramesh.org>
Date: Wed, 19 Sep 2012 19:30:39 +0200
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: "free space cache generation" ?
References: <50597CD5.5060001@petaramesh.org> <20120919160109.GC2272@localhost.localdomain>
In-Reply-To: <20120919160109.GC2272@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 19/09/2012 18:01, Josef Bacik a écrit :
> Yeah I need to just put those under a DEBUG ifdef, they aren't a big
> deal, just letting you know that the on disk cache is invalid and it
> will have to put it together ye olde fashioned way.

...But is it supposed to, and how to fix it ?

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

