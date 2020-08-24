Return-Path: <SRS0=zwl1=CC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF17C433E1
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Aug 2020 09:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2C61206BE
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Aug 2020 09:54:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="K624uRrz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgHXIhv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 04:37:51 -0400
Received: from mail-40137.protonmail.ch ([185.70.40.137]:44181 "EHLO
        mail-40137.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728433AbgHXIht (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Aug 2020 04:37:49 -0400
Date:   Mon, 24 Aug 2020 08:28:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1598257741;
        bh=HyVMUtvwPocCa0XLQJYvwtHcCYbOY8itaiNQtC22T+E=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=K624uRrzfR/rLtbIlOhNB9JBFBHSsXSO2VDE6g39sTzrK76sUX+6FvgEEpnTJPWHa
         RUv6r92GljYGLEzwcm8DuDT5OsSlVX3z/Ypz5n53sEiTArLgxEC9gwaqrdid+3PF3d
         EKuXz35sDC9ybDM2vLKkOysn23bd6F7Y3ADoQUsE=
To:     Chris Murphy <lists@colorremedies.com>
From:   Andrii Zymohliad <azymohliad@protonmail.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Andrei Borzenkov <arvidjaar@gmail.com>
Reply-To: Andrii Zymohliad <azymohliad@protonmail.com>
Subject: Re: [Help] Can't login to my systemd-homed user account due to fallocate failure
Message-ID: <E212ihR5U8HVCyaalepkxQUX3wOj6IXd1yUFHj-PFFtyU7ma-A49vmB8QwfQG5gUVo2nCMbVpPo7C2ccooRO0ExVrIbdLP9sBpnjMOcefHo=@protonmail.com>
In-Reply-To: <BfU9s11rmWxGNQdKqifkB1JKOJcgqAN49OZdV4LAOgo1W2AguRebwCPVosOiMVjMTzuSmsk_Efbkl02s31niRqtCS67WJ9S7_s4jiK9afeA=@protonmail.com>
References: <bdJVxLiFr_PyQSXRUbZJfFW_jAjsGgoMetqPHJMbg-hdy54Xt_ZHhRetmnJ6cJ99eBlcX76wy-AvWwV715c3YndkxneSlod11P1hlaADx0s=@protonmail.com> <CAJCQCtTC2yi4HRqg6fkMrxw33TVSBh_yAKtnX-Z1-nXSVjBW7w@mail.gmail.com> <Yy8-04dbNru1LWPcNZ9UxsagH1b0KNsGn7tDEnxVOqS812IqGiwl37dj4rxAh05gEP8QoNJ5F_Ea6CZ8iZgvnupuq5Qzc38gl69MceWMc9s=@protonmail.com> <CAJCQCtSqe_oqRZWYP7iLJcGQnzZkC4vmoYVTm_9RPb8eb0-E6Q@mail.gmail.com> <BfU9s11rmWxGNQdKqifkB1JKOJcgqAN49OZdV4LAOgo1W2AguRebwCPVosOiMVjMTzuSmsk_Efbkl02s31niRqtCS67WJ9S7_s4jiK9afeA=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> I think we've got a pretty good idea what's going on. The current work
> around in your case will be to use the --luks-discard=3Dtrue option when
> activating.

Hm.. It doesn't help.

    # homectl activate --luks-discard=3Dtrue azymohliad

or

    # homectl authenticate --luks-discard=3Dtrue azymohliad

prints exactly the same error as without --luks-discard option:

    Operation on home azymohliad failed: Not enough disk space for home azy=
mohliad

and the allocated space on / goes to 476G again (so it seems it still tries=
 to do fallocate).


