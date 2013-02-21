Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:40230 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab3BUPqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 10:46:17 -0500
Received: from mfilter18-d.gandi.net (mfilter18-d.gandi.net [217.70.178.146])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id 463F8172090
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 16:46:16 +0100 (CET)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter18-d.gandi.net (mfilter18-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id 7qG7+lhXH+x4 for <linux-btrfs@vger.kernel.org>;
	Thu, 21 Feb 2013 16:46:14 +0100 (CET)
Received: from [192.168.1.66] (AMontpellier-256-1-85-163.w90-28.abo.wanadoo.fr [90.28.140.163])
	(Authenticated sender: swami@petaramesh.org)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id D265A1720E7
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 16:46:14 +0100 (CET)
Message-ID: <51264146.3070504@petaramesh.org>
Date: Thu, 21 Feb 2013 16:46:14 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Another defrag question
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi again,

Having numerous snapshots, I prefer to ask rather than take the risk of
exploding my storage space, better safe than sorry ;-)

"man btrfs" states :

« NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed
copies of data, don't use it if  you  use  snapshots,  have 
deduplicated  your  data  or  made  copies with cp --reflink. »

I use :
# uname -r
3.5.0-24-generic

...So should I expect that defraging my BTRFS will be smart enough not
to uncow my snapshots ? Is it actually able to defrag both the file and
its snapshots altogether, keeping all this as a single physical copy of
the defragged data ?

TIA.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

