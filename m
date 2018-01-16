Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45832 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750868AbeAPKCm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Jan 2018 05:02:42 -0500
Date: Tue, 16 Jan 2018 11:02:21 +0100
In-Reply-To: <fbd3016e-51c9-ae21-4fce-8b878a14f9ea@gmx.com>
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc> <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com> <20180113204114.g4jup552d5g5o5pa@breakpoint.cc> <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com> <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc> <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com> <20180115090049.6tcnoadsam7adsea@breakpoint.cc> <fbd3016e-51c9-ae21-4fce-8b878a14f9ea@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: invalid files names, btrfs check can't repair it
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Message-ID: <885CF043-FD36-4FDD-AE2D-66121D5D9637@breakpoint.cc>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16 January 2018 05:51:23 CET, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>Since there is no other hit, I assume it's root subvolume (5), but I
>still need the extra confirm since the fix will be hard-coded.

Yes, 5 is correct.

>
>Thanks,
>Qu



Sebastian
