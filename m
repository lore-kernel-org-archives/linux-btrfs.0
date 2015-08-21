Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from portkey.s.itsis.si ([78.47.12.76]:43723 "EHLO
	portkey.s.itsis.si" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbbHUP57 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 11:57:59 -0400
Received: by iodb91 with SMTP id b91so85748409iod.1
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2015 08:49:01 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 21 Aug 2015 17:49:01 +0200
Message-ID: <CAEp_DRAR5yjYNm-26jfVmajGqoSt3C9P1L5kS+C9s6g=zZhynQ@mail.gmail.com>
Subject: Chunk fullness distribution
From: Bostjan Skufca <bostjan@a2o.si>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

is there a way to get information about how much space is occupied in
each chunk?

In the end, a simple ascii chart of usage distribution should be
preferable, but I can work towards that if there is a way to get
information about individual chunks.

I know that "btrfs fi show" displays aggregate info, but having
distribution chart enables one to predict how much time "btrfs
rebalance" operation will take for various X values in "dusage=X"
filter.

Tnx for info,
b.
