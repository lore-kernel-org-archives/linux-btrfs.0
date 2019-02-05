Return-Path: <SRS0=OwrN=QM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C664BC282CB
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 11:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F2F52080D
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 11:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfBELpa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 06:45:30 -0500
Received: from rigel.uberspace.de ([95.143.172.238]:47262 "EHLO
        rigel.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfBELp3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2019 06:45:29 -0500
Received: (qmail 27809 invoked from network); 5 Feb 2019 11:45:25 -0000
Received: from localhost (HELO webmail.rigel.uberspace.de) (127.0.0.1)
  by ::1 with SMTP; 5 Feb 2019 11:45:25 -0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 05 Feb 2019 12:45:25 +0100
From:   Moritz M <mailinglist@moritzmueller.ee>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Help needed, server is unresponsive after btrfs balance
In-Reply-To: <30c7e926-98c7-fd82-f587-1478d31cbf58@gmx.com>
References: <6c9257eb3b6451b67bd8b082e06a7735@moritzmueller.ee>
 <4ecaf7ef-49cb-d7f6-3535-941e44e2f469@gmx.com>
 <1a6d00fce82926ce9ec7db7bbab37c12@moritzmueller.ee>
 <30c7e926-98c7-fd82-f587-1478d31cbf58@gmx.com>
Message-ID: <8f0a80ce7323b216ab90fdcb475b6340@moritzmueller.ee>
X-Sender: mailinglist@moritzmueller.ee
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



Am 2019-02-04 14:55, schrieb Qu Wenruo:
> On 2019/2/4 下午8:49, Moritz M wrote:
>>> 
>>> You're using qgroups, it's known to cause huge performance overhead 
>>> for
>>> balance.
>>> 
>>> We have upcoming patches to solve it, but it not going to mainline
>>> before v5.1 kernel.
>>> 
>>> So please disable qgroups if you're not using it actively.
>>> 
>> 
>> Thanks, was not aware that I turned it on. Is
>> 
>> btrfs quota disable /
>> 
>> enough for disabling qgroups?
> 
> Yep

Do you have any idea how to validate if the enabled qgroups led to my 
problem?

