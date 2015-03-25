Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:40435 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbbCYDjq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 23:39:46 -0400
In-Reply-To: <20150324231435.GN31762@carfax.org.uk>
References: <E8C63C11EA3FB04DBDFEDECEFD927FD1140C1E31@US-EVT-EXM04-P.global.tektronix.net> <20150325040321.361abf2f@natsu> <E8C63C11EA3FB04DBDFEDECEFD927FD1140C1E65@US-EVT-EXM04-P.global.tektronix.net> <20150324231435.GN31762@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: btrfs balance fails with no space errors (despite having plenty)
From: Russell Coker <russell@coker.com.au>
Date: Wed, 25 Mar 2015 14:39:38 +1100
To: Hugo Mills <hugo@carfax.org.uk>,
        "Kline, Matthew" <matthew.kline@flukenetworks.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <A8460D29-9B8D-46FC-B858-A00F38D27088@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been having ongoing issues with balance failing with no space errors in spite of having plenty. Strangely it seems to most often happen from cron jobs, when a cron job fails I can count on a manual balance succeeding.

I'm running the latest Debian/Jessie kernel.
-- 
Sent from my Samsung Galaxy Note 3 with K-9 Mail.
