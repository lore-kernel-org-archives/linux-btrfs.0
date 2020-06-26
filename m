Return-Path: <SRS0=C+P9=AH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B045FC433DF
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Jun 2020 17:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7020420663
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Jun 2020 17:29:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=vivaldi.com header.i=@vivaldi.com header.b="ZakqFPaN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgFZR30 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Jun 2020 13:29:26 -0400
Received: from mail.vivaldi.com ([31.209.137.20]:37010 "EHLO mail.vivaldi.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgFZR30 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jun 2020 13:29:26 -0400
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jun 2020 13:29:25 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.vivaldi.com (Postfix) with ESMTP id E00461F8CCA;
        Fri, 26 Jun 2020 17:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=vivaldi.com; h=
        mime-version:content-transfer-encoding:date:date:subject:subject
        :from:from:message-id:content-type:content-type:received
        :received; s=2019; t=1593192031; bh=ALsl5Hto3v039sXr/XXjXojZ2+p1
        8MjOffrQhv3/A5U=; b=ZakqFPaNQyoGYb3LHFEXZmaJMoMKOrav/k0JC2XUJr9i
        QmX19Dlt+qmZSWpPhFxGwZSX2PqNjL7Rd6w33luvthsVpimDwhTL33lNLttkhC39
        jGRdqUo67irkWLBgZkYDz91ybTDccOL73YcvogswSPYhY3dCJAukCwXVCVTnma8r
        FRnkBsCvSrrHYQZ38dSe6u8ARF/93FZOArsWgGZdwDAgCY+uhQt6+1fRv0xguYZ5
        Itryez7T5md6lBrKGX9sTZLgs0vF7sRMgd9hRpEd4ReHOA7puiy1BYWQy8AtM6bF
        0FIJ9Z+405+nQZrHUeZwQFOuAOZbGG3TAJxiDjK80A==
X-Virus-Scanned: Debian amavisd-new at vivaldi.com
Received: from mail.vivaldi.com ([127.0.0.1])
        by localhost (staffmail.viv.dc01 [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 3OBDvSuE6sax; Fri, 26 Jun 2020 17:20:31 +0000 (UTC)
Received: from localhost (c-73-100-158-145.hsd1.ma.comcast.net [73.100.158.145])
        by mail.vivaldi.com (Postfix) with ESMTPSA id 5F2DD1F8510;
        Fri, 26 Jun 2020 17:20:31 +0000 (UTC)
Content-Type: text/plain; charset=utf-8; format=flowed
Message-Id: <1593191537286.66084742.1576675846@vivaldi.com>
From:   Christian Dysthe <christian@vivaldi.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Marc MERLIN <marc@merlins.org>
Subject: Is this btrfs scrub script still viable?
Date:   Fri, 26 Jun 2020 17:20:29 +0000
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,
For years i've used this script to scrub btrfs volumes on a schedule:

http://marc.merlins.org/linux/scripts/btrfs-scrub

I realized it hasn't been updated in years while both Linux and btrfs
have been through numerous updates and improvements. So I was
wondering if this script is still viable or do I have to look for something 
more 
up to date? This script works as intended as far as I can see, but maybe
that's not far enough?

-- 

Regards,
Christian Dysthe - 
