Return-Path: <SRS0=c8Io=V3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0331C0650F
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jul 2019 11:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C01C2087F
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jul 2019 11:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730297AbfG3LeG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Jul 2019 07:34:06 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:47344 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728554AbfG3LeG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jul 2019 07:34:06 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jul 2019 07:34:05 EDT
Received: from tux.wizards.de (p5DE2B3A0.dip0.t-ipconnect.de [93.226.179.160])
        by mail02.iobjects.de (Postfix) with ESMTPSA id DE39A41604DD;
        Tue, 30 Jul 2019 13:28:57 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 83BCCF01614;
        Tue, 30 Jul 2019 13:28:57 +0200 (CEST)
Subject: Re: Btrfs progs release 5.2.1
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     linux-btrfs@vger.kernel.org
References: <20190726155847.12970-1-dsterba@suse.com>
 <87tvb3wz43.fsf@tarshish>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <aedcf3a3-6060-d3a9-9998-2119e2360429@applied-asynchrony.com>
Date:   Tue, 30 Jul 2019 13:28:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87tvb3wz43.fsf@tarshish>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 7/30/19 1:17 PM, Baruch Siach wrote:
> Hi David,
> 
> On Fri, Jul 26 2019, David Sterba wrote:
>> btrfs-progs version 5.2.1 have been released. This is a bugfix release.
>>
>> Changes:
>>    * scrub status: fix ETA calculation after resume
>>    * check: fix crash when using -Q
>>    * restore: fix symlink owner restoration
>>    * mkfs: fix regression with mixed block groups
>>    * core: fix commit to process all delayed refs
>>    * other:
>>      * minor cleanups
>>      * test updates
>>
>> Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
>> Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
> 
> The last commit in this repo's master branch is 608fd900ca45 ("Btrfs
> progs v5.2"). Where can I find the updated git repo?

https://github.com/kdave/btrfs-progs

I believe kernel.org is just a mirror and in this case might not have been
updated for some reason.

-h
