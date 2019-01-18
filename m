Return-Path: <SRS0=o3FP=P2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45176C07EBF
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 19:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08F1120850
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 19:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbfART0S convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:26:18 -0500
Received: from mx0a-00296801.pphosted.com ([148.163.150.38]:53274 "EHLO
        mx0a-00296801.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728457AbfART0S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Jan 2019 14:26:18 -0500
Received: from pps.filterd (m0114581.ppops.net [127.0.0.1])
        by mx0a-00296801.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x0IJKoeL013438
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jan 2019 19:26:17 GMT
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        by mx0a-00296801.pphosted.com with ESMTP id 2pybmw6fud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jan 2019 19:26:17 +0000
Received: by mail-wr1-f69.google.com with SMTP id h11so7235737wrs.2
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jan 2019 11:26:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jVYdvFX94+WJ85U+gkAgiSNMD3mtv+8EGB8L9gAFXVE=;
        b=o5Q99VlyaVTVHqXL8kaT6qR59rkL9AJmMkAZCWQRjDb4hfq2okmo/wJP199rrKr+vp
         AO/YxWIUaaTpW1aUEFuPQP7RlICJsybS+iJmoAHxSSKuAw7WbJA74GvrzmqrC6VkjQyA
         l/BmZoetnK7f/7n8U2RpVvjL2I2yDL/Fg3UQN3bwYkwfAU0bh+GkQW2Y2paAa5NBqFGg
         JPTU+ftQSXL+i96OlyWA8IdtN5fA9YWg5wHfd2Up7EKoz0EnVWMbfuK4GFLPtQOvHja6
         Ers2EkIq802vEtAEFto9p6qwKJUQ+9+FNSRhHdriO/hnpGhxMpOh/43BNLknmDVxYDy8
         3l1g==
X-Gm-Message-State: AJcUukfbzrFzhrWDplngKMhvHI8h3M1eOe7BQV4L0kdGJ26bNYld+Qx8
        t5ai8l4LjFKOIZQx2pu8HaK7aHIUN8tVb8do8YJ5FM1vgbccWhcg/3SFTBHPBuPYicidU7OflvR
        XnvG2JjOL+zmQOnJHfFGd4rdAlYJ2jFlv3mxErgVHqTd0UdF4b6KgiW65w1lYjF4g
X-Received: by 2002:a1c:8d53:: with SMTP id p80mr17606671wmd.68.1547839574797;
        Fri, 18 Jan 2019 11:26:14 -0800 (PST)
X-Google-Smtp-Source: ALg8bN5zlewqHvGjN0/y24PiUV2UUkasSrCikDan3eUytYZpVQgsQLUpJQy3LvWCdJWpr+u6sijQx/Ht6gbkTNMV3+Q=
X-Received: by 2002:a1c:8d53:: with SMTP id p80mr17606656wmd.68.1547839574398;
 Fri, 18 Jan 2019 11:26:14 -0800 (PST)
MIME-Version: 1.0
References: <CA+VXTjgtyrWvpNd+5N_pz95s34LcwWLsUyVR-ioj28r81mHf_Q@mail.gmail.com>
 <CANQeFDCGSOzqXoWi+29PtuHj8jMhvLUVnbh0RVs_+oQ7GfVu4A@mail.gmail.com>
In-Reply-To: <CANQeFDCGSOzqXoWi+29PtuHj8jMhvLUVnbh0RVs_+oQ7GfVu4A@mail.gmail.com>
From:   Krishna Mannem <kmannem@pivotal.io>
Date:   Fri, 18 Jan 2019 14:26:03 -0500
Message-ID: <CA+VXTjgHEjBJxprJEjyvE9qzAuDaeHB1tqW-6Lm1R7noqocZMQ@mail.gmail.com>
Subject: Re: trouble with btrfs lockup
To:     Liu Bo <obuil.liubo@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-01-18_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1901180139
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thanks for the info, unfortunately because this was a prod environment
we had to recreate the vm. We'll respond to this thread with more what
you asked for when this happens next because it seems to be a common
occurrence for us.

On Fri, Jan 18, 2019 at 2:19 PM Liu Bo <obuil.liubo@gmail.com> wrote:
>
> On Fri, Jan 18, 2019 at 10:58 AM Krishna Mannem <kmannem@pivotal.io> wrote:
> >
> > Hi,
> >
> > I work on Concourse-CI (https://urldefense.proofpoint.com/v2/url?u=https-3A__concourse-2Dci.org_&d=DwIBaQ&c=lnl9vOaLMzsy2niBC8-h_K-7QJuNJEsFrzdndhuJ3Sw&r=pq-JLFZ85OYQ6hcu5J3yXUlGj4m8iHEWZ-T9iUoNipI&m=rJUavGsLrC-rXvaQ9BMhkGoHezgwsJJIY8ynWZvq_vo&s=CfAfR1rhxlqYpt5uPypCykcQ0URd7u36Xcq7qdmZJak&e=). It's a container
> > based CI system where we create volumes using Btrfs. Due to the nature
> > of Concourse, btrfs subvolumes are short lived ( sometimes a few
> > seconds if it's a small automation task, sometimes hours if its a long
> > build and test suite). We ran into a failure and we're not really sure
> > what to make of it. Looks like a lock failed to get acquired before
> > scheduling? We need another eye on this.
> >
> > >uname -a
> > Linux a06d0ae3-b242-4518-85ba-977426a3f214 4.15.0-43-generic
> > #46~16.04.1-Ubuntu SMP Fri Dec 7 13:31:08 UTC 2018 x86_64 x86_64
> > x86_64 GNU/Linux
> >
> > > btrfs df
> > btrfs filesystem df /var/vcap/data/baggageclaim/volumes
> > Data, single: total=263.01GiB, used=262.59GiB
> > System, DUP: total=8.00MiB, used=48.00KiB
> > Metadata, DUP: total=9.00GiB, used=6.60GiB
> > GlobalReserve, single: total=512.00MiB, used=0.00B
> >
> > Calltrace:
> > https://gist.github.com/kcmannem/3baf848845bc986f5ac7d23d3df51e56
>
> Can you please dump a "echo w > /proc/sysrq-trigger" so that
> developers can have a good understanding on what's going on?
>
> From the above info,
> 1. mm->mmap_sem is held
> 2. transaction is being committed and others are waiting for it.
> 3. subvolumes are deleted in short time which may make btrfs-cleaner
> thread busy as hell.
>
> thanks,
> liubo
