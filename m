Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:55253 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbbHUJP2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 05:15:28 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Karsten Heymann <karsten.heymann@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS cannot remove empry directory pretending it is not empty
Date: Fri, 21 Aug 2015 11:15:23 +0200
Message-ID: <11080876.b5D4dVKWvo@zafu>
In-Reply-To: <CAL017hDuuzfnPWpGthbHg+wkwinF90W8Ps-4uXY52ZJasJ42Hw@mail.gmail.com>
References: <2017000.AEG9PyVY17@zafu> <CAL017hDuuzfnPWpGthbHg+wkwinF90W8Ps-4uXY52ZJasJ42Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le vendredi 21 août 2015 10:47:45 Karsten Heymann a écrit :
> 
> did you check with lsof that no process has an open file descriptor in
> that directory?

Yes, I even renamed it and rebooted the machine to be double-sure, but to no 
avail...

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

