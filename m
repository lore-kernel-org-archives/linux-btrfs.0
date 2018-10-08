Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F26C65C20
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 16:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 967822089D
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 16:37:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 967822089D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbeJHXu2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 19:50:28 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:33806 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbeJHXu2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2018 19:50:28 -0400
Received: from tux.wizards.de (p3EE2F45F.dip0.t-ipconnect.de [62.226.244.95])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 1209E4160257;
        Mon,  8 Oct 2018 18:37:53 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id A6F79F015F1;
        Mon,  8 Oct 2018 18:37:52 +0200 (CEST)
Subject: Re: Curious problem: btrfs device stats & unpriviliged access
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <05c64256-71d3-81dc-3189-628e8cc0a5db@applied-asynchrony.com>
 <5eafba35-c79b-17f2-e296-aafddf06ebf1@mendix.com>
 <7bcc7f99-a857-6ef1-d2df-a256424d2b29@applied-asynchrony.com>
 <650dd0a2-f945-163d-d44b-db0f1cf21ac1@mendix.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <c13f4c95-ab2e-911d-6476-7f93f9c1e2c9@applied-asynchrony.com>
Date:   Mon, 8 Oct 2018 18:37:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <650dd0a2-f945-163d-d44b-db0f1cf21ac1@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 10/08/18 17:46, Hans van Kranenburg wrote:
<snip>
> fs.devices() also looks for dev_items in the chunk tree:
> 
> https://github.com/knorrie/python-btrfs/blob/master/btrfs/ctree.py#L481
> 
> So, BOOM! you need root.
> 
> Or just start a 0, ignore errors and start trying all devids until you
> found num_devices amount of them that work, yolo.

Since I need to walk /sys/fs/btrfs/ anyway I *think* I can just look
at the entries in /sys/fs/btrfs/<fsid>/devices/ and query them all
directly.

The skeleton btrfs_exporter already responds to http requests and
returns dummy metrics, using the official python client library.
I've found a nice little python sysfs scraper and now only need to
figure out how best to map the btrfs info in sysfs to useful metrics.
The privileged access issue would only have come into play much later,
but it seems I can avoid it after all, which is great.
I'm also (re-)learning python in the process, so that's the actual
thing slowing me down..

-h
