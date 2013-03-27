Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:45260 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab3C0I4x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 04:56:53 -0400
Received: from mfilter21-d.gandi.net (mfilter21-d.gandi.net [217.70.178.149])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id 433AD41C128
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 09:56:52 +0100 (CET)
Received: from relay5-d.mail.gandi.net ([217.70.183.197])
	by mfilter21-d.gandi.net (mfilter21-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id Sise5M+cULhd for <linux-btrfs@vger.kernel.org>;
	Wed, 27 Mar 2013 09:56:50 +0100 (CET)
Received: from [192.168.1.66] (AMontpellier-256-1-61-174.w90-28.abo.wanadoo.fr [90.28.28.174])
	(Authenticated sender: swami@petaramesh.org)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id BA1ED41C15C
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 09:56:50 +0100 (CET)
Message-ID: <5152B451.8090100@petaramesh.org>
Date: Wed, 27 Mar 2013 09:56:49 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: BTRFS and the steadily lit LED
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

After having received strong advice from the people in this list to
upgrade my kernel to the latest one, I have installed 3.8.0-14-generic
#24-Ubuntu SMP x86_64 on several (4) machines.

In the hope of improving systems speed I had also removed all snapshots
then defragged the FSes - the snapshots have been recreated since, as I
use the excellent SuSE "Snapper" tool.

But well, all 4 machines are still slow like hell. All of them are used
for quite basic daily tasks - web browsing, email, typical LibreOffice
tasks, nothing very mysterious there, no specific heavy DB work.

All machines have 64-bits Linuxes (either Ubuntu 12.10 or 13.04ß), with
decent amounts of RAM - 2 GB to 4 GB - and disks filled less than 75%

With such a setup, I would expect any decent filesystem to deliver
excellent performance. Still, all of my machines are slow like hell and
I'm most of the time in mode « Working my patience while waiting for the
HD LED to go off ».

I haven't noticed any real-life noticeable improvement upgrading the
kernels from 3.5.x to 3.8.x

So I'm wondering...

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

