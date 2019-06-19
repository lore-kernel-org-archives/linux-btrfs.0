Return-Path: <SRS0=qrcf=US=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839A1C31E49
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Jun 2019 10:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CE2A206E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Jun 2019 10:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfFSKVg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Jun 2019 06:21:36 -0400
Received: from syrinx.knorrie.org ([82.94.188.77]:37070 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbfFSKVg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jun 2019 06:21:36 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 7FD96499B7641;
        Wed, 19 Jun 2019 12:21:34 +0200 (CEST)
Subject: Re: updating btrfs-debugfs to python3?
To:     =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtSE2VbeGFs9o=KhPTeRGwZJ=RA2uzc3xG+sU0X-SXbRuQ@mail.gmail.com>
 <08aa27af-8a9e-cd0c-20ab-55ce630085f4@applied-asynchrony.com>
From:   Hans van Kranenburg <hans@knorrie.org>
Message-ID: <b619d96d-92b1-fad0-4911-a1d8080470fc@knorrie.org>
Date:   Wed, 19 Jun 2019 12:21:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <08aa27af-8a9e-cd0c-20ab-55ce630085f4@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 6/19/19 12:13 PM, Holger Hoffstätte wrote:
> On 6/19/19 5:20 AM, Chris Murphy wrote:
>> This is on Fedora Rawhide (which is planned to become Fedora 31 due in
>> October), which no longer provides python2.
>>
>> $ ./btrfs-debugfs -b /
>> /usr/bin/env: ‘python2’: No such file or directory
>> $
>>
>> I expect other distros are going to follow as Python 2.7 EOL is coming
>> up fast, in 6 months.
>> https://pythonclock.org/
> 
> I just ran it through 2to3-3.7 with -w and the new version seems to work
> just fine for me, so it seems there is not much porting required.

I don't think you want to ship that program at all, for end users. It's
quite horrible, and the -b option even downloads the *entire* extent
tree to userspace in a very naive way.

There are way simpler, better performing alternatives...

Hans

