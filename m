Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35698 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbaDGIkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Apr 2014 04:40:35 -0400
Received: from mfilter3-d.gandi.net (mfilter3-d.gandi.net [217.70.178.133])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id E744D1720A1
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Apr 2014 10:40:32 +0200 (CEST)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter3-d.gandi.net (mfilter3-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id AIWJ9x-tKJ66 for <linux-btrfs@vger.kernel.org>;
	Mon,  7 Apr 2014 10:40:31 +0200 (CEST)
Received: from zafu.localnet (dhcp230.cr2i.univ-montp2.fr [162.38.105.230])
	(Authenticated sender: michel@bouissou.net)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 46C371720CE
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Apr 2014 10:40:31 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Scrub bug on kernel 2.13
Date: Mon, 07 Apr 2014 10:40:29 +0200
Message-ID: <1522458.PjLK8OK9La@zafu>
In-Reply-To: <17911062.Cl4v2ZqDNL@zafu>
References: <17911062.Cl4v2ZqDNL@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, I meant kernel 3.13 :-)

Linux zafu 3.13.8-1-ARCH #1 SMP PREEMPT Tue Apr 1 12:19:51 CEST 2014 x86_64 
GNU/Linux


Le lundi 7 avril 2014 10:32:04 Swâmi Petaramesh a écrit :
> Hi there,
> 
> Machine got rebooted while scrub was in process, and now it looks like a
> scrub zombie...
> 
> How do I restore this to a normal non-zombie state ?
> 
> root@zafu:~# btrfs scrub status /
> scrub status for 13c87f57-3a85-4daf-a4bf-ba777407c169
>         scrub started at Mon Apr  7 09:49:48 2014, running for 693 seconds
>         total bytes scrubbed: 34.06GiB with 0 errors
> 
> root@zafu:~# btrfs scrub cancel /
> ERROR: scrub cancel failed on /: not running
> 
> root@zafu:~# btrfs scrub start /
> ERROR: scrub is already running.
> To cancel use 'btrfs scrub cancel /'.
> To see the status use 'btrfs scrub status [-d] /'.
> 
> root@zafu:~# btrfs scrub status /
> scrub status for 13c87f57-3a85-4daf-a4bf-ba777407c169
>         scrub started at Mon Apr  7 09:49:48 2014, running for 693 seconds
>         total bytes scrubbed: 34.06GiB with 0 errors

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Protégez votre vie privée : Chiffrez vos e-mails avec GnuPG

Art 20. de la Loi de Programmation Militaire 2013-1168 du 18/12/2013:
Tout ce que vous lirez, écrirez, consulterez ou penserez sur Internet
sera collecté par les services de renseignement, compilé, conservé
et retenu contre vous lors de votre procès.

"Pour une défense de la démocratie à l'ère numérique" http://goo.gl/FsRfbq
La Quadrature du Net : http://goo.gl/f16cw1
