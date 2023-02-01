Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E43DC636CC
	for <linux-btrfs@archiver.kernel.org>; Wed,  1 Feb 2023 03:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjBADBQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 31 Jan 2023 22:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjBADBO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jan 2023 22:01:14 -0500
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D17C17141
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jan 2023 19:01:13 -0800 (PST)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout01.posteo.de (Postfix) with ESMTPS id D2B2A2406EA
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Feb 2023 04:01:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
        t=1675220471; bh=qO8cNrH/FxbTdDGsAcNYzmgOpn5dSXwX/z6vgQre3JM=;
        h=From:To:Date:From;
        b=IzHT7C3Yhykl84Hie+4G90VGOZgEYIBG5VHMJ8kas63pAsPzDdvn8gUQx/ypvke/S
         /4X+iKqBz0deRnYxTHEsw9RvOqkK0UYZaw2TEBbQpF9NA1sgJFCxcqbBFCyz5e33UA
         eOAmw4Zub1JoZf3IyTtwFvr7vOm8wNMedenQ2Vdo5NdDKIsh729X/dEqS7pRDDhFMe
         4b/8Dv4qBo4xNG/o1klaMOE2myGMMt9vaUXpCQ3v5vqU80lsOAszC+36KBnlD4KUx3
         XLFAkcxm/GuQGI2Kg6gWMktMot7Cuoq1hqLO8GzuyLrR0hvlweIiMBHGKvbnZJgLm3
         u04BZzlgtSlsg==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4P66BH0Cfkz9rxB
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Feb 2023 04:01:10 +0100 (CET)
From:   Nicholas Hubbard <nicholashubbard@posteo.net>
To:     linux-btrfs@vger.kernel.org
Date:   Wed, 01 Feb 2023 02:51:19 +0000
Message-ID: <87mt5yhyx4.fsf@slacktop.slacktop>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

subscribe linux-btrfs
