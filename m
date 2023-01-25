Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E954C54E94
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Jan 2023 10:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbjAYKpG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 25 Jan 2023 05:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235657AbjAYKpB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2023 05:45:01 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC0656EC5
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jan 2023 02:44:58 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id tz11so46540164ejc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jan 2023 02:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HPtM+j9w46aYKSVSUjdSXjgjXx+cBO1wsd6eef8rVNU=;
        b=JacZ+NA0eLMiA0dB+LUpuMJqEZvj8VGJsp9hK+JeEjmCkFhg3t4hJ9xZpy2Ovu7wtF
         GiOHZ8RFKV/tcBsx+Vf3TfI1fUmb+1paaSUJNHTieh9nQDDJGn818LFUvMwApj2kmF1F
         FdD5in+LXukKo1gzZofkYHLJDhavjh/zBwgPKapf4SJmTCyS6hKck3cKRkywsAF1ETZD
         WplJOuEOpa9auBdtBRTbAP21QW2uBMK/jIPpGjI+/Y5Os6QZXZkrGZAa48DniYVGluwa
         pVZWflPnfDhqO6veJXnuRjnElirisVqlPvwXVLnj8LJoJ4qqcMn1934c3NilMR1ux0an
         3PJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HPtM+j9w46aYKSVSUjdSXjgjXx+cBO1wsd6eef8rVNU=;
        b=7NjBgG5f0PmnodrwIYL06HXTG5RqZycu1sQehYX0UxsDDmShMars2xVwp01nzg80o3
         U9l5KxIHPI8tUv2e5SHV7dt6M3/H8AfNCiDyFlLy5z2b0WH/LS7nwqk/Ir5LzS+s9b5H
         BbyubFN0vhIjYmc7zNaqSG0ZuNJiwpt8YFmhdBPe9RqIoABOyQGh0ZSPbpu1iU8033pB
         Kpv0oOGRyHDGnUxJnlLsO24iMPIqnWofRw9Ki+0H43U78jvXad9qJtJK02kEtWIdEJlT
         eS+wh8iF5gFxylVHm/lJGIEHxY668fpt4yZmK+6sS/0DuHsaY5AyHVIkMYI3hfEhlnii
         Xs7w==
X-Gm-Message-State: AFqh2koVGJyKjpWIIphrvDsayP5QRPTYEieA8n82cnsubIVys1XnoiEw
        EBYSp6qgbMZiHcYg04atcn98ueWS/lnAOHa4UEf/BHWa
X-Google-Smtp-Source: AMrXdXtPrVMLRSE3fVT2KUXpVZ3o0kiTET4K4xC53xsn456azGBslBtUS/8njtvD8vAR1HSaF4LhcsQO5FfDwIogfzQ=
X-Received: by 2002:a17:906:12c2:b0:877:77fa:4266 with SMTP id
 l2-20020a17090612c200b0087777fa4266mr3319881ejb.395.1674643496780; Wed, 25
 Jan 2023 02:44:56 -0800 (PST)
MIME-Version: 1.0
References: <87a6271kbg.fsf@fsf.org>
In-Reply-To: <87a6271kbg.fsf@fsf.org>
From:   Patrik Lundquist <patrik.lundquist@gmail.com>
Date:   Wed, 25 Jan 2023 11:44:45 +0100
Message-ID: <CAA7pwKOXSNpS0o9DhFCgPH1JV-wiLptZ77MiS1Wqam5O3-yfFg@mail.gmail.com>
Subject: Re: balance stuck in loop on linux 6.1.7
To:     Ian Kelling <iank@fsf.org>
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 25 Jan 2023 at 02:48, Ian Kelling <iank@fsf.org> wrote:
>
> If I restart the balance, it will take about 2.8 days to get back to the
> stuck 11% point. The balance is still running, but I'm going to cancel
> it morning unless I hear from the list that there is some use to letting
> it run since it is wearing out the mechanical drives.

You can pause it instead of cancelling it.
