Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zougloub.eu ([69.70.16.42]:41008 "EHLO zougloub.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751049AbdKTHCz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 02:02:55 -0500
Received: from Vantage.cJ (exmakhina.com [69.70.16.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by zougloub.eu (Postfix) with ESMTPSA id 73AA2F0ABDF
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 01:57:40 -0500 (EST)
Date: Mon, 20 Nov 2017 02:04:06 -0500
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: linux-btrfs@vger.kernel.org
Subject: Re: WARNING: CPU: 3 PID: 20953 at
 /usr/src/linux/fs/btrfs/raid56.c:848 __free_raid_bio+0x8e/0xa0
Message-ID: <20171120020406.73d996a2@Vantage.cJ>
In-Reply-To: <20171120020007.01897b13@Vantage.cJ>
References: <20171120020007.01897b13@Vantage.cJ>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 20 Nov 2017 02:00:07 -0500
Jérôme Carretero <cJ-ko@zougloub.eu> wrote:

> ------------[ cut here ]------------

It should be noted that the filesystem doesn't want to be unmounted now.


Regards,

-- 
Jérôme
