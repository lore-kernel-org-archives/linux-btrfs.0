Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D39AC43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 18:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5589520675
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 18:15:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="CQpC7E8p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbfAPSPQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 13:15:16 -0500
Received: from mail-lf1-f49.google.com ([209.85.167.49]:33488 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728405AbfAPSPQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 13:15:16 -0500
Received: by mail-lf1-f49.google.com with SMTP id i26so5695799lfc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Jan 2019 10:15:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m75MWwZl9Rt5BlOqpqqK8V1kjv8IeIKXfWGzNL5EkTI=;
        b=CQpC7E8pDT/PArhs8EaUbA55VB5whixk7ftejgsNzbz4CN42ExhYZrfoBrmQ+30r/R
         sK11HaHKWHIiiUcMbOcjE//Wc4nmDEECRDWU3xJWMlClQC4ISmUPOq8VrHWWcH9wgurz
         VvYIoLEOz4fs9PCa1fHajvHh7bqKM/bCe2TvBDXkrs471qOkIYHLqkSCz38KJ/PBjGNI
         cmknVzuha0Oxy31bHcaAJ+QvTyevCToZkHdVU37O+LNaRF44gyNcfHi4rCYZnjTRXe7u
         Bxv2+UYVqwXlGkYWRlrikUb0Alupa/0/x6M99o/1KN2P0hgdVR4Xulfn+QH3XCC+Uv9h
         IYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m75MWwZl9Rt5BlOqpqqK8V1kjv8IeIKXfWGzNL5EkTI=;
        b=DEC1R4cFtjbUa0Vi9JTaqL49RwXt0gGyWHpiFRaQE+TxwDoVn1SgSeWgJRw0+Mphy2
         GDRb8G/6h3e24iOjji5aJdu2LjZRp7hpU63Gd/pH2AoiR9NOB2eCUsfpLne9ja/BqyVG
         /79l9NgadSu4ljJ98/IlNxkJwGGTDAVS8t3Xk+2KsbJPqsD2ICQmVJwXEV0DMXl/71KW
         WOixNwQjIqC+1jCzJSk0iVmSLaTO5+lYiNEf9mtT52V/PE2xZDBdbqRrx6UfsLlUp2d8
         TMI8lm5jbDmx21CUEzqn7+lOToTDH1EQi41NIma7Bj7lSDjyPoTOjqj26cEZCGkRT9Gf
         YBaw==
X-Gm-Message-State: AJcUukcIX7iZ7BhNa+KNajBJFjPUdekfEfFTynzqB2rPVB6iLqdFC0/x
        IVcJWWl8anaM2qCE7jpx7IBo84khzlytiuMGsqklRqLh
X-Google-Smtp-Source: ALg8bN4zshpMzd1vgoV7qwYY4LwUYji2AgltWGwYwAhsi8shgsAZp73i8XNI+h8attfVuJTxn3JBb63GMKaO0o9xhTc=
X-Received: by 2002:a19:e01e:: with SMTP id x30mr7716353lfg.89.1547662513649;
 Wed, 16 Jan 2019 10:15:13 -0800 (PST)
MIME-Version: 1.0
References: <3318002.5e9V1lv8s4@t460-skr> <20190116144208.GI5134@carfax.org.uk>
 <1980543.jviTh1pdNs@t460-skr>
In-Reply-To: <1980543.jviTh1pdNs@t460-skr>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 16 Jan 2019 11:15:02 -0700
Message-ID: <CAJCQCtTErRwS5Omb4Asob3sYx8Svt4yV8V5so7fcs+2BX8t3Gg@mail.gmail.com>
Subject: Re: question about creating a raid10
To:     Stefan K <shadow_7@gmx.net>
Cc:     Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 16, 2019 at 7:58 AM Stefan K <shadow_7@gmx.net> wrote:
>
>  :(
> that means when one jbod fail its there is no guarantee that it works fine? like in zfs? well that sucks
> Didn't anyone think to program it that way?

The mirroring is a function of the block group, not the block device.
And yes that's part of the intentional design and why it's so
flexible. A real raid10 isn't as flexible, so to enforce the
allocation of specific block group stripes to specific block devices
would add complexity to the allocator while reducing flexibility. It's
not impossible, it'd just come with caveats like no three device
raid10 like now; and you'd have to figure out what to do if the user
adds one new device instead of two at a time, and what if any new
device isn't the same size as existing devices or if you add two
devices that aren't the same size. Do you refuse to add such devices?
What limitations do we run into when rebalancing? It's way more
complicated.

Btrfs raid10 really should not be called raid10. It sets up the wrong
user expectation entirely. It's more like raid0+1, except even that is
deceptive because in theory a legit raid0+1 you can lose multiple
drives on one side of the mirror (but not both); but with Btrfs raid10
you really can't lose more than one drive. And therefore it does not
scale. The probability of downtime increases as drives are added;
whereas with a real raid10 downtime doesn't change.

In your case you're better off with raid0'ing the two drives in each
enclosure (whether it's a feature of the enclosure or doing it with
mdadm or LVM). And then using Btrfs raid1 on top of the resulting
virtual block devices. Or do mdadm/LVM raid10, and format it Btrfs. Or
yeah, use ZFS.

-- 
Chris Murphy
