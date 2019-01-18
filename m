Return-Path: <SRS0=o3FP=P2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A84C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 13:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B06FC2087E
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 13:40:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=aarghimedes.fi header.i=@aarghimedes.fi header.b="W8taFk4l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfARNke (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Jan 2019 08:40:34 -0500
Received: from aarghimedes.fi ([62.75.165.48]:53166 "EHLO aarghimedes.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727017AbfARNke (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Jan 2019 08:40:34 -0500
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2019 08:40:33 EST
Received: from [192.168.2.148] (77-246-193-133.cust.suomicom.net [77.246.193.133])
        by aarghimedes.fi (Postfix) with ESMTPSA id C97E764014A4
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jan 2019 15:30:50 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aarghimedes.fi;
        s=mail; t=1547818250;
        bh=ydhR6QJidEhiT3ru83HwhPne1zWrDTmo0r3+lZj+vlM=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=W8taFk4l/XYkoKAxIb3hndmVy53hiKurzxos075/b6Rt8LF2yZLEYgOpOvuDsgfd1
         CrtPU8eWJnNQNIGNpRcmrjeqZlhlPGA5aC0oZFQTi+kBk8LLpCi/TWuDRYZP56IdTO
         IybWwxSpxz0wlC3ENSBPmLHZG00OcKUDngAgweoc=
Subject: Re: question about creating a raid10
To:     linux-btrfs@vger.kernel.org
References: <3318002.5e9V1lv8s4@t460-skr> <1980543.jviTh1pdNs@t460-skr>
 <CAJCQCtTErRwS5Omb4Asob3sYx8Svt4yV8V5so7fcs+2BX8t3Gg@mail.gmail.com>
 <2875582.WnnmDmFHSm@t460-skr>
From:   Jukka Larja <roskakori@aarghimedes.fi>
Message-ID: <1a6b9ebf-9cc8-7e90-d8c0-b9e5e143403a@aarghimedes.fi>
Date:   Fri, 18 Jan 2019 15:30:50 +0200
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; fi; rv:1.8.1.23)
 Gecko/20090812 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
In-Reply-To: <2875582.WnnmDmFHSm@t460-skr>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Stefan K kirjoitti 18.1.2019 klo 9.02:

> WTF?! really, so with btrfs raid10 I can't lose more than one drive? that sucks, that an advantage of raid 10!
> and the crazy thing is, thats not documented, not in the manpage nor btrfs wiki and and thats is very important.
> thats unbelievable ..

You should probably check at least 
https://btrfs.wiki.kernel.org/index.php/SysadminGuide before planning any 
further Btrfs usage.

-- 
      ...Elämälle vierasta toimintaa...
     Jukka Larja, Roskakori@aarghimedes.fi

<saylan> I just set up port forwards to defense.gov
<saylan> anyone scanning me now will be scanning/attacking the DoD :D
<renderbod> O.o
<bolt> that's... not exactly how port forwarding works
<saylan> ?
- Quote Database, http://www.bash.org/?954232 -
