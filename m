Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:59011 "EHLO
	relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbcAHOC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jan 2016 09:02:29 -0500
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Martin Steigerwald <martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Subject: Re: send/receive for encrypted backup purposes
Date: Fri, 08 Jan 2016 15:02:24 +0100
Message-ID: <4248922.XAnqWXRFKA@vajra>
In-Reply-To: <1452261646.6727.12.camel@scientia.net>
References: <1827847.pVfOzZHEoP@merkaba> <1452261646.6727.12.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le vendredi 8 janvier 2016, 15:00:46 Christoph Anton Mitterer a écrit :
> Shouldn't any crypto that can read from stdin and write to stdout do
> that?
> E.g. simply ssh.
> 
> hostA$ btrfs send foo | ssh hostB btrfs receive bar

It works, I do this on a regular basis…

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

L'idée que chacun se fait du nombre un, quelle qu'elle soit, doit être
soigneusement distinguée du nombre un, comme les idées de la lune doivent
être distinguées de la lune elle-même.
– Gottlob Frege, Les lois de base de l'arithmétique, 1893

