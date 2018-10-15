Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17818C04AA5
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 21:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A52B6205F4
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 21:33:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="P1JK5yk/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A52B6205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbeJPFUX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 01:20:23 -0400
Received: from mail-lf1-f44.google.com ([209.85.167.44]:35958 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbeJPFUX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 01:20:23 -0400
Received: by mail-lf1-f44.google.com with SMTP id d4-v6so15249177lfa.3
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2018 14:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=ZG4SpHVTqTrtOrQg+jqR3UHwLEcTYhBacOtYLe0Fg+g=;
        b=P1JK5yk/8OfekDOPnxY5vclWHz1raNrIFJ7f/AinBzHpTlsG5rlnBymxBmFjKoarVZ
         pF0AHBb/1XDs7PZtYeAQpvXSw+Xr9T3FlpubJbwmgFv9Joz+O5g2culX1EjCiKi/o4QL
         d7qucAHpwsMwxAxr10yiUBCAYVx+Tl78nbXnDDGqUEl7xHy3U6lsBcPtzDjFWWN4dDJt
         BUWZvjk/JMBxKx+vJ9pm51S2EppD80LPxPwKUxEkeKTx22osO5dzYPezRRw4NgGeyJ2v
         6DSaMVTw6GTQDOQOUdb6Lxqcoaii7wAsJdBVk+vltUHyzLCQsOfsUxOiY8GAepp0pDAX
         lLZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=ZG4SpHVTqTrtOrQg+jqR3UHwLEcTYhBacOtYLe0Fg+g=;
        b=OunWtfOFIqdUT2zAcWNVmmjnAFyh6TKnGOBHqgeVZ0E2ZibhRLu80/coVqUR+gzKnT
         /i4DYySrnjAUa7Sr9+H6p5fW+rb3/mT4fWvCwvrinpNNAZyMDKPQE3F/0zCJW0KAt1RH
         fqGo1cgjazyGFPYk+6zF+uO1pxcFVeh+ibRheGYmR5VgxCR0/XLQNSRByG3Npq2CDpE4
         nH1a06OUj8Jq8nH3kF//zQxQN4oDC5QEGY9evS5gCOtZwoFeFeJtEdYCM8c8QILj34lY
         eUJSjhsUgXJabHNAiMRRCJYUdnISpjNcbFWs7JOzvenDodioWKQgpGZXtPggSB/Zlq1Y
         SRYA==
X-Gm-Message-State: ABuFfojvarBmMx9WyGj11+7pt56zdIxTQ7bFGKZGR7VxNLWw5MBYB/nO
        CtIr8aWAJxkZgIz/p79VvPec4ITCFCfHPpnhpXayoA==
X-Google-Smtp-Source: ACcGV60z1KgM6EqhiMgVCUjTMDsH0yIgi76ytudiJNlKi2USjjLhxcRDECdJN0wjruaSipW6iWtexgYZIW33uvVBb8U=
X-Received: by 2002:a19:98c1:: with SMTP id a184-v6mr10486757lfe.94.1539639198969;
 Mon, 15 Oct 2018 14:33:18 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Mon, 15 Oct 2018 14:33:18
 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
In-Reply-To: <20181016002601.5517a4ea66c2c9c5dbdb5471@gmail.com>
References: <20181015180546.4dd598bf0fe61b61f56e99ce@gmail.com>
 <CAJCQCtSz+=uwXUFGxagoUOYxy99eCJGG-ezLVh0RO=vL=LReEg@mail.gmail.com> <20181016002601.5517a4ea66c2c9c5dbdb5471@gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 15 Oct 2018 15:33:18 -0600
X-Google-Sender-Auth: 9A2bhkCcorvBtKS_h0jp-wZrzQE
Message-ID: <CAJCQCtR0zVDOS8u5zN2Ddo4+orrx62-L9e5GUnM=OWcwSitftQ@mail.gmail.com>
Subject: Re: Spurious mount point
To:     Anton Shepelev <anton.txt@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 15, 2018 at 3:26 PM, Anton Shepelev <anton.txt@gmail.com> wrote:
> Chris Murphy to Anton Shepelev:
>
>> > How can I track down the origin of this mount point:
>> >
>> > /dev/sda2 on /home/hana type btrfs (rw,relatime,space_cache,subvolid=259,subvol=/@/.snapshots/1/snapshot/hana)
>> >
>> > if it is not present in /etc/fstab?  I shouldn't like to
>> > find/grep thoughout the whole filesystem.
>>
>> Sounds like some service taking snapshots regularly is
>> managing this.  Maybe this is Mint or Ubuntu and you're
>> using Timeshift?
>
> It is SUSE Linux and (probably) its tool called `snapper',
> but I have not found a clue in its documentation.

I wasn't aware that SUSE was now using the @ location for snapshots,
or that it was using Btrfs for /home. For a while it's been XFS with a
Btrfs sysroot.





-- 
Chris Murphy
