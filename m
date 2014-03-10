Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:36133 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaCJH0X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 03:26:23 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: "quwenruo@cn.fujitsu.com" <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Kernel BUG: btrfs send - Incremental backup
Date: Mon, 10 Mar 2014 08:25:26 +0100
Message-ID: <1975990.QvfbKRKJvK@tethys>
In-Reply-To: <531D20A3.1030204@cn.fujitsu.com>
References: <2853810.EcqZt5vpol@tethys> <531D20A3.1030204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le lundi 10 mars 2014 02:16:01 vous avez écrit :
> Does the filesystem pass the btrfsck?
> If not, would you please try btrfsck first?

It passes scrub with 0 errors... Do I need to bring it offline to pass btrfsck 
anyway ?

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

