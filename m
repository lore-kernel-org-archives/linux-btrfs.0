Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00BA5ECDE47
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 16:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A52F120825
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 16:54:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="fxVf+Q5V"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A52F120825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbeKICaU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 21:30:20 -0500
Received: from mail-lf1-f44.google.com ([209.85.167.44]:47027 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbeKICaT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Nov 2018 21:30:19 -0500
Received: by mail-lf1-f44.google.com with SMTP id f23so10143476lfc.13
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Nov 2018 08:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=OGBBppKdiJ1IRajR84yunODOrqA2fVwNjS8wQvd8I/Y=;
        b=fxVf+Q5V+vyiNj4fpA8EKgxW2RfdUsQWCpFGLhyk53VNmMb7BLXhIl+9KsO3swbEO2
         OrX+MC18narBRrMTPZM5gPvyCbhd4sDYFxMqQUKVI2Xs17rYhmGLP3s/7S2AMJ4pqSOu
         02H0dawZ5EDeWDJRpbcpOqk2EtGk6NpIlls+q5vD8T87+LKjvXXFrVB44c2cD3Enjk1Q
         9ZVwgCPoMiLlzmMc6R1eL5dYECpLZrLbQ06Uky8sGbPO0IkOLdnG7z2WjaDfHGoqiX7s
         EwuLg0M27GWcq9TtcMHB9N1IWwmvDOcMCQKmU0sYfoA/5SYwkKw+hR6FWOfLaifeHO/r
         swIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=OGBBppKdiJ1IRajR84yunODOrqA2fVwNjS8wQvd8I/Y=;
        b=bI2eaMJe4rhnKAkLYZB516Z5Ync1DmLhFfqy8kXMBIzAWkwdeqJBFOsfg6CkRkNHOR
         j2nTbuZeNUPh/ZWS5jL4RLTUSuTRGqpP3UgIiINE0gCAaEd92KHTwstoGEKwxIpbiAQ+
         zLK+xdf5V+qz9bSrtxJMRQVU7VFZeTN3Gh2GIOG+djlri4Fujs0YhVlhpTOuxYS19+mn
         wuKMQrD9VXkLKvZpPgVlBx9pTMpY83MrPULHKlnWR1yanPOzikgoLVkLJ5Y9ZYivOqTs
         UZBmr2LuLKSjZL2Mmdpna0aKKHyEkCn5xJwQn+aJGyLqa4ja09MHJbEjtHwQpRvN7j42
         kQpw==
X-Gm-Message-State: AGRZ1gL3pGovkSbGnaCBeHbdbrezBTAFf9Bax2mK9guwi72TGNQ1Tx0t
        3E+hDsYyHQBeXScpiCp/Ahf6ytdRjUDS9S/7TQterPD1
X-Google-Smtp-Source: AJdET5cZ58k6LUJpaAdot+6ka/ZeIbuOUtny/jXYjFyZdRFnFIPSS6tV86Vq8Wex/L8LEGmxWtui3+x1viiK0jld2Bg=
X-Received: by 2002:a19:e01e:: with SMTP id x30mr3102333lfg.89.1541696036338;
 Thu, 08 Nov 2018 08:53:56 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab3:4f0d:0:0:0:0:0 with HTTP; Thu, 8 Nov 2018 08:53:55 -0800 (PST)
X-Originating-IP: [67.162.155.105]
In-Reply-To: <CAJzMQG3Ln50NiPLAE6tME8gXraKcKUJjTa9=LGGweRrcnDtyLg@mail.gmail.com>
References: <CAJzMQG2xPu7vy60qDjip+u93=3GU0v_ZXE9h8t_Tj1Vf6f5EnA@mail.gmail.com>
 <CAJCQCtTTBOdK5Z=7SDb8W+q7Px+kyLb6hAo06piw=zxDYtrSgA@mail.gmail.com>
 <CAJzMQG2mAfux8+ij9KqeOfmfN0b-_6kHzh3dwoofYExNk0KiAw@mail.gmail.com>
 <CAJCQCtSFnGz+M+xRNzajwdqFbhcAQtLAf8aAqB1xXcbvEd9j7g@mail.gmail.com>
 <CAJCQCtQiqUVNin9Ga7HB8oUrgwQ9h9V+etZLooqX3_Sb_KNz0Q@mail.gmail.com>
 <CAJzMQG1-cv6iNzw4jAv8QALo7Z2maapsyzPJOwALZks-=7HvFg@mail.gmail.com> <CAJzMQG3Ln50NiPLAE6tME8gXraKcKUJjTa9=LGGweRrcnDtyLg@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 8 Nov 2018 09:53:55 -0700
X-Google-Sender-Auth: PBmzkl8Cdcd2wUcXbdKEeGVCAK0
Message-ID: <CAJCQCtRkDe8Pb6-_MqBKBfc19Xe5kr3K5qvc466ece-X1tE13Q@mail.gmail.com>
Subject: Re: Where is my disk space ?
To:     Barbet Alain <alian123soleil@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 8, 2018 at 2:27 AM, Barbet Alain <alian123soleil@gmail.com> wrote:
> Hi !
> Just to give you end of the story:
> I move my /var/lib/docker to my home (other partition), and my space
> come back ...

I'm not sure why that would matter. Both btrfs du and regular du
showed only ~350M used in /var which is about what I'd expect. And
also the 'btrfs sub list' output doesn't show any subvolumes/snapshots
for Docker. The upstream Docker behavior on Btrfs is that it uses
subvolumes and snapshots for everything, quickly you'll see a lot of
them. However many distributions override the default Docker behavior,
e.g. with Docker storage setup, and will cause it to always favor a
particular driver. For example the Docker overlay2 driver, which
leverages kernel overlayfs, which will work on any file system
including Btrfs. And I'm not exactly sure where the upper dirs are
stored, but I'd be surprised if they're not in /var.

Anyway, if you're using Docker, moving stuff around will almost
certainly break it. And as I'm an extreme expert in messing up Docker
storage, I can vouch for the strategy of stopping the docker daemon,
recursively deleting everything in /var/lib/docker/ and then starting
Docker. Now you get to go fetch all your images again. And anyway, you
shouldn't be storing any data in the containers, they should be
throwaway things, important data should be stored elsewhere including
any state information for the container. :-D Avoid container misery by
having a workflow that expects containers to be transient disposable
objects.


-- 
Chris Murphy
