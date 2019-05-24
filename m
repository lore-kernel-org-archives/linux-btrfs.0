Return-Path: <SRS0=C3Vb=TY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	T_DKIMWL_WL_HIGH,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39299C072B5
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 May 2019 15:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F15CB2175B
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 May 2019 15:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558710655;
	bh=zopj89AbmNwtWW42y3dZXTGDLXuFrFoh7zQwouKI4t0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=1/OhqQ/+K//r5hVhjGW6VuREiDo+dLbDzmF+ijHdNlhq1eOHIEqntVLmovX6XAYJP
	 8Hdc7kiW9rT+3K455m0dOtI38ZCByRr+xbH41wsdBdEOA+O2MXSPuYqegxHXH7K8jq
	 RoRmvXj3ZIhiBRAyjZ/Ey2qa+vJQmarzXugTHaHU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389290AbfEXPKy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 24 May 2019 11:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389079AbfEXPKx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 May 2019 11:10:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E45E920862;
        Fri, 24 May 2019 15:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558710653;
        bh=zopj89AbmNwtWW42y3dZXTGDLXuFrFoh7zQwouKI4t0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=doYw09DbGdSeHmei8lLRQCT7GF87KapImQYCUrEXxC0Q3j9XS7KWfzTUDhxGggVYO
         SdN4D49/BZ81GVttSStLCSr4cpmAbGOf/DlsBdTp90v781nFKCsNSmfoXw9s/0qPhj
         i7B+AITAFTNiXWUolOyC8nFGnlnXG+AOsz4Tx0S4=
Date:   Fri, 24 May 2019 17:10:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andrea Gelmini <andrea.gelmini@linux.it>
Cc:     Mike Snitzer <snitzer@redhat.com>,
        Michael =?iso-8859-1?B?TGHf?= <bevan@bi-co.net>,
        dm-devel@redhat.com, Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: fstrim discarding too many or wrong blocks on Linux 5.1, leading
 to data loss
Message-ID: <20190524151051.GA28270@kroah.com>
References: <8C31D41C-9608-4A65-B543-8ABCC0B907A0@bi-co.net>
 <CAJCQCtTZWXUgUDh8vn0BFeEbAdKToDSVYYw4Q0bt0rECQr9nxQ@mail.gmail.com>
 <AD966642-1043-468D-BABF-8FC9AF514D36@bi-co.net>
 <158a3491-e4d2-d905-7f58-11a15bddcd70@gmx.com>
 <C1CD4646-E75D-4AAF-9CD6-B3AC32495FD3@bi-co.net>
 <3142764D-5944-4004-BC57-C89C89AC9ED9@bi-co.net>
 <F170BB63-D9D7-4D08-9097-3C18815BE869@bi-co.net>
 <20190521190023.GA68070@glet>
 <20190521201226.GA23332@lobo>
 <CAK-xaQZ9PCLgzFw0-YJ=Yvou=t0k=Vv-9JY4n3=VD2s=NaYL4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK-xaQZ9PCLgzFw0-YJ=Yvou=t0k=Vv-9JY4n3=VD2s=NaYL4w@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, May 24, 2019 at 05:00:51PM +0200, Andrea Gelmini wrote:
> Hi Mike,
>    I'm doing setup to replicate and test the condition. I see your
> patch is already in the 5.2 dev kernel.
>    I'm going to try with latest git, and see what happens. Anyway,
> don't you this it would be good
>    to have this patch ( 51b86f9a8d1c4bb4e3862ee4b4c5f46072f7520d )
> anyway in the 5.1 stable branch?

It's already in the 5.1 stable queue and will be in the next 5.1 release
in a day or so.

thanks,

greg k-h
