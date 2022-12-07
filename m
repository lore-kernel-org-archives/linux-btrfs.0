Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B32AC63703
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Dec 2022 23:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiLGXNN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Dec 2022 18:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLGXNL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Dec 2022 18:13:11 -0500
Received: from mail.callehosting.com (mail.callehosting.com [216.244.93.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E410027DCD
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Dec 2022 15:13:10 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.callehosting.com (Postfix) with ESMTP id 75C726E84C
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Dec 2022 15:13:10 -0800 (PST)
X-Virus-Scanned: amavisd-new at callehosting.com
Received: from mail.callehosting.com ([127.0.0.1])
        by localhost (mail.callehosting.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LYLCEoliQs_K for <linux-btrfs@vger.kernel.org>;
        Wed,  7 Dec 2022 15:13:09 -0800 (PST)
Received: from www.callehosting.com (_www [192.168.33.12])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.callehosting.com (Postfix) with ESMTPSA id A40716E847
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Dec 2022 15:13:09 -0800 (PST)
Received: from SgO3U6JLoVN1Bmsh/YzWAYb/NEJid7j7
 by www.callehosting.com
 with HTTP (HTTP/1.1 POST); Wed, 07 Dec 2022 15:13:09 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 07 Dec 2022 15:13:09 -0800
From:   Olivier Calle <olivier@calle.org>
To:     linux-btrfs@vger.kernel.org
Subject: Re: Filesystem only mounts read-only after balance failure on enospc
In-Reply-To: <91999645c6ae4d70eaae0752c0d24e31@calle.org>
References: <91999645c6ae4d70eaae0752c0d24e31@calle.org>
Message-ID: <1790adf78aed033fcfff413c0edbbe7e@calle.org>
X-Sender: olivier@calle.org
User-Agent: Roundcube Webmail/1.1.12
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

As I said in my original message, I've tried mounting with skip_balance 
to no effect. I've also tried using "btrfs rescue zero-log" and 
clean_cache, also to no effect. If there's no feedback from devs, I 
suppose I'll have to reinstall my OS... maybe use ext4 this time. :-(

-- 
Olivier Calle
<olivier@calle.org>
