Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 50-193-208-193-static.hfc.comcastbusiness.net ([50.193.208.193]:52071
	"EHLO tetsuo.zabbo.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab2GCRmL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2012 13:42:11 -0400
Message-ID: <4FF32EF2.2090403@zabbo.net>
Date: Tue, 03 Jul 2012 10:42:10 -0700
From: Zach Brown <zab@zabbo.net>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS fsck apparent errors
References: <4FF30B55.6060205@petaramesh.org> <20120703152208.GA28701@carfax.org.uk> <20120703155212.GG5326@twin.jikos.cz> <4FF31D41.8070907@zabbo.net> <20120703173742.GH5326@twin.jikos.cz>
In-Reply-To: <20120703173742.GH5326@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> read-only mode is default and (hopefully) does no writes to the device,
> this would require the --repair option so what you propose is sort of a
> sanity check, right?

Ah, I didn't realize that it didn't write without --repair.  Yeah,
making sure that people don't try to combine the repair and
read-from-mounted-devices options seems reasonable.

- z
