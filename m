Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:35888 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752349AbeDYL3w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 07:29:52 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
        by mailgw-01.dd24.net (Postfix) with ESMTP id 17EE05FE02
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 11:29:51 +0000 (UTC)
Received: from mailgw-01.dd24.net ([192.168.1.35])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10235)
        with ESMTP id GLpxbmZR0ZH4 for <linux-btrfs@vger.kernel.org>;
        Wed, 25 Apr 2018 11:29:49 +0000 (UTC)
Received: from heisenberg-old.fritz.box (ppp-82-135-83-161.dynamic.mnet-online.de [82.135.83.161])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailgw-01.dd24.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 11:29:49 +0000 (UTC)
Message-ID: <8c13c7b8794cb214b4a34078d24f4ffd7bd56f25.camel@scientia.net>
Subject: Re: Btrfs progs release 4.16.1
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-btrfs@vger.kernel.org
Date: Wed, 25 Apr 2018 13:29:48 +0200
In-Reply-To: <64535388-9024-087c-3d67-4425cd4b0292@gmail.com>
References: <20180424115857.25174-1-dsterba@suse.com>
         <pan$3f697$9cfd5cd2$6e9f2dc3$73937e71@cox.net>
         <20180425110234.GN21272@twin.jikos.cz>
         <64535388-9024-087c-3d67-4425cd4b0292@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2018-04-25 at 07:22 -0400, Austin S. Hemmelgarn wrote:
> While I can understand Duncan's point here, I'm inclined to agree
> with 
> David

Same from my side... and I run a multi-PiB storage site (though not
with btrfs).

Cosmetically one shouldn't do this in a bugfix release, this should
have really no impact on the real world.

The typical sysadmin will anyway use some stable distribution... and is
there any which ships already 4.16?

Cheers,
Chris.
