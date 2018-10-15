Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA2F9C04AA5
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 20:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71D8F208B3
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 20:23:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="SryJMV5C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71D8F208B3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbeJPEJu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 00:09:50 -0400
Received: from mail-lj1-f173.google.com ([209.85.208.173]:44045 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbeJPEJu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 00:09:50 -0400
Received: by mail-lj1-f173.google.com with SMTP id v6-v6so18701504ljc.11
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2018 13:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=ntBLkbTqjG6zDPXS3ylVeGrnDCkLv6H7dFmbCP67IeI=;
        b=SryJMV5CSVVbAUZnErQfDXoGMF5PKh6eOxMdDM77MmgHxT2P1pzsHyA1j/PXzATq+Z
         WRnZ2F9xLZjzAyK4l/2OQOBTPUurYE++SIGmn8MkW1rSrjWs303mwHtpxBROPCPPZ/qi
         GBSISy46NNxxeuYmQLLWC9ncqr3JZ1wY1jJeVauKuXON0kwwHgseW4RhtEFfwre2VdWE
         Lrgt7dBgo0q1Bq1HgwA6ouxtFUUr5BVQwqNTuCe0CsAQmPsCcDOn7INlv9yNTnwtdCRg
         G84fsY8nh1D0WWhmOTEs78X7baF6TGTDmLzXMKh17JrGUA2n+OMedLnFqNttqpeVg+oO
         ldwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=ntBLkbTqjG6zDPXS3ylVeGrnDCkLv6H7dFmbCP67IeI=;
        b=tpXGI7L2+tUmZpaHOOvKvVHt+YuXoNs8Y93Gd/++OIhqQmRfdX5EkwGkEHvx0PVFCf
         kBbzFW7WTYQX4f6+JXnM9XzR6GKzJJWd+qt7dtp1icGbY+RZiG/aE5txHXno62Pl4u3R
         gHNaCjqfOdfbVSB+GmJsBV6TUF9EDez6KTfiofxUxcVYpbhDRjXj88icv3mJnkf5U53g
         ebd/Q0mgjpxKUbGZWDjDJeFJ7K22HIeVC2BYC0NId2BGRfrRGiL/GSbRN/ZPHNPfPicV
         UH8VRoSWZaN94yrHl4EJ550fd+miaWchm3XVdv3FkUTE82qTHO9KmsrtJ5i7pFzKPezs
         iphQ==
X-Gm-Message-State: ABuFfohgg3gzkRq917kaSp0TQA0taWFAx2WrtwcJak4ah9uKYIjj5TsS
        1MzaYzY/cZwrAgQHMKyka9OqvbL0nsGH2rK+uis9LNMapTM=
X-Google-Smtp-Source: ACcGV60DiruoXAca3ok11VIkFQ3gh+RDojBB+41UMiwP+xTSASZHZrKzoAbq6Cy3JEGJnPySZxHJIU4ccIq2HJTgJ3s=
X-Received: by 2002:a2e:7c18:: with SMTP id x24-v6mr11329920ljc.174.1539634980395;
 Mon, 15 Oct 2018 13:23:00 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Mon, 15 Oct 2018 13:22:59
 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
In-Reply-To: <20181015180546.4dd598bf0fe61b61f56e99ce@gmail.com>
References: <20181015180546.4dd598bf0fe61b61f56e99ce@gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 15 Oct 2018 14:22:59 -0600
X-Google-Sender-Auth: nwcG2tlPZRKRrJT0wMveKbYt_Hs
Message-ID: <CAJCQCtTHY8iKZefwr-yC5-mZ32JEr=EtpP1vMhoRXjDAGNhxhg@mail.gmail.com>
Subject: Re: Spurious mount point
To:     Anton Shepelev <anton.txt@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 15, 2018 at 9:05 AM, Anton Shepelev <anton.txt@gmail.com> wrote:
> Hello, all
>
> How can I track down the origin of this mount point:
>
>    /dev/sda2 on /home/hana type btrfs (rw,relatime,space_cache,subvolid=259,subvol=/@/.snapshots/1/snapshot/hana)
>
> if it is not present in /etc/fstab?  I shouldn't like to
> find/grep thoughout the whole filesystem.
>
> --
> ()  ascii ribbon campaign - against html e-mail
> /\  http://preview.tinyurl.com/qcy6mjc [archived]

Sounds like some service taking snapshots regularly is managing this.
Maybe this is Mint or Ubuntu and you're using Timeshift?

Maybe it'll show up in the journal if you add boot parameter
'systemd.log_level=debug' and reboot; then use 'journalctl -b | grep
mount' and it should show all instances logged instances of mount
events: systemd, udisks2, maybe others?



-- 
Chris Murphy
