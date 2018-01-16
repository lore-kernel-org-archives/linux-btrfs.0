Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45860 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751283AbeAPKLC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Jan 2018 05:11:02 -0500
Date: Tue, 16 Jan 2018 11:10:59 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Subject: Re: invalid files names, btrfs check can't repair it
Message-ID: <20180116101058.wtcdjnqldcb5q3a7@breakpoint.cc>
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
 <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
 <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
 <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
 <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
 <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
 <20180115090049.6tcnoadsam7adsea@breakpoint.cc>
 <fbd3016e-51c9-ae21-4fce-8b878a14f9ea@gmx.com>
 <b926ecdb-94da-1067-ff74-7d5392a7fe46@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <b926ecdb-94da-1067-ff74-7d5392a7fe46@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-16 13:19:50 [+0800], Qu Wenruo wrote:
> Usage:
> ./btrfs-corrupt-block -X <device>
# ./btrfs-corrupt-block -X /dev/sdb4
Fix is done successfully

may I mount it now or should I run btrfs check or something first?

> Thanks,
> Qu

Sebastian
