Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1A1C10F06
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 16:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C826222A1
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 16:34:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="OOMDnLC6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbfBOQee (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 11:34:34 -0500
Received: from mail-ot1-f54.google.com ([209.85.210.54]:36977 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfBOQed (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 11:34:33 -0500
Received: by mail-ot1-f54.google.com with SMTP id b3so17495756otp.4
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2019 08:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=stRk/mHz32PMMHXCbm5ZvfVxRsYZUmUeUqw9cuKRM5A=;
        b=OOMDnLC6WmCzd46ZW+Dl2HFPSydbj8zo7SHQARYjk3eI0f5sYNlPsGCjQdQjQcbhsb
         AQL5/YUC2jg5Hb6W0IfG1nzryFfVOLFXUjzuQeeKq0AV/bqoB754ChPCrzRCGwc+RB77
         HBU4ktBCOjNosCncPG6Co5hWHlPjviF3N8vtXuVjOgTpiQeq8KTU+s9akXL7pZLEA5O0
         w+ws47695peiHcwFuB9g44UwSR33W5p3xhTkp5LFzVMH3sODmZFMHX6DcOGZR8WZz3lA
         prBySzonMbePCYwwN2Douq1yKrPV6GfDPLEhNCChBtq4ACWxBOtgtQCbs0to2E5lLAl4
         EJdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=stRk/mHz32PMMHXCbm5ZvfVxRsYZUmUeUqw9cuKRM5A=;
        b=S/9EdUSzxJuHfI5doUaG/iQVdlyYHPEeSFAw9Mr1dq2vcPb8XhDWes8z5C0WYUPSiS
         vIAGtAICG9cIOIY6T+fkF6cM12AG3qykuNV8BA1SJRRSCdVY+knuy/+DbIy85TAILwW9
         Tz1EArDaKbv+iaYAqEiUHV5rs9VNeGPcysmHRAvJah5X48zJDNy+VQ9o91x/1cHAvgSM
         h7s2c+vraRnV1XJIsfey8rDg8s3BBzrzo43sOHaAEl7pm7zHMpEFTFl41hfbQm73v0xp
         VK3ctiAqsiph2bNNlpAnF+wuwnPianvGfBHLTZa2aDVPVDxwi8PKb+rrECNYpgzajvL6
         y/WQ==
X-Gm-Message-State: AHQUAuZ+jE28yan5ABT+kFFJudMRQ0vqgwYGDkqGDQLJzvSQHomPS94b
        zxBtdDaxBAPkdmPw4qNk+ZpgEGwME1OPdt/oYIWXeh/V
X-Google-Smtp-Source: AHgI3IbBRhw8TrJ37m4BD6657oUkrvm8niCTcX8mn1Hr/65/RoqkT8dz+R7FV2TYIFC574fl/R2yu+SAhgzIxPw4urc=
X-Received: by 2002:a9d:7493:: with SMTP id t19mr6095897otk.98.1550248473044;
 Fri, 15 Feb 2019 08:34:33 -0800 (PST)
MIME-Version: 1.0
References: <20190215095710.GA12279@linux-x5ow.site>
In-Reply-To: <20190215095710.GA12279@linux-x5ow.site>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 15 Feb 2019 08:34:22 -0800
Message-ID: <CAPcyv4ha4u4Fekee0oKqCTxYrySJEAMW3kVuHsTGHgw7i+5N5w@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] Software RAID Support for NV-DIMM
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     lsf-pc@lists.linux-foundation.org, linux-block@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>, linux-btrfs@vger.kernel.org,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 15, 2019 at 1:57 AM Johannes Thumshirn <jthumshirn@suse.de> wrote:
>
> (This is a joint proposal with Hannes Reinecke)
>
> Servers with NV-DIMM are slowly emerging in data centers but one key feature
> for reliability of these systems hasn't been addressed up to now, data
> redundancy.
>
> While it would be best to solve this issue in the memory controller of the CPU
> itself, I don't see this coming in the next few years. This puts us as the OS
> in the burden to create the redundant copies of data for the users.
>
> If we leave of the DAX support Linux' software RAID implementations (MD,
> device-mapper and BTRFS RAID) do already work on top of pmem devices, but they
> are incompatible with DAX.
>
> In this session Hannes and I would like to discuss eventual ways how we as an
> operating system can mitigate these issues for our users.

One feature request I have heard in this space is to at least have
filesystem metadata redundancy for DAX. For applications that can
handle their own data-replication the single-point-of-failure FS
metadata becomes a larger liability.
