Return-Path: <SRS0=+Z9o=3E=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C299C33CB1
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jan 2020 13:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 476BC2084D
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jan 2020 13:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgAONKp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 08:10:45 -0500
Received: from mail.itouring.de ([188.40.134.68]:35730 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbgAONKp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Jan 2020 08:10:45 -0500
Received: from tux.applied-asynchrony.com (p5B07E981.dip0.t-ipconnect.de [91.7.233.129])
        by mail.itouring.de (Postfix) with ESMTPSA id 6053A416A139
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2020 14:10:43 +0100 (CET)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 13413F01607
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2020 14:10:43 +0100 (CET)
Subject: Re: Scrub resume regression
To:     linux-btrfs@vger.kernel.org
References: <d0a97688-78be-08de-ca7d-bcb4c7fb397e@cobb.uk.net>
 <20200115125134.GN3929@twin.jikos.cz>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <5aa23833-d1e2-fe6f-7c6e-f366d3eccbe3@applied-asynchrony.com>
Date:   Wed, 15 Jan 2020 14:10:42 +0100
MIME-Version: 1.0
In-Reply-To: <20200115125134.GN3929@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 1/15/20 1:51 PM, David Sterba wrote:
>> It is important that scrub always returns the stats, even when it
>> returns an error. This is critical for cancel, as that is how
>> cancel/resume works, but it should also apply in case of other errors so
>> that the user can see how much of the scrub was done before the fatal error.
> 
> That's something we need to document in code and perhaps in the manual
> pages too.

Isn't the real problem that cancel does not actually mean cancel,
but rather also implies "..and maybe continue"? IMHO cancel should cancel
(and say how much work was performed), while the intention to resume should
be called e.g. "pause". This makes the behaviour clear and prevents
accidental semantic overlap.

-h
