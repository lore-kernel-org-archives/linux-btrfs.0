Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:48999 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaJ0M72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 08:59:28 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Marc Dietrich <marvin24@gmx.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: nocow and compression
Date: Mon, 27 Oct 2014 13:59:24 +0100
Message-ID: <2878318.cpxBgqOiao@vajra>
In-Reply-To: <2033879.2EPALEPetI@fb07-iapwap2>
References: <2033879.2EPALEPetI@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le lundi 27 octobre 2014, 13:56:07 Marc Dietrich a écrit :
> oops, no compression.
> Is this intended?

« Compression does not work for NOCOW files » is clearly stated in

https://btrfs.wiki.kernel.org/index.php/Compression#How_does_compression_interact_with_direct_IO_or_COW.3F

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

Quand les doutes sont balayés, la foi véritable réapparaît, confirmée et 
redressée. Plus rien ne demeure, rien qu'il faille se remémorer.
-- Seng-Ts'an, Troisième Patriarche, Le Sin-sin-ming (VIIe s)

