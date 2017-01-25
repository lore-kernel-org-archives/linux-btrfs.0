Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-04.prod.phx3.secureserver.net ([184.168.200.145]:52050
        "EHLO p3nlsmtpcp01-04.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751849AbdAYTo1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 14:44:27 -0500
Date: Thu, 26 Jan 2017 01:13:15 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btfs-progs: fsck-tests: corrupt nlink value test
Message-ID: <20170125194314.GA10888@giis.co.in>
References: <20170107231955.GA24631@fedori>
 <c9e21f30-2231-94cd-09ed-8422951e7b69@cn.fujitsu.com>
 <fdc7f38883f4333cad73b7a92a1ba00a@giis.co.in>
 <77e26cd7-0390-d02e-3dda-7107a2c68e7d@cn.fujitsu.com>
 <f5ef3a5bec7fccbd06559eda6a7cf59a@giis.co.in>
 <9592e847-74a9-d530-96a1-b7b8888975e3@cn.fujitsu.com>
 <43f607d52e2ba14633096022575bb5de@giis.co.in>
 <20170117151506.GS12081@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170117151506.GS12081@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Both approaches have their pros and cons so I'll accept both. The
> functionality provided by the corrupt block utility can be used, any
> changes to the command line UI will be also applied to the test scripts.

okay, I'll continue mixing both approaches. 
