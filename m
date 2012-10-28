Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:42296 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab2J1MXD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 08:23:03 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so3260251iag.19
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Oct 2012 05:23:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121027220940.GV2381@yeono.kjorling.se>
References: <20121027215645.GU2381@yeono.kjorling.se>
	<20121027220215.GA5042@carfax.org.uk>
	<20121027220940.GV2381@yeono.kjorling.se>
Date: Mon, 29 Oct 2012 01:23:02 +1300
Message-ID: <CAGa+R32R83cAWLQO4Xgwcvp22r1oPkWhmEOMiWB1HUTSb=r18g@mail.gmail.com>
Subject: Re: How does btrfs behave on checksum mismatch?
From: Ronnie Collinson <notthinking@gmail.com>
To: =?ISO-8859-1?Q?Michael_Kj=F6rling?= <michael@kjorling.se>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In a raid1 situation, it will also rewrite the effected data, on the
drive that failed the checksum
