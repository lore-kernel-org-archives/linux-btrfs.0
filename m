Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:46719 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab2FYULz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 16:11:55 -0400
Date: Mon, 25 Jun 2012 16:11:52 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Priebe <s.priebe@profihost.ag>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs deadlock in 3.5-rc3
Message-ID: <20120625201151.GG7404@localhost.localdomain>
References: <4FE58366.8000302@profihost.ag>
 <4FE862D7.3060005@fusionio.com>
 <4FE870DF.90308@profihost.ag>
 <20120625142048.GB7404@localhost.localdomain>
 <4FE8796E.9030300@profihost.ag>
 <20120625144807.GC7404@localhost.localdomain>
 <4FE8A21E.7050104@profihost.ag>
 <20120625180252.GD7404@localhost.localdomain>
 <4FE8ADBA.20505@profihost.ag>
 <4FE8BCF5.4080605@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FE8BCF5.4080605@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 25, 2012 at 01:33:09PM -0600, Stefan Priebe wrote:
> With v3.4 the same. Can't go back more as this really results in very 
> fast corruption. Any ideas how to debug?
> 

What workload are you running?  I have a ssd here with discard support I can try
and reproduce on.  Thanks,

Josef
