Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E54E0C433FE
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Apr 2022 15:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349191AbiDNQAl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 12:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352739AbiDNPRm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Apr 2022 11:17:42 -0400
X-Greylist: delayed 1544 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 14 Apr 2022 08:03:18 PDT
Received: from twin.jikos.cz (twin.jikos.cz [91.219.245.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BD6395A07;
        Thu, 14 Apr 2022 08:03:16 -0700 (PDT)
Received: from twin.jikos.cz (dave@localhost [127.0.0.1])
        by twin.jikos.cz (8.13.6/8.13.6) with ESMTP id 23EEbTZI002298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Thu, 14 Apr 2022 16:37:30 +0200
Received: (from dave@localhost)
        by twin.jikos.cz (8.13.6/8.13.6/Submit) id 23EEbT8S002297;
        Thu, 14 Apr 2022 16:37:29 +0200
Date:   Thu, 14 Apr 2022 16:37:29 +0200
From:   David Sterba <dave@jikos.cz>
To:     dsterba@suse.cz, torvalds@linux-foundation.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs fixes for 5.18-rc3
Message-ID: <20220414143729.GP3658@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: dsterba@suse.cz, torvalds@linux-foundation.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1649705056.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1649705056.git.dsterba@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

I'm sending this from a different mail address after 2 days of no reply
and no merge of the btrfs updates (message body deleted in case it
triggers the spam filter). The mail is in lore archives at
https://lore.kernel.org/all/cover.1649705056.git.dsterba@suse.com/
