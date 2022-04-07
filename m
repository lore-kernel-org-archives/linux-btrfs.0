Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA80C433EF
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Apr 2022 19:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbiDGTNb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 15:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbiDGTN3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Apr 2022 15:13:29 -0400
Received: from mail.lichtvoll.de (lichtvoll.de [IPv6:2001:67c:14c:12f::11:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0339222EB10
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Apr 2022 12:11:28 -0700 (PDT)
Received: from 127.0.0.1 (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id 8246C3FDA55;
        Thu,  7 Apr 2022 21:11:27 +0200 (CEST)
From:   Martin Steigerwald <martin@lichtvoll.de>
To:     Marc MERLIN <marc@merlins.org>, Josef Bacik <josef@toxicpanda.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Rebuilding 24TB Raid5 array (was btrfs corruption: parent transid verify failed + open_ctree failed)
Date:   Thu, 07 Apr 2022 21:11:26 +0200
Message-ID: <2650970.mvXUDI8C0e@ananda>
In-Reply-To: <CAEzrpqdeph1AM74habMeOg_VURv5AFvZZ-9aUM9ZVEkM+-3Xkg@mail.gmail.com>
References: <11970220.O9o76ZdvQC@ananda> <20220407162951.GD25669@merlins.org> <CAEzrpqdeph1AM74habMeOg_VURv5AFvZZ-9aUM9ZVEkM+-3Xkg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Authentication-Results: mail.lichtvoll.de;
        auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Josef Bacik - 07.04.22, 19:07:14 CEST:
> Ok let it keep going, I have an idea of how to make this less awful
> but also not use all the memory.  I'm going to start writing this up
> now, if I finish before your run finishes you can switch to the new
> shit and see how that goes.  I've got meetings until 4pm my time (it's
> 1pm my time), so you're not going to hear from me for a while.

You guys are having fun with that, it seems.

-- 
Martin


