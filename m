Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78466EB64DA
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Jul 2023 14:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbjGTOPM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 10:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjGTOPK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2023 10:15:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB1B211D
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jul 2023 07:15:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C372E61AF8
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jul 2023 14:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BEFC433C7
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jul 2023 14:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689862499;
        bh=iI01nnwxUt5VpACuwUBSlPeJqFmcF22C+LGuI23hpZg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=G+hVytJb2EhsMmw/J1VvBy2hbdjhQEcsLr9r3RTzli3fDo7VTZJAfJeov2iZjkqT5
         udSjfsGY+I1L/xmuBpsqb02Qz3aJaMgbP+EwCU5OSOKRE3hRcAPmOlejfFA/e5bRPw
         cGuVIbS7p8qA61QkJZlqU2KRELHnqdv6XOxN0dGLcKzBVAzJscJ+2R2yBUASSPTogT
         W/91oJGmDggxECEa46Fy3697QmT/Tw/mvwgFXQZafa69OK/vtVvPof8Bvv+A68HMDN
         wHbMQgtTUbwqaKgRfp6LE3pK64DDJu5NxHTQDAhfxcSY2HobDQ+cchkQjSNVPUaB2C
         ZidoZdg6BMPVw==
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3a46da5cd6dso585187b6e.0
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jul 2023 07:14:59 -0700 (PDT)
X-Gm-Message-State: ABy/qLZ3ptV7Pio3wEapqzivKc3opP751BFRBnNbnvYVlKsY7kbiJtTV
        JEdf5CTF9+YJYmgALo198AjPu2IEj5D0Y/Ucn2c=
X-Google-Smtp-Source: APBJJlFQk6ttgOvddthe2SRAOI1C8fLdww6aWtfiDgcri4brZFpmhLPIKvxutDqf6yt4NuZL9xIxqa344Mpg2YmTl9Y=
X-Received: by 2002:a05:6808:8c7:b0:3a3:fe9b:b679 with SMTP id
 k7-20020a05680808c700b003a3fe9bb679mr1722378oij.48.1689862498326; Thu, 20 Jul
 2023 07:14:58 -0700 (PDT)
MIME-Version: 1.0
References: <ZLk8ef3pGp1ZjByN@infradead.org>
In-Reply-To: <ZLk8ef3pGp1ZjByN@infradead.org>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Thu, 20 Jul 2023 15:14:22 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7pSRHPef=RvM60-xF13aVsi7Bhc7WWdQWpH8EtsAMwxQ@mail.gmail.com>
Message-ID: <CAL3q7H7pSRHPef=RvM60-xF13aVsi7Bhc7WWdQWpH8EtsAMwxQ@mail.gmail.com>
Subject: Re: flapping scrub tests?
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jul 20, 2023 at 3:07=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> Hi all,
>
> in my tests it seems almost random if the btrfs/06? scrub tests
> fail or pass.  Is anyone else seing this unstable behavior?

Yep. I sporadically get scrub reporting uncorrectable data csum errors
in those tests that exercise scrub.
This happens both before and after the recent scrub rewrite.

I've never spent the time debugging it however. It's pretty rare to
trigger in my test VMs.
