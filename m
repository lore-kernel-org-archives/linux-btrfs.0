Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80336C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Feb 2021 20:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CCE064F41
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Feb 2021 20:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhBCUZz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 15:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbhBCUZz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Feb 2021 15:25:55 -0500
X-Greylist: delayed 93 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 03 Feb 2021 12:25:10 PST
Received: from fbo-3.mxes.net (fbo-3.mxes.net [IPv6:2605:d100:2f:10::324])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259CFC061573
        for <linux-btrfs@vger.kernel.org>; Wed,  3 Feb 2021 12:25:10 -0800 (PST)
Received: from smtp-out-4.mxes.net (smtp-out-4.mxes.net [198.205.123.69])
        by fbi-3.mxes.net (Postfix) with ESMTP id 967C575966
        for <linux-btrfs@vger.kernel.org>; Wed,  3 Feb 2021 15:24:23 -0500 (EST)
Received: from Customer-MUA (mua.mxes.net [IPv6:fd::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp.mxes.net (Postfix) with ESMTPSA id 56B1C759D5;
        Wed,  3 Feb 2021 15:23:31 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mxes.net; s=mta;
        t=1612383813; bh=gH1cctNBCMvN3nWzG1KbSrfOwG+cttPES9YzWpytr8s=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=P4J7ozZwu1eXcX30AY4kT4hENbTxv2FJCurLIhLPWWG1M4FPomQ4lnWHBFbAcXRvG
         bGrpbOhjKmtmtDUgJ4pXhOz2xQmy50NwGXk0sL/zI72YnD0pfUGCo0j5iB4cXC5NYW
         t55+FvO10CotYMUkaH+XRK4HrtYi4w/TKaSXOxZo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrewnesbit.org;
        s=default; t=1612383813;
        bh=gH1cctNBCMvN3nWzG1KbSrfOwG+cttPES9YzWpytr8s=; l=816;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=Sd3dNwPF1UmWfgFOT6oeK+hEPCwMVc3+QRtREt0O4S4ih+Cv9Y+iyzYf6J240tG96
         b0V6LPSRHv5lHyTwYewIitWdq6ZZyQVeNE9JMTO+arsyMto31iApK1CnAwJhEnCJHW
         B8+0puLsbs7ElK9z7nGCtzK06cGIanIJtTfkrLpI=
Subject: Re: put 2 hard drives in mdadm raid 1 and detect bitrot like btrfs
 does, what's that called?
To:     Cedric.dewijs@eclipso.eu, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <f5d8af48e8d5543267089286c01c476f@mail.eclipso.de>
From:   Andrew Luke Nesbit <ullbeking@andrewnesbit.org>
Message-ID: <b143d6c2-4b13-ca6b-9e74-81d385da90f5@andrewnesbit.org>
Date:   Wed, 3 Feb 2021 20:23:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <f5d8af48e8d5543267089286c01c476f@mail.eclipso.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Sent-To: <bGludXgtYnRyZnNAdmdlci5rZXJuZWwub3Jn>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 03/02/2021 19:04, Cedric.dewijs@eclipso.eu wrote:
> I am looking for a way to make a raid 1 of two SSD's, and to be able to detect corrupted blocks, much like btrfs does that. I recall being told about a month ago to use a specific piece of software for that, but i forgot to make a note of it, and I can't find it anymore.

Running SSD's in RAID1 has been contentious from the perspective that I 
have been researching storage technology.

Is there any serious, properly researched, and learned infornmation 
available about this?

The reason I ask is that, in a related situation, I have 4x high quality 
HGST SLC SAS SSD's, and I was seriously thinking that RAID0 might be the 
appropriate way to configure them.  This assumes a well designed backup 
strategy of course.

Is this foolhardy?

Andrew
