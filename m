Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46362 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751723AbeAPMP5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Jan 2018 07:15:57 -0500
Date: Tue, 16 Jan 2018 13:15:54 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Subject: Re: invalid files names, btrfs check can't repair it
Message-ID: <20180116121553.eldnuftys54zwcuy@breakpoint.cc>
References: <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
 <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
 <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
 <20180115090049.6tcnoadsam7adsea@breakpoint.cc>
 <fbd3016e-51c9-ae21-4fce-8b878a14f9ea@gmx.com>
 <b926ecdb-94da-1067-ff74-7d5392a7fe46@gmx.com>
 <20180116101058.wtcdjnqldcb5q3a7@breakpoint.cc>
 <4b929845-beae-9e13-2df9-ddc3232ad39a@gmx.com>
 <20180116104949.7qtf67mrdvyxrvs4@breakpoint.cc>
 <acf4b795-0fb9-c9c8-63a9-5d888afa9419@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <acf4b795-0fb9-c9c8-63a9-5d888afa9419@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-16 19:20:56 [+0800], Qu Wenruo wrote:
> This is a very minor problem.
> 
> btrfs check --repair should handle it without problem.

awesome, thank you! After the --repair completed, the following didn't
report the error anymore. And now I was able to remove the two files.
Thank you.

> Thanks,
> Qu

Sebastian
