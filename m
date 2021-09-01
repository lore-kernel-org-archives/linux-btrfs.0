Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB08AC432BE
	for <linux-btrfs@archiver.kernel.org>; Wed,  1 Sep 2021 14:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2D9660F11
	for <linux-btrfs@archiver.kernel.org>; Wed,  1 Sep 2021 14:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244799AbhIAOGJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 10:06:09 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:51504 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244630AbhIAOGI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Sep 2021 10:06:08 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4508B224D0;
        Wed,  1 Sep 2021 14:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630505111; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=joINPukJoo45TnGzN7h/FuCa1Tze4iekpcINYxYZtog=;
        b=gRPbm6cIMhcOT5Nv34D2lRgsPV3JM3U2O2dxsng7g+SyouXFGNKy8wjnnxeBKtnbdhQyai
        2mfGZFFqExA2CkuNplacUTaprs83RAjFIDru/0jcpFc+iplp/ERwUndQeZpzA4eYOKJciR
        YEqXwKc1BMPvwjbcPvF5W2YsJNBnzTg=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 0EF1C13AD6;
        Wed,  1 Sep 2021 14:05:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 3UWcAJeIL2F/ZwAAGKfGzw
        (envelope-from <nborisov@suse.com>); Wed, 01 Sep 2021 14:05:11 +0000
Subject: Re: [PATCH v2 6/7] btrfs: unify common code for the v1 and v2
 versions of device remove
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1627419595.git.josef@toxicpanda.com>
 <2107b5db383aa3dfb54a30e5b0de015be1ff6d1f.1627419595.git.josef@toxicpanda.com>
From:   Nikolay Borisov <nborisov@suse.com>
Message-ID: <6d3d52c3-9267-3380-0c6f-aeaa6be6219d@suse.com>
Date:   Wed, 1 Sep 2021 17:05:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2107b5db383aa3dfb54a30e5b0de015be1ff6d1f.1627419595.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 28.07.21 г. 0:01, Josef Bacik wrote:
> These things share a lot of common code, v2 simply allows you to specify
> devid.  Abstract out this common code and use the helper by both the v1
> and v2 interfaces to save us some lines of code.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
