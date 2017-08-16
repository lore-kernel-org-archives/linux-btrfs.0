Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:56600 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751692AbdHPQym (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 12:54:42 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:41640)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1di1ab-0004LI-24
        for linux-btrfs@vger.kernel.org; Wed, 16 Aug 2017 17:54:41 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1di1aX-0006Ei-0o
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Aug 2017 17:54:37 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22932.30924.664070.703707@tree.ty.sabi.co.uk>
Date: Wed, 16 Aug 2017 17:54:36 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
In-Reply-To: <1502890308.5446.5.camel@scientia.net>
References: <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
        <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
        <1502496618.6092.6.camel@scientia.net>
        <20170812074248.GA3352@infradead.org>
        <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
        <1502713484.3608.1.camel@scientia.net>
        <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
        <49ebcfb9-b0c8-0feb-3570-a5b19c3e3b33@cobb.uk.net>
        <53633949-b04b-ec5c-f300-c0b702d22374@gmail.com>
        <1502740488.5384.5.camel@scientia.net>
        <20170816131230.GA28619@clm-mbp.thefacebook.com>
        <1502890308.5446.5.camel@scientia.net>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]

> But I've talked to some friend at the local super computing
> centre and they have rather general issues with CoW at their
> virtualisation cluster.

Amazing news! :-)

> Like SUSE's snapper making many snapshots leading the storage
> images of VMs apparently to explode (in terms of space usage).

Well, this could be an argument that some of your friends are being
"challenged" by running the storage systems of a "super computing
centre" and that they could become "more prepared" about system
administration, for example as to the principle "know which tool to
use for which workload". Or else it could be an argument that they
expect Btrfs to do their job while they watch cat videos from the
intertubes. :-)
