Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274DBC433EF
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Feb 2022 16:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356314AbiBNQXV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Feb 2022 11:23:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356313AbiBNQXS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Feb 2022 11:23:18 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066D560AA5
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Feb 2022 08:23:10 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A98CC210F4;
        Mon, 14 Feb 2022 16:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1644855789;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mw8ih5v3JBH0jiK19wmyysBHVH3c74a753/M7sc+D10=;
        b=TdHJ9KPflMGdFIatwOZwu9dhtNeeoab/P9IM5rImRGMGjfOh/g4rG/SRnW3keFzy+3VCj/
        Gca09E0v2UT/a0RUaN+rsoDnSFdbx75cTYuJUbEKzJp2SHpjTqutNtuJQt9MEEouw2Di9T
        EP/4NCrwHp5NANgPdSg5kqc8an7X0F8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1644855789;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mw8ih5v3JBH0jiK19wmyysBHVH3c74a753/M7sc+D10=;
        b=G5ezImoVZ4l+BsMJjMVSqfhEtycUbfn18RLF1LJRlyRtPhMsxceaM72JG480h6sfzu8a7e
        WLh8dp/nqkVcArDA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id A173DA3B84;
        Mon, 14 Feb 2022 16:23:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1D5A0DA832; Mon, 14 Feb 2022 17:19:26 +0100 (CET)
Date:   Mon, 14 Feb 2022 17:19:26 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs: defrag: use btrfs_defrag_ctrl to replace
 btrfs_ioctl_defrag_range_args for btrfs_defrag_file()
Message-ID: <20220214161925.GE12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Filipe Manana <fdmanana@kernel.org>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1643357469.git.wqu@suse.com>
 <34c2aa1e7c5e196420d68de1f67b8973d49e284b.1643357469.git.wqu@suse.com>
 <YfwOJ0UT5t64BhVG@debian9.Home>
 <64316118-4f91-a277-d28a-24f74f2e6056@gmx.com>
 <20220204175742.GG14046@twin.jikos.cz>
 <20220204180031.GH14046@twin.jikos.cz>
 <20220204181707.GI14046@twin.jikos.cz>
 <20220208170044.GD12643@twin.jikos.cz>
 <9292fc4a-9c6e-8e28-8203-f70118e9ee20@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9292fc4a-9c6e-8e28-8203-f70118e9ee20@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 09, 2022 at 08:15:42AM +0800, Qu Wenruo wrote:
> On 2022/2/9 01:00, David Sterba wrote:
> >>>
> >>> I thought we've had all the { 0 } converted to {} but no so I get the
> >>> consistency agrument.
> >>
> >> https://lore.kernel.org/all/20210910225207.3272766-1-keescook@chromium.org/
> >>
> >> A tree-wide change but it did not get pulled in the end. The problematic
> >> compiler was gcc 4.9 but the current minimum requirement is 5.1 so I
> >> wonder how much relevant it is.
> >
> > I've asked Kees, seems that the conversion is not necessary. Thus, I'd
> > stay with { 0 } that we have now as it's the most used initializer.
> >
> > No need to resend patches just if there's {}, I'll fix it up anywhere I
> > see it.
> 
> So the preferred style reverts back to "= { 0 };", right?

Yes
