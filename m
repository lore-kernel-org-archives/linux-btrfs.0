Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45628 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbaIVPF5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 11:05:57 -0400
Received: by mail-wi0-f173.google.com with SMTP id r20so3127410wiv.0
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 08:05:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1411090230.28980.6.camel@localhost.localdomain>
References: <CAM_a8JxJBFQykuF13UF1Fi9jbM-=yromXbQ5PrWM5JPR7u6pXA@mail.gmail.com>
	<CAM_a8Jy3kwxtDvJ36T0hVrGRBbOK34MOEqZY0GhUUyAUHJMnCw@mail.gmail.com>
	<1411011561.22018.3.camel@localhost.localdomain>
	<5786662.mcQW9aUYte@fb07-iapwap2>
	<CAM_a8JzKth0_zG6cGoQeWHB3Dpro42wfEtS5QJXtFZT1xNoZYQ@mail.gmail.com>
	<1411090230.28980.6.camel@localhost.localdomain>
Date: Mon, 22 Sep 2014 15:05:54 +0000
Message-ID: <CAM_a8JwswiD=kkfAXqkPppGdK8b673kY80kyw=-Uc-M1M_mzPw@mail.gmail.com>
Subject: Re: fs corruption report
From: Zooko Wilcox-OHearn <zooko@leastauthority.com>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: Marc Dietrich <marvin24@gmx.de>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I guess I'll wait until there's a git repo (maybe one of these
branches https://github.com/kdave/btrfs-progs/branches/active ?) with
the fix integrated and then I'll test "btrfs restore" using that.
Thanks!

Regards,

Zooko
