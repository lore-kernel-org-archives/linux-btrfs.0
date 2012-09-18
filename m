Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:44359 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756403Ab2IRPsn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 11:48:43 -0400
Received: from 193.30.77.188.dynamic.jazztel.es ([188.77.30.193] helo=mail.viric.name)
	by mho-01-ewr.mailhop.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <viric@viric.name>)
	id 1TE02U-000P5P-54
	for linux-btrfs@vger.kernel.org; Tue, 18 Sep 2012 15:48:42 +0000
Date: Tue, 18 Sep 2012 17:48:38 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Scrub status, finished?
Message-ID: <20120918154838.GE8632@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I run a scrub on a 2-disc btrfs, then cancelled it, then resumed. At the end, I
expected it telling about it having finished.

But the only I get on 'btrfs scrub status /' is:
scrub status for 2ebf9e90-104c-47a4-adff-fada1ce3b682
        scrub resumed at Tue Sep 18 15:27:45 2012, running for 5721 seconds
        total bytes scrubbed: 744.41GB with 0 errors

The numbers don't change anymore though. No disc activity, no seconds
increasing.

Maybe there is a bug reporting the 'finished' situation?

Regards,
Lluís.
