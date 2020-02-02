Return-Path: <SRS0=yHCO=3W=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7243C3524A
	for <linux-btrfs@archiver.kernel.org>; Sun,  2 Feb 2020 13:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A5892067C
	for <linux-btrfs@archiver.kernel.org>; Sun,  2 Feb 2020 13:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgBBN3c convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 2 Feb 2020 08:29:32 -0500
Received: from mail-a09.ithnet.com ([217.64.83.104]:54832 "EHLO
        mail-a09.ithnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgBBN3c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Feb 2020 08:29:32 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Feb 2020 08:29:31 EST
Received: (qmail 14460 invoked by uid 0); 2 Feb 2020 13:22:49 -0000
Received: from skraw.ml@ithnet.com by mail-a09 
 (Processed in 2.548362 secs); 02 Feb 2020 13:22:49 -0000
X-Virus-Status: No
X-ExecutableContent: No
Received: from dialin014-sr.ithnet.com (HELO ithnet.com) (217.64.64.14)
  by mail-a09.ithnet.com with ESMTPS (ECDHE-RSA-AES256-GCM-SHA384 encrypted); 2 Feb 2020 13:22:46 -0000
X-Sender-Authentication: SMTP AUTH verified <skraw.ml@ithnet.com>
Date:   Sun, 2 Feb 2020 14:22:46 +0100
From:   Stephan von Krawczynski <skraw.ml@ithnet.com>
To:     linux-btrfs@vger.kernel.org
Subject: Re: My first attempt to use btrfs failed miserably
Message-ID: <20200202142246.1f4c36e3@ithnet.com>
In-Reply-To: <cd628b1f-25b7-0f3b-0b31-2122acdfcd36@gmx.com>
References: <CACN+yT_AYiLc29M41U+WrQHtk4t==D-4AkH+wRROKJY=WstGAA@mail.gmail.com>
        <cd628b1f-25b7-0f3b-0b31-2122acdfcd36@gmx.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, 2 Feb 2020 20:56:20 +0800
Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

> On 2020/2/2 下午8:45, Skibbi wrote:
> > Hello,
> > So I decided to try btrfs on my new portable WD Password Drive
> > attached to Raspberry Pi 4. I created GPT partition, created luks2
> > volume and formatted it with btrfs. Then I created 3 subvolumes and
> > started copying data from other disks to one of the subvolumes. After
> > writing around 40GB of data my filesystem crashed. That was super fast
> > and totally discouraged me from next attempts to use btrfs :(
> > But I would like to help with development so before I reformat my
> > drive I can help you identifying potential issues with this filesystem
> > by providing some debugging info.
> > 
> > Here are some details:
> > 
> > root@rpi4b:~# uname -a
> > Linux rpi4b 4.19.93-v7l+ #1290 SMP Fri Jan 10 16:45:11 GMT 2020 armv7l
> > GNU/Linux  
> 
> Pretty old kernel, nor recently enough backports.

Exactly this kind of answer made me leave btrfs and never come back again.
4.19.93 is not very far away from the _latest_ longterm kernel released (which
is 4.19.101).
What you are saying here is that there is no stable working btrfs in longterm
kernels at all.
Hear, hear.
My advice to the OP: use ZFS. Great performance, absolutely stable, no crash
in years.

-- 
Regards,
Stephan
