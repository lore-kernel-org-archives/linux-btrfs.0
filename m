Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA0AC43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 14:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BFD0205C9
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 14:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404772AbfAPO6M (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 09:58:12 -0500
Received: from mout.gmx.net ([212.227.15.19]:41469 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729392AbfAPO6M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 09:58:12 -0500
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MTjqS-1gsY6M3Jk8-00QRtw for
 <linux-btrfs@vger.kernel.org>; Wed, 16 Jan 2019 15:58:10 +0100
From:   Stefan K <shadow_7@gmx.net>
To:     Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: question about creating a raid10
Date:   Wed, 16 Jan 2019 15:58:10 +0100
Message-ID: <1980543.jviTh1pdNs@t460-skr>
User-Agent: KMail/5.2.3 (Linux/4.9.0-8-amd64; KDE/5.28.0; x86_64; ; )
In-Reply-To: <20190116144208.GI5134@carfax.org.uk>
References: <3318002.5e9V1lv8s4@t460-skr> <20190116144208.GI5134@carfax.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:ke6SgCEC60fqByfC4K6pWQjePIw1opLZYIsozwkUlmMHOb4Xy2s
 Ey4eTmOq8caJ9kXeSyPL+W47HYKYqcIzdZjxpcJPsBmk0SSMNQp+mVNcZkIWjXEAqgPVRnF
 wJm6LrCInRPozslp0cb9PvH1JKHGVOlmjIvA+es/wqftrqNED4+f4nO0FwIaWbvdA4vDOrb
 8iOr+McvRVKF/kfLxqAmQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:xGE5mAKv+Ww=:0/vv9i+Ej2+CT+3OG/iI5v
 DAlW/88X5DQPqtL/OAMTno6apps5bg9cpw4qJ4N56quu6xUv2rG4qpfwvpTV16SFY+sJJbAv8
 TyZS+b2fc7sfPd1vugMNy8QZthJdinSuJMz7/NAr/4jR8wrMHFZVKbVQO1NqJeMMTmFolALqf
 KpEGllKz2bgi28bje+rqQaxbsPT0znu/QEcxfSpxFg+MtPFnD34zXkLeYTwvJEdRaFHCmwAMB
 TQ1WHQkNkn44qYyD8eDZJcWA4PQsGF4PKAAn86WSxVUPdPUNpVz2lHVGjuK4x2r6IjGT7fTZV
 fQ5cdfhzyfbAoLgwLAdUD2aIdAXh4A41hoZCX3z+Ks5JWAtoUziVWvvu/4690gcJd0xPjKA6n
 xTX2aE01n+3Vj5rFuzSDqwMJ2hCoGTd7vsGBRdeiWUrOTwtdIMob44w66RCgfcKPN6kIMb6Jj
 Sgw+DkQVwZ0qr3cNpOYrm01TFQC56rn0vqK+MqxfWrSRS4EpnwVgP7p+Y/H9pRAhkrmJzk0w1
 IPhB1qlmehaCQ+HvMRub7SlcnJ/hCMFa+pP8ze7qPw3XdIyKuYF5J72pa1p8RlCYUN4rx1w75
 SeZu5FferyOy2o75d3eBpjqhcH1no3Of3DV39KF6AAR9uljANQpOY6pl1QjasE0Esa1LMbwbT
 2jjUW5kNqXXordAxfzMRd8zlkLWcmwvhL+1IdFazI/KvdKhtfcDTI1fmBydwDimLtKied9OF7
 cLQdTsjr4BQEaH8+/0Mtjxb9q943I32TNIzC3TMNQa4AJl9cELfPC5y7/YkwUZ9DyW5LN/1A+
 b9vs5auFcSLBkdXK+ztIF1mOs7ntlEWCMcpIederKIL3Jhl4KqRGAZx1XT4JTkScamQzww2uv
 7XzUzXTlkGiL+K+5RkBG3XdMZVaiQgTeuoBG6b/rObMOZIkHZHM+bdOYrKbRuzKgXGEAF7P47
 +90SxE3dzxQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

 :(
that means when one jbod fail its there is no guarantee that it works fine? like in zfs? well that sucks
Didn't anyone think to program it that way?

On Wednesday, January 16, 2019 2:42:08 PM CET Hugo Mills wrote:
> On Wed, Jan 16, 2019 at 03:36:25PM +0100, Stefan K wrote:
> > Hello,
> > 
> > if I create a raid10 it looks like that:
> > mkfs.btrfs -m raid10 -d raid10 /dev/sdb /dev/sdc /dev/sdd /dev/sde
> > 
> > but if I've different jbods and I want that every mirror of a raid10 is on a different jbod how can I archive that? in zfs it looks like that:
> [snip]
> > how can I be sure that is btrfs the same?
> 
>    I'm afraid you can't. It would take modifications of the chunk
> allocator to achieve this (and you'd also need to store the metadata
> somewhere as to which devices were in which failure domain).
> 
>    Hugo.
> 
> 

