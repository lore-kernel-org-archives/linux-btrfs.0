Return-Path: <SRS0=GazA=CB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796DEC433DF
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Aug 2020 18:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F283820706
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Aug 2020 18:49:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="N4maPwg9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbgHWSt5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 23 Aug 2020 14:49:57 -0400
Received: from mail-40135.protonmail.ch ([185.70.40.135]:13564 "EHLO
        mail-40135.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgHWSt4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Aug 2020 14:49:56 -0400
Date:   Sun, 23 Aug 2020 18:49:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1598208594;
        bh=g9S8koKAZ9E9mmOfOSezoiT8yNytBSX1DCedq83epzE=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=N4maPwg9b7HVJsu4YbqoO/lK/BRtK9p54rz87M9nRjUaonLWmxIGiniPWXYwawMS4
         Ep9t45LyyvswK4W9C1/fwp5a6rGtUreq0jjRTI5p0Y1VJedxRPvUy5JmHa/TcVZFlm
         4/azJwwUO82WwCchU7NWnwIq9kYtvKFLEyE+Xkao=
To:     Andrei Borzenkov <arvidjaar@gmail.com>
From:   Andrii Zymohliad <azymohliad@protonmail.com>
Cc:     Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Reply-To: Andrii Zymohliad <azymohliad@protonmail.com>
Subject: Re: [Help] Can't login to my systemd-homed user account due to fallocate failure
Message-ID: <3xjSaoCYmgmmVfKzqhR5ooUYdWPlI4R8fjh_4E0UuVCYRP9lPzoPszrseqXvxd6pAZY4xdmIBRuX_KLcn5U19G3VwVlK59FydVvDGulRvKY=@protonmail.com>
In-Reply-To: <db0c267c-5b8f-067b-673c-8f59002ee48e@gmail.com>
References: <bdJVxLiFr_PyQSXRUbZJfFW_jAjsGgoMetqPHJMbg-hdy54Xt_ZHhRetmnJ6cJ99eBlcX76wy-AvWwV715c3YndkxneSlod11P1hlaADx0s=@protonmail.com> <20200823153746.GB1093@savella.carfax.org.uk> <251eb1e3-0fcd-eb22-72b9-8ab2f2a5e962@gmail.com> <uE-fvxC5rW1snQPXRetWASSP8a8cJVSTiDa1WNLmtVANT-M_cd6NUZxUlUtLBID2-EBEEJjP0yK7-Knt9-vjWob1dU6H9FE2Dhg0Y1XFOx4=@protonmail.com> <db0c267c-5b8f-067b-673c-8f59002ee48e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> Output of "btrfs fi us /" before and after fallocate would probably give
> more information. Also "btrfs sub li /" and "btrfs qgroup show -re /"
> would be interesting. And "btrfs fi du /home/azymohliad.home".

Collected the outputs of all those commands here (in order of execution): h=
ttps://gitlab.com/-/snippets/2007189

