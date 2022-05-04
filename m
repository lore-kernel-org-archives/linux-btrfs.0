Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72CC7C433F5
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 May 2022 09:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241653AbiEDJeV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 4 May 2022 05:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347407AbiEDJeG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2022 05:34:06 -0400
X-Greylist: delayed 90624 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 04 May 2022 02:30:30 PDT
Received: from ssl1.xaq.nl (ssl1.xaq.nl [IPv6:2a10:3781:1891:64::24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E61F19C23
        for <linux-btrfs@vger.kernel.org>; Wed,  4 May 2022 02:30:30 -0700 (PDT)
Received: from kakofonix.xaq.nl (kakofonix.utr.xaq.nl [192.168.64.105])
        by ssl1.xaq.nl (Postfix) with ESMTPSA id 3E81B81B3F
        for <linux-btrfs@vger.kernel.org>; Wed,  4 May 2022 11:30:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lucassen.org;
        s=202104; t=1651656628;
        bh=Vu3wsjM7GfAWG4kq7N2UHuRUolL9DkbdYMvTC1BraG4=;
        h=Date:From:To:Subject:In-Reply-To:References:Reply-To;
        b=dgakdUbq2C9bDnDvpJuYaGBWjxddRHJQoNybtp4/IVFskrf7qxRtutxNzpgRBpMR5
         YHhll/gKbXN1dqN12QMjmDhD9BtFZfS8BhEujal5//GXkTMc5S7bvolV5HytMsrvjJ
         O8yfUmUIy8JU6OaedUC/gAjyuXNZwnaVSClPyFdXonYYYOFfA7UmMcjwe8IfMNGqUk
         VnPh1wAEnOIsfvKF6z7lwYwpTkVPY5iXisLwZQtcbe86X/JCx3Zlc/5mk57+dkcKmW
         pCxwrNu2WxgRs9tb2WJ+RVOcwinmL5FcSgZIbofcaXLmpbRe1gNTCBkpqC99iwph3x
         aFZt51eetgJ2A==
Date:   Wed, 4 May 2022 11:30:27 +0200
From:   richard lucassen <mailinglists@lucassen.org>
To:     linux-btrfs@vger.kernel.org
Subject: Re: Debian Bullseye install btrfs raid1
Message-Id: <20220504113027.4bb4352c3735797658bbd7b0@lucassen.org>
In-Reply-To: <c0a5db9f-2631-9177-929c-9e76a9c67ec5@suse.com>
References: <20220504112315.71b41977e071f43db945687c@lucassen.org>
        <c0a5db9f-2631-9177-929c-9e76a9c67ec5@suse.com>
Reply-To: linux-btrfs@vger.kernel.org
Organization: XAQ Systems
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 4 May 2022 12:27:29 +0300
Nikolay Borisov <nborisov@suse.com> wrote:


> > Question: is this newbie trying to set up an impossible config or
> > have I missed something crucial somewhere?
> 
> That's the default behavior, the reasoning is if you are missing one 
> device of a raid1 your data is at-risk in case the 2nd device fails.
> You can override this behavior by mounting in degraded mode, that is
> mount -odegraded

Thnx! I'll have a look at that option.

R.

-- 
richard lucassen
https://contact.xaq.nl/
