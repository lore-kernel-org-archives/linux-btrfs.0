Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34564 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab2LCLyg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2012 06:54:36 -0500
Received: from mfilter23-d.gandi.net (mfilter23-d.gandi.net [217.70.178.151])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id 01F99A809D
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Dec 2012 12:54:35 +0100 (CET)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter23-d.gandi.net (mfilter23-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id don50ukROgVB for <linux-btrfs@vger.kernel.org>;
	Mon,  3 Dec 2012 12:54:33 +0100 (CET)
Received: from [192.168.1.66] (AMontpellier-256-1-87-249.w90-28.abo.wanadoo.fr [90.28.142.249])
	(Authenticated sender: swami@petaramesh.org)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 7CBFAA807F
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Dec 2012 12:54:33 +0100 (CET)
Message-ID: <50BC92F6.6050404@petaramesh.org>
Date: Mon, 03 Dec 2012 12:54:30 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Example of BTRFS uglyssima performance : Bitcoin
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi folks,

My laptop is a Core i3-2310M with 4 GB RAM, running BTRFS on a 1 TB HD.

I run Ubuntu 12.10 Quantal, kernel 3.5.0-19-generic 64-bit.

I wanted to give a shot at bitcoin so I installed it from the Ubuntu
PPA, and started getting the database from the Internet. (it's now 4.5
GB big on disk). I assume it an SQL DB (SQlite or so ?)

My system currently has been crushing its data for more that 5 days now
(5x24 hours) with the HD busy to the point that the system is completely
unusable and I had to take another laptop to be able to surf the web and
process my email. Disk LED is steadily lit, trying to switch between 2
open windows takes 5 minutes or so...

Entering new blocks into the DB has now slowed down to the point that I
assume that the last 6% that I miss (I'm now at 94.something %) may well
take another couple weeks or so...

Friends running ext4 told me that the initial loading of the DB took
them a couple hours... With BTRFS it's been 5x24 hours and counting... :-(

This filesystem is pure crap as soon as it comes to database processing :-(

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

