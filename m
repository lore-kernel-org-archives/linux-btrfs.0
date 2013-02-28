Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:56122 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3B1NDE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Feb 2013 08:03:04 -0500
Received: from mfilter5-d.gandi.net (mfilter5-d.gandi.net [217.70.178.132])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id 7E5E941C09E
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2013 14:03:02 +0100 (CET)
Received: from relay5-d.mail.gandi.net ([217.70.183.197])
	by mfilter5-d.gandi.net (mfilter5-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id vnpQekaKEROK for <linux-btrfs@vger.kernel.org>;
	Thu, 28 Feb 2013 14:03:01 +0100 (CET)
Received: from [192.168.1.66] (AMontpellier-256-1-187-75.w92-143.abo.wanadoo.fr [92.143.82.75])
	(Authenticated sender: swami@petaramesh.org)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 0E33E41C06D
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2013 14:03:00 +0100 (CET)
Message-ID: <512F5583.4060406@petaramesh.org>
Date: Thu, 28 Feb 2013 14:02:59 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Defragmenting open files
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi folks,

My BTRFS systems now have slowed down to the point where I finally
decided to trash all my snapshots and try and defrag it all.

I basically wrote a shell script that goes down the complete FS tree,
runs a "filefrag" over each file and issues a "btrfs filesystem defrag
$blah" against every files which number of fragments is > 1.

I'm currently running it, but I notice that for every file that is
likely open (i.e. /bin/bash), my script spits out :

failed to open /bin/bash
open:: Text file busy
total 1 failures
FAILED !

I expected that the BTRS defragmentation was done by the kernel and was
able to handle open files, but apparently not ?

Another question is : Is there a way to determine if a directory needs a
defrag ? filefrag doesn't seem to be able to work properly against a
directory...

TIA.

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

