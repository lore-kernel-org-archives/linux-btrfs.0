Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E1DC6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 11:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CD3D2064C
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 11:29:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7CD3D2064C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbeJZUGZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 16:06:25 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:58816 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727491AbeJZUGZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 16:06:25 -0400
Received: from tux.wizards.de (p3EE2F45F.dip0.t-ipconnect.de [62.226.244.95])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 016644160376;
        Fri, 26 Oct 2018 13:29:39 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 9D7FBEEB841;
        Fri, 26 Oct 2018 13:29:39 +0200 (CEST)
Subject: Re: [PATCH] btrfs: Fix error handling in
 btrfs_cleanup_ordered_extents
To:     Nikolay Borisov <nborisov@suse.com>, dsterba@suse.com
Cc:     linux-btrfs@vger.kernel.org, wqu@suse.com
References: <1540552427-8108-1-git-send-email-nborisov@suse.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <6d0153c2-baf8-704d-c902-00c713e12402@applied-asynchrony.com>
Date:   Fri, 26 Oct 2018 13:29:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1540552427-8108-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 10/26/18 13:13, Nikolay Borisov wrote:

> +	if (page_start >= offset && page_end <= (offset + bytes - 1) {

fs/btrfs/inode.c: In function 'btrfs_cleanup_ordered_extents':
fs/btrfs/inode.c:140:62: error: expected ')' before '{' token
   if (page_start >= offset && page_end <= (offset + bytes - 1) {
      ~                                                        ^~
                                                               )
You're welcome :)

Holger

