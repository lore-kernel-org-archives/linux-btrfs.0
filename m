Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx01.imt-systems.com ([212.224.83.170]:35141 "EHLO
	mx01.imt-systems.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaIJLYT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 07:24:19 -0400
Received: from ucsinet10.imt-systems.com (ucsinet10.imt-systems.com [212.224.83.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx01.imt-systems.com (Postfix) with ESMTPS id 3htLTm6wjkzMwPhH
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Sep 2014 13:24:12 +0200 (CEST)
Received: from mail-ie0-f170.google.com (mail-ie0-f170.google.com [209.85.223.170])
	(authenticated bits=0)
	by ucsinet10.imt-systems.com (8.14.7/8.14.7) with ESMTP id s8ABOBo5047801
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Sep 2014 13:24:12 +0200
Received: by mail-ie0-f170.google.com with SMTP id tp5so7591450ieb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Sep 2014 04:24:11 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 10 Sep 2014 13:24:10 +0200
Message-ID: <CAKSJeFKUUKwdbtCCrpjwaFa7g4yBURuzgrqe2dvQeHKR=d_Prg@mail.gmail.com>
Subject: Re: btrfs 3.16.2 system crash
From: Morten Stevens <mstevens@fedoraproject.org>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-09-10 2:42 GMT+02:00 Chris Mason <clm@fb.com>:

> I ran the dd's overnight and some other tests without trouble.  But that
> doesn't mean its not a btrfs bug, I'll try again tonight.

Okay. It's not easy to reproduce. Here is the call trace:

http://fpaste.org/132400/03480701/

I hope this helps?

Best regards,

Morten
