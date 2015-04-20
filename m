Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36103 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbbDTMNq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 08:13:46 -0400
Received: by iebrs15 with SMTP id rs15so114351591ieb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 05:13:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150419170503.4d888c04@natsu>
References: <217a387d55b5828a82fadad98dd88a959e7a13ed.1429008167.git.lauri.vosandi@gmail.com>
	<1429443988-16001-1-git-send-email-lauri.vosandi@gmail.com>
	<20150419170503.4d888c04@natsu>
Date: Mon, 20 Apr 2015 15:13:45 +0300
Message-ID: <CAJ1pDqTjqmTzF2Qonkys61SY7xfJ_fHt6rUDZF=R3y5FWptjZA@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: optionally enforce chroot for btrfs receive
From: lauri <lauri.vosandi@gmail.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the last one added missing goto. I'll try to make clear differences
next time :)
