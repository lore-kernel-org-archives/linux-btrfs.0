Return-Path: <SRS0=y50c=C6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC16BC4346E
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Sep 2020 18:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D71D20888
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Sep 2020 18:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbgIUSTv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Sep 2020 14:19:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:48844 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIUSTv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Sep 2020 14:19:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2B327AC0C;
        Mon, 21 Sep 2020 18:20:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1FE53DA6E0; Mon, 21 Sep 2020 20:18:35 +0200 (CEST)
Date:   Mon, 21 Sep 2020 20:18:34 +0200
From:   David Sterba <dsterba@suse.cz>
To:     A L <mail@lechevalier.se>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Btrfs wiki lincese and GDPR notices?
Message-ID: <20200921181834.GO6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, A L <mail@lechevalier.se>,
        linux-btrfs@vger.kernel.org
References: <b317b7cc-8810-57ea-b859-6bef7638a5c7@lechevalier.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b317b7cc-8810-57ea-b859-6bef7638a5c7@lechevalier.se>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

On Sun, Sep 20, 2020 at 11:03:07AM +0200, A L wrote:
> Under what license are the content and uploaded images and documents on  
> https://btrfs.wiki.kernel.org/

I think nobody has asked this question until now, so I don't know.

> For example, file have no copyright or license information:
> https://btrfs.wiki.kernel.org/index.php/File:Send_subvol_command.png
> https://btrfs.wiki.kernel.org/index.php/File:Fs-tree.svg
> 
> Currently the "Privacy Policy" and "About" pages are empty. There is 
> also no GDPR information.

All the wikis fall under the Linux foundation policies regarding
accounts, so the GDPR questions better be directed there
(https://korg.docs.kernel.org/wiki.html,
https://korg.docs.kernel.org/support.html).
