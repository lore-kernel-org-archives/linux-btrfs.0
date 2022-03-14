Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12176C433F5
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Mar 2022 18:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241519AbiCNS6r (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Mar 2022 14:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbiCNS6q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Mar 2022 14:58:46 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D387679
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Mar 2022 11:57:36 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 84D021F37E;
        Mon, 14 Mar 2022 18:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1647284255;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lJrcUMqbaHaCWii0uaEPMekjsnKOyHRAW4V+MPjW8R0=;
        b=FIEXtgX5Mh7ExTJ6CDEgmQGBpQ5i4+WNhpFhM8FPTUJW9rWa2e3U/6u3DWCNlF/sW8aS7T
        noLFFpqfFg54+QFTpn92hEjiZgP4b9z+rar4gwalCE4WBsadu92LuYfA4yhCOSzR7U/jan
        dAOrrocRS5hKWttp9nGmeGhnO/fFGnw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1647284255;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lJrcUMqbaHaCWii0uaEPMekjsnKOyHRAW4V+MPjW8R0=;
        b=2DujkUpmK+WKB/TeJ7Zo1uGrqzxvoIibXlzY4wF0wCpIRjeav8WFAoYhJck3Cz7jW8UmTx
        p6UrfPFFI/xVNDAQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 7C546A3B81;
        Mon, 14 Mar 2022 18:57:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C2833DA7E1; Mon, 14 Mar 2022 19:53:36 +0100 (CET)
Date:   Mon, 14 Mar 2022 19:53:36 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: btrfs_dev_replace_finishing use fs_devices pointer
Message-ID: <20220314185336.GL12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <98ecea7936c8b9abbc5a111942b2f95dc395bdb3.1647218125.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98ecea7936c8b9abbc5a111942b2f95dc395bdb3.1647218125.git.anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 14, 2022 at 10:09:29AM +0800, Anand Jain wrote:
> In the function btrfs_dev_replace_finishing, we dereferenced
> fs_info->fs_devices 6 times instead keep a pointer to the fs_devices.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Added to misc-next, thanks.
