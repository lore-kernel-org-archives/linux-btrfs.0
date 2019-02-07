Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE4A8C282C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 15:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79C2F21872
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 15:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549554224;
	bh=l6SJ69N/zk4z+AyZgO5Bl0leny4tx9zDAbhG4pVHRaQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ZguWYyicI6KJibW+bsN4FO4lpxFlwJeRj6ESja8ZbyE82rxYJSYpdAH1HLS+8isQO
	 VYNQP7az+CxGrMPS3bbTPoeF7agraNof5iHqYyKpfPD1HSOHPrOsPT/LK00RxXIL/s
	 EYRJ0HDp4u1Qu2cJHaEnQ9e+cPznv59T6l7ed1EE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfBGPnn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 10:43:43 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42570 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfBGPnn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2019 10:43:43 -0500
Received: by mail-qk1-f195.google.com with SMTP id y140so163868qkb.9
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Feb 2019 07:43:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=K24Gu6BSQQtNsK68vst5rl6c7POYxYgX/fuRTBHIzsU=;
        b=ju3pSWz2mIRqrIIGjkaaYUSHNS5b3EYKC7g6Wm7qBbK6uFieim4VmiST+5F3E0kBNm
         Pnb29Mnzj4UBcgzaFd+I5LlDYpl0WxYiw+DXzDs+6P6RK87lyRFK/mDQHvJsQ9CL8NLK
         uZRpdt2zNsyhWifZ+HFWl3CF4StGSJI73RIoGe1a5L2J21YB1WCIe9KGIgKwmIn9l8ke
         mSBAYp3Pvvm1ZYCPdWT4zxl6r3fr1eJ66VxCP41DpOe5QadM9Sl7Ei/YyNxMhEMKPYGl
         iuG3Gqo1bNAWlNZdCLplBQHHzE7ZnWnItcOP4jr79jN/ag7zXRDDptcmZU5QFBPaVmQN
         T8Kw==
X-Gm-Message-State: AHQUAubPhSYu/HNoCIqrcDxP1/BC5ONCV82tqA+IvWoxDAjSuZP1ddT3
        VBBKOSxNdNxe+MonDvllIQc=
X-Google-Smtp-Source: AHgI3Ia4LjJKqTsrxHj7kCJ2ef6Wdj3rDLhSk6JAZ88j19v1DkOdJp5ba8uwj/ZVowgrVO4r/GJ+wQ==
X-Received: by 2002:a37:657:: with SMTP id 84mr11474763qkg.86.1549554221818;
        Thu, 07 Feb 2019 07:43:41 -0800 (PST)
Received: from dennisz-mbp.dhcp.thefacebook.com ([2620:10d:c091:200::4:bab5])
        by smtp.gmail.com with ESMTPSA id p49sm124355qte.74.2019.02.07.07.43.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Feb 2019 07:43:40 -0800 (PST)
Date:   Thu, 7 Feb 2019 10:43:38 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, dennis@kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [bug report] btrfs: change set_level() to bound the level passed
 in
Message-ID: <20190207154338.GA17102@dennisz-mbp.dhcp.thefacebook.com>
References: <20190207103647.GA15902@kadam>
 <20190207154045.GI2900@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207154045.GI2900@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 07, 2019 at 04:40:45PM +0100, David Sterba wrote:
> On Thu, Feb 07, 2019 at 01:36:47PM +0300, Dan Carpenter wrote:
> > Hello Dennis Zhou,
> > 
> > The patch a67dc67a2cb8: "btrfs: change set_level() to bound the level
> > passed in" from Jan 28, 2019, leads to the following static checker
> > warning:
> > 
> > 	fs/btrfs/compression.c:1576 btrfs_compress_str2level()
> > 	error: uninitialized symbol 'level'.
> > 
> > fs/btrfs/compression.c
> >     1566 unsigned int btrfs_compress_str2level(unsigned int type, const char *str)
> >     1567 {
> >     1568 	unsigned int level;
> >     1569 	int ret;
> >     1570 
> >     1571 	if (!type)
> >     1572 		return 0;
> >     1573 
> >     1574 	if (str[0] == ':') {
> >     1575 		ret = kstrtouint(str + 1, 10, &level);
> > --> 1576 		if (ret)
> >     1577 			level = 0;
> > 
> > I feel like if the user gives bad input then we should just return an
> > error code instead of picking a level.
> 
> We've debated a bit and a warning with fallback to default is the
> preferred option.
> > 
> >     1578 	}
> > 
> > level is not initialized if the first character is not ':'.
> 
> Right that's a bug, can be fixed by initializing level to 0, the
> set_level() implementations will fall back to default then.
> 
> Thanks for the report.
> 

Yeah that was a blunder on my part. I fixed it in v2 of 0009 in that
series:
https://lore.kernel.org/lkml/20190206164854.GB73401@dennisz-mbp.dhcp.thefacebook.com/

> > 
> >     1579 
> >     1580 	level = btrfs_compress_op[type]->set_level(level);
> >     1581 
> >     1582 	return level;
> >     1583 }

Thanks,
Dennis
